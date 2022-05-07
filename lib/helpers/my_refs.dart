import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

final userNofificationRef = FirebaseFirestore.instance
    .collection('userData')
    .doc(uid)
    .collection('notifications');
final userDataRef = FirebaseFirestore.instance.collection('userData');
