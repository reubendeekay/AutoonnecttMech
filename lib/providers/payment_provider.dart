import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mechanic_admin/helpers/my_refs.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/models/service_model.dart';

class PaymentProvider with ChangeNotifier {
  double _price = 0;
  double get price => _price;

  String _message = '';
  String get message => _message;
  bool isInit = false;
  List<ServiceModel> _services = [];
  List<ServiceModel> get services => _services;

  void initiliasePrice(double initPrice) {
    _price = initPrice;
  }

  Future<void> addService(ServiceModel service) async {
    if (_services.contains(service)) {
      _services.remove(service);

      notifyListeners();
      return;
    }
    _services.add(service);
    notifyListeners();
  }

  Future<void> updatePayment(RequestModel request, String amount) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('mechanics')
        .collection(request.mechanic!.id!)
        .doc(request.id!)
        .update({'status': 'updated', 'amount': amount});

    await FirebaseFirestore.instance
        .collection('userData')
        .doc('bookings')
        .collection(request.user!.userId!)
        .doc(request.id!)
        .update({'status': 'updated', 'amount': amount});
    await userDataRef
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc()
        .set({
      'imageUrl':
          'https://thumbor.forbes.com/thumbor/fit-in/x/https://www.forbes.com/advisor/in/wp-content/uploads/2021/07/rupee-4395554_1280-e1626070973451.jpg',
      'message':
          '${request.mechanic!.name} has updated your payment. Please comply if correct else report the mechanic',
      'createdAt': Timestamp.now(),
      'type':'payment',
      'id': request.id!,
    });
  }
}
