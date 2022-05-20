import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/chat/chat_room.dart';
import 'package:mechanic_admin/drawer/report_screen.dart';
import 'package:mechanic_admin/home/trail_map.dart';
import 'package:mechanic_admin/home/update_invoice.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/models/user_model.dart';
import 'package:mechanic_admin/providers/chat_provider.dart';
import 'package:mechanic_admin/providers/mechanic_provider.dart';
import 'package:provider/provider.dart';

void actionSheet(BuildContext context, RequestModel request) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                    child: const Text("ACTIONS",
                        style: TextStyle(
                            letterSpacing: 0.3, fontWeight: FontWeight.bold))),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    FontAwesomeIcons.comment,
                    size: 20,
                  ),
                  title: const Text(
                    "Chat",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                  onTap: () async {
                    final users =
                        Provider.of<ChatProvider>(context, listen: false)
                            .contactedUsers;
                    List<String> room = users.map<String>((e) {
                      return e.chatRoomId!.contains(
                              FirebaseAuth.instance.currentUser!.uid +
                                  '_' +
                                  request.user!.userId!)
                          ? FirebaseAuth.instance.currentUser!.uid +
                              '_' +
                              request.user!.userId!
                          : request.user!.userId! +
                              '_' +
                              FirebaseAuth.instance.currentUser!.uid;
                    }).toList();
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(request.user!.userId!)
                        .get()
                        .then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(ChatRoom.routeName, arguments: {
                        'user': UserModel(
                          userId: value['userId'],
                          fullName: value['fullName'],
                          imageUrl: value['profilePic'],
                          isMechanic: value['isMechanic'],
                          lastSeen: value['lastSeen'],
                          isOnline: value['isOnline'],
                        ),
                        'chatRoomId': room.isEmpty
                            ? FirebaseAuth.instance.currentUser!.uid +
                                '_' +
                                request.user!.userId!
                            : room.first,
                      });
                    });
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.call,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();

                    await FlutterPhoneDirectCaller.callNumber(
                        request.user!.phoneNumber!);
                  },
                  title: const Text(
                    "Call",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onTap: () async {
                    await Provider.of<MechanicProvider>(context, listen: false)
                        .arrived(request);
                    Navigator.of(context).pop();
                  },
                  title: const Text(
                    "Confirm Arrival",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    Provider.of<MechanicProvider>(context, listen: false)
                        .cancelRequest(request);
                  },
                  title: const Text(
                    "Cancel Request",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.cloud_upload_outlined,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    completeRequest(context, request);
                  },
                  title: const Text(
                    "Complete Request",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.credit_card_outlined,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (ctx) => UpdateInvoice(
                              request: request,
                            ));
                  },
                  title: const Text(
                    "Update payment",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.report_outlined,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => ReportScreen(request: request));
                  },
                  title: const Text(
                    "Report User",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
