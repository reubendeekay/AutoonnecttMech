import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/horizontal_tab.dart';
import 'package:mechanic_admin/mechanic/manage_bookings/widgets/manage_booking_tile.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

class ManageBookingsScreen extends StatelessWidget {
  ManageBookingsScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/manage-bookings';

  List<String> tabs = [
    'Ongoing',
    'Completed',
    'Denied',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Requests'),
        // automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
      ),
      body: HorizontalTabView(
        initialIndex: 0,
        contentScrollAxis: Axis.horizontal,
        backgroundColor: Colors.grey.shade100,
        tabs: List.generate(tabs.length, (index) => Tab(text: tabs[index])),
        contents: List.generate(
          tabs.length,
          (index) => StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .doc('mechanics')
                  .collection(uid)
                  .where('status', isEqualTo: tabs[index].toLowerCase())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;
                return ListView(
                  children: List.generate(
                    docs.length,
                    (index) => ManageBookingsTile(
                      booking: RequestModel.fromJson(docs[index]),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
