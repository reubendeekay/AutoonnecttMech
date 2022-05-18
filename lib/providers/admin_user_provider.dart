import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mechanic_admin/helpers/my_refs.dart';
import 'package:mechanic_admin/models/invoice_models.dart';
import 'package:mechanic_admin/models/mechanic_model.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

final mechanicRequestsRef =
    FirebaseFirestore.instance.collection('requests').doc('mechanics');

class AdminUserProvider with ChangeNotifier {
  Invoice? _invoice;
  Invoice get invoice => _invoice!;

  Future<void> registerMechanic(MechanicModel mech) async {
    //GETTING USER ID OF CURRENT USER USING THE APP
    final uid = FirebaseAuth.instance.currentUser!.uid;
    List<String> imageUrls = [];

//UPLOADING IMAGES TO FIREBASE STORAGE
    final profileResult = await FirebaseStorage.instance
        .ref('mechanics/$uid')
        .putFile(mech.profileFile!);

    //getting url of image
    String profileUrl = await profileResult.ref.getDownloadURL();
    final permitResult = await FirebaseStorage.instance
        .ref('mechanics/$uid/permit')
        .putFile(mech.profileFile!);

    //getting url of image
    String permitUrl = await permitResult.ref.getDownloadURL();
    final nationalResult = await FirebaseStorage.instance
        .ref('mechanics/$uid/permit')
        .putFile(mech.profileFile!);

    //getting url of image
    String nationalUrl = await nationalResult.ref.getDownloadURL();

    await Future.wait(mech.fileImages!.map((file) async {
      final result =
          await FirebaseStorage.instance.ref('mechanics/$uid/').putFile(file);
      String url = await result.ref.getDownloadURL();
      imageUrls.add(url);
    }).toList());

    List<String> serviceUrls = [];
    await Future.forEach(mech.services!, <File>(service) async {
      final servResult = await FirebaseStorage.instance
          .ref('mechanics/$uid/services/')
          .putFile(service!.imageFile!);
      String servUrl = await servResult.ref.getDownloadURL();
      serviceUrls.add(servUrl);
    });

//UPLOADING mechanic Data TO FIREBASE DATABASE

    await FirebaseFirestore.instance.collection('mechanics').doc(uid).set({
      'name': mech.name,
      'phone': mech.phone,
      'address': mech.address,
      'description': mech.description,
      'openingTime': mech.openingTime,
      'closingTime': mech.closingTime,
      'location': mech.location,
      'profile': profileUrl,
      'permit': permitUrl,
      'nationalId': nationalUrl,
      'status': 'pending',
      'images': imageUrls,
      'isBusy': false,
      'services': mech.services!.isEmpty
          ? []
          : List.generate(
              mech.services!.length,
              (i) => {
                    'serviceName': mech.services![i].serviceName,
                    'price': mech.services![i].price,
                    'imageUrl': serviceUrls[i],
                    'id': UniqueKey().toString(),
                  }),
    });

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(uid)
        .collection('account')
        .doc('analytics')
        .set({
      'requests': 0,
      'rating': 0,
      'ratingCount': 0,
      'pendingRequests': 0,
      'completedRequests': 0,
      'balance': 0,
      'totalEarnings': 0,
    });

    notifyListeners();
  }

  Future<void> updateMechanic(MechanicModel mech) async {
    //GETTING USER ID OF CURRENT USER USING THE APP
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? profileUrl;
    List<String> imagesUrl = [];

//UPLOADING IMAGES TO FIREBASE STORAGE
    if (mech.profileFile != null) {
      final profileResult = await FirebaseStorage.instance
          .ref('mechanics/$uid')
          .putFile(mech.profileFile!);

      //getting url of image
      profileUrl = await profileResult.ref.getDownloadURL();
    }
    if (mech.fileImages!.isNotEmpty) {
      await Future.wait(mech.fileImages!.map((file) async {
        final result =
            await FirebaseStorage.instance.ref('mechanics/$uid/').putFile(file);
        String url = await result.ref.getDownloadURL();
        imagesUrl.add(url);
      }).toList());

      await Future.forEach(mech.fileImages!, <File>(imageFile) async {
        final servResult = await FirebaseStorage.instance
            .ref('mechanics/$uid/images/')
            .putFile(imageFile!);
        String imageUrl = await servResult.ref.getDownloadURL();
        imagesUrl.add(imageUrl);
      });
    }

//UPLOADING mechanic Data TO FIREBASE DATABASE

    await FirebaseFirestore.instance.collection('mechanics').doc(uid).update({
      'name': mech.name,
      'phone': mech.phone,
      'address': mech.address,
      'description': mech.description,
      'openingTime': mech.openingTime,
      'closingTime': mech.closingTime,
      'location': mech.location,
      'profile': profileUrl ?? mech.profile!,
      'images': imagesUrl.isEmpty ? mech.images : imagesUrl,
    });

    notifyListeners();
  }

  Future<void> getAllTransactions(MechanicModel mechanic) async {
    final results = await mechanicRequestsRef.collection(uid).get();

    List<RequestModel> requests =
        results.docs.map((doc) => RequestModel.fromJson(doc)).toList();

    _invoice = Invoice(
        info: InvoiceInfo(
          date: DateTime.now(),
          dueDate: DateTime.now(),
          description: 'All transacations to date',
          number: mechanic.id!.substring(0, 11),
        ),
        supplier: Supplier(
            name: mechanic.name!,
            address: mechanic.address!,
            paymentInfo: 'Mpesa'),
        customer: const Customer(name: 'From all Customers'),
        items: requests
            .map((k) => InvoiceItem(
                description: k.services!.first.serviceName!,
                date: k.date!,
                quantity: 1,
                name: k.user!.fullName!,
                unitPrice: double.parse(k.services!.first.price!)))
            .toList());
    notifyListeners();
  }

  Future<void> reportUser(RequestModel request) async {
    final mechanicId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('mechanics')
        .collection(mechanicId)
        .doc(request.id!)
        .update({'status': 'reported'});

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(request.user!.userId!)
        .doc(request.id)
        .update({'status': 'reported'});

    await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(mechanicId)
        .update({'isBusy': true});
    await userDataRef
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc(request.id)
        .set({
      'imageUrl':
          'https://previews.123rf.com/images/sarahdesign/sarahdesign1509/sarahdesign150900627/44517835-confirm-icon.jpg',
      'message': 'Mechanic ${request.mechanic!.name!} has reported you',
      'type': 'booking',
      'createdAt': Timestamp.now(),
      'id': request.id,
    });
    notifyListeners();
  }
}
