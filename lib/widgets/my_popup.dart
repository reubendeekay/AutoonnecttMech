import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_beautiful_popup/main.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/home/trail_map.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

void showMyPopup(BuildContext context, RequestModel request) {
  final popup = BeautifulPopup(
    context: context,
    template: TemplateGeolocation,
  );
  popup.show(
    title: 'New Driver Request',
    // close: Material(
    //   color: Colors.transparent,
    //   child: IconButton(
    //       onPressed: () {
    //         FirebaseFirestore.instance
    //             .collection('userData')
    //             .doc('bookings')
    //             .collection(request.user!.userId!)
    //             .doc(request.id)
    //             .update({'status': 'denied'});
    //         Navigator.of(context).pop();
    //       },
    //       icon: const Icon(Icons.close)),
    // ),
    content:
        'You have received a new driver request from ${request.user!.fullName}',

    actions: [
      popup.button(
          label: 'Accept',
          onPressed: () async {
            // Get.to(() => TrailMapScreen(request));
            Navigator.of(context).pop();

            FirebaseFirestore.instance
                .collection('requests/mechanics/$uid')
                .doc(request.id)
                .update({
              'status': 'ongoing',
            });
            FirebaseFirestore.instance
                .collection('userData')
                .doc('bookings')
                .collection(request.user!.userId!)
                .doc(request.id)
                .update({'status': 'ongoing'});
            FirebaseFirestore.instance
                .collection('mechanics')
                .doc(request.mechanic!.id)
                .update({'isBusy': true});
          }),
      popup.button(
        label: 'Deny',
        outline: true,
        onPressed: () async {
          FirebaseFirestore.instance
              .collection('/requests/mechanics/$uid')
              .doc(request.id)
              .update({
            'status': 'denied',
          });
          FirebaseFirestore.instance
              .collection('userData')
              .doc('bookings')
              .collection(request.user!.userId!)
              .doc(request.id)
              .update({'status': 'denied'});
          Navigator.of(context).pop();
        },
      ),
    ],
    // bool barrierDismissible = false,
    // Widget close,
  );
}

class MyPopDialog extends StatefulWidget {
  const MyPopDialog({Key? key, required this.request}) : super(key: key);
  final RequestModel request;
  @override
  State<MyPopDialog> createState() => _MyPopDialogState();
}

class _MyPopDialogState extends State<MyPopDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () => showMyPopup(context, widget.request));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
    );
  }
}
