import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/my_refs.dart';
import 'package:mechanic_admin/models/notification_model.dart';
import 'package:mechanic_admin/notifications/notifications_tile.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: userNofificationRef.orderBy('createdAt').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No Notifications'),
              );
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text('No Notifications'),
              );
            }
            return ListView(
                children: List.generate(
                    docs.length,
                    (index) => NotificationsTile(
                          notification:
                              NotificationsModel.fromJson(docs[index]),
                        )));
          }),
    );
  }
}
