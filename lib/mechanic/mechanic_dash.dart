import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/auth/auth_screen.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/manage_bookings/manage_bookings_screen.dart';
import 'package:mechanic_admin/mechanic/add_service.dart';
import 'package:mechanic_admin/mechanic/manage_services.dart';
import 'package:mechanic_admin/mechanic_profile/edit_profile_screen.dart';
import 'package:mechanic_admin/models/mechanic_model.dart';
import 'package:mechanic_admin/providers/admin_user_provider.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:mechanic_admin/providers/invoice_provider.dart';

import 'package:provider/provider.dart';

class MechanicDashboard extends StatefulWidget {
  const MechanicDashboard({Key? key}) : super(key: key);

  @override
  MechanicDashboardState createState() => MechanicDashboardState();
}

class MechanicDashboardState extends State<MechanicDashboard> {
  int selectedPos = 1;

  @override
  void initState() {
    super.initState();
    selectedPos = 1;
    Future.delayed(Duration.zero, () async {
      final mechanic =
          Provider.of<AuthProvider>(context, listen: false).mechanic;

      await Provider.of<AdminUserProvider>(context, listen: false)
          .getAllTransactions(mechanic!);
    });
  }

  Widget getItem(String name, IconData icon, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 16,
                    ),
                    Icon(
                      icon,
                      size: 20,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  onTap();
                },
                icon: const Icon(Icons.keyboard_arrow_right),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final mechanic = Provider.of<AuthProvider>(context).mechanic;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Mechanic Dashboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const EditMechanicDetails());
                        },
                        child: SizedBox(
                          width: width,
                          child: CachedNetworkImage(
                            imageUrl: mechanic!.profile!,
                            height: height * 0.3,
                            width: width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: height * 0.225,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const SizedBox(
                                width: 24,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const EditMechanicDetails());
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        mechanic.profile!),
                                    radius: width * 0.15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    mechanic.name!,
                                    style: TextStyle(
                                      fontSize: width * 0.05,
                                    ),
                                  ),
                                  Text(
                                    mechanic.address!,
                                    style: TextStyle(
                                      fontSize: width * 0.035,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          getItem(
                              'Add Services',
                              Icons.dashboard_customize,
                              () => Get.to(() => const AddServices(
                                    isDashboard: true,
                                  ))),
                          getItem('Manage Services', Icons.admin_panel_settings,
                              () {
                            Get.to(
                                () => ManageServicesScreen(mechanic: mechanic));
                          }),
                          getItem('Manage Bookings', Icons.event_seat_outlined,
                              () => Get.to(() => ManageBookingsScreen())),
                          getItem('Invoices', Icons.bar_chart, () async {
                            final invoice = Provider.of<AdminUserProvider>(
                                    context,
                                    listen: false)
                                .invoice;

                            final pdfFile =
                                await PdfInvoiceApi.generate(invoice);

                            PdfApi.openFile(pdfFile);
                          }),
                          getItem('Log out', Icons.logout, () async {
                            Get.offAll(() => const AuthScreen());
                            await FirebaseAuth.instance.signOut();
                          }),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
