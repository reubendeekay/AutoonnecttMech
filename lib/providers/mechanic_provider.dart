import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:mechanic_admin/helpers/my_refs.dart';
import 'package:mechanic_admin/models/mechanic_model.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/models/service_model.dart';

class MechanicProvider with ChangeNotifier {
  List<MechanicModel>? _mechanics;
  List<MechanicModel>? get mechanics => _mechanics;

  Future<void> deleteService(String serviceId, String mechanicId) async {
    final results = await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .get();

    final oldService =
        results['services'].firstWhere((element) => element['id'] == serviceId);

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({
      'services': FieldValue.arrayRemove([oldService])
    });

    notifyListeners();
  }

  Future<void> editService(ServiceModel services, String mechanicId,
      ServiceModel previousService) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? serviceUrl;
    if (services.imageFile != null) {
      final servResult = await FirebaseStorage.instance
          .ref('mechanics/$uid/services/')
          .putFile(services.imageFile!);
      serviceUrl = await servResult.ref.getDownloadURL();
    }

    final mech = await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .get();
    List myServ = mech['services'];
    final index =
        myServ.indexWhere((element) => element['id'] == previousService.id);
    myServ.removeAt(index);
    myServ.insert(index, {
      'serviceName': services.serviceName,
      'price': services.price,
      'imageUrl': serviceUrl ?? services.imageUrl,
      'id': UniqueKey().toString(),
    });

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({'services': myServ});
    notifyListeners();
  }

  Future<void> addService(
      List<ServiceModel> services, String mechanicId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    List<String> serviceUrls = [];
    await Future.forEach(services, <File>(service) async {
      final servResult = await FirebaseStorage.instance
          .ref('mechanics/$uid/services/')
          .putFile(service!.imageFile!);
      String servUrl = await servResult.ref.getDownloadURL();
      serviceUrls.add(servUrl);
    });
    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({
      'services': FieldValue.arrayUnion(
        List.generate(
            services.length,
            (i) => {
                  'serviceName': services[i].serviceName,
                  'price': services[i].price,
                  'imageUrl': serviceUrls[i],
                  'id': UniqueKey().toString(),
                }),
      )
    });
    notifyListeners();
  }

  Future<void> confirmRequest({String? userId, String? docId}) async {
    final mechanicId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('mechanics')
        .collection(mechanicId)
        .doc(docId)
        .update({'status': 'completed'});

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(userId!)
        .doc(docId)
        .update({'status': 'completed'});

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .collection('account')
        .doc('analytics')
        .update({
      'pendingRequests': FieldValue.increment(-1),
      'completedRequests': FieldValue.increment(1)
    });

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({'isBusy': true});
    await userDataRef.doc(userId).collection('notifications').doc(docId).set({
      'imageUrl':
          'https://previews.123rf.com/images/sarahdesign/sarahdesign1509/sarahdesign150900627/44517835-confirm-icon.jpg',
      'message': 'Your booking has been confirmed by the mechanic',
      'type': 'booking',
      'createdAt': Timestamp.now(),
      'id': docId,
    });

    notifyListeners();
  }

  Future<void> completeBooking(RequestModel request) async {
    final mechanicId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('mechanics')
        .collection(mechanicId)
        .doc(request.id!)
        .update({'status': 'completed'});

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(request.user!.userId!)
        .doc(request.id!)
        .update({'status': 'completed'});

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({'isBusy': false});
    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(request.mechanic!.id)
        .collection('account')
        .doc('analytics')
        .update({
      'pendingRequests': FieldValue.increment(-1),
      'completedRequests': FieldValue.increment(1)
    });
    await userDataRef
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc()
        .set({
      'imageUrl':
          'https://previews.123rf.com/images/sarahdesign/sarahdesign1509/sarahdesign150900627/44517835-confirm-icon.jpg',
      'message': 'Your booking has been confirmed by the mechanic',
      'type': 'booking',
      'createdAt': Timestamp.now(),
      'id': request.id!,
    });
    notifyListeners();
  }

  Future<void> cancelRequest(RequestModel request) async {
    final mechanicId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('requests')
        .doc('mechanics')
        .collection(mechanicId)
        .doc(request.id)
        .update({'status': 'cancelled'});

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(request.user!.userId!)
        .doc(request.id)
        .update({'status': 'cancelled'});

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .collection('account')
        .doc('analytics')
        .update({
      'pendingRequests': FieldValue.increment(-1),
      'cancelledRequests': FieldValue.increment(1)
    });

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({'isBusy': false});
    await userDataRef
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc(request.id)
        .set({
      'imageUrl':
          'https://previews.123rf.com/images/sarahdesign/sarahdesign1509/sarahdesign150900627/44517835-confirm-icon.jpg',
      'message': 'Your booking has been cancelled by the mechanic',
      'type': 'booking',
      'createdAt': Timestamp.now(),
      'id': request.id,
    });

    notifyListeners();
  }

  Future<void> arrived(RequestModel request) async {
    final mechanicId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('requests')
        .doc('mechanics')
        .collection(mechanicId)
        .doc(request.id)
        .update({'status': 'arrived'});

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(request.user!.userId!)
        .doc(request.id)
        .update({'status': 'arrived'});

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({'isBusy': false});
    await userDataRef
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc(request.id)
        .set({
      'imageUrl':
          'https://previews.123rf.com/images/sarahdesign/sarahdesign1509/sarahdesign150900627/44517835-confirm-icon.jpg',
      'message': 'Your booking has been cancelled by the mechanic',
      'type': 'booking',
      'createdAt': Timestamp.now(),
      'id': request.id,
    });

    notifyListeners();
  }
}
