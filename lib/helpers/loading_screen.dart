import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic_admin/drawer/hidden_drawer.dart';

import 'package:mechanic_admin/mechanic/mechanic_register_screen.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:mechanic_admin/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Lottie.asset(
            'assets/map.json',
          )),
    );
  }
}

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({Key? key}) : super(key: key);

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser(uid);
      final user = Provider.of<AuthProvider>(context, listen: false).user;

      await Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation()
          .then((_) async {
        //TO DO: Navigate to HomePage
        if (user!.isMechanic!) {
          Get.off(() => const HidenDrawer());
        } else {
          await Fluttertoast.showToast(
              msg:
                  'You are not a mechanic. Register as a mechanic to continue.');

          Get.to(() => const MechanicRegisterScreen());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Lottie.asset(
          'assets/map.json',
        )),
      ),
    );
  }
}
