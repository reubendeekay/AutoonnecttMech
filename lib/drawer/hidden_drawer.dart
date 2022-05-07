import 'package:flutter/material.dart';
import 'package:mechanic_admin/drawer/drawer_widget.dart';
import 'package:mechanic_admin/home/homepage.dart';

import 'package:flutter/services.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HidenDrawer extends StatefulWidget {
  const HidenDrawer({Key? key}) : super(key: key);

  @override
  State<HidenDrawer> createState() => _HidenDrawerState();
}

class _HidenDrawerState extends State<HidenDrawer> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawingOpen;
  // int dely = 300;
  bool isDragging = false;

  void onpenDrawer() {
    setState(() {
      xOffset = 300;
      yOffset = 70;
      scaleFactor = 0.85;
      isDrawingOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawingOpen = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).getCurrentUser(uid);
    return Scaffold(
        backgroundColor: const Color(0xFF04123F),
        body: Stack(children: [
          DrawerWidget(
            closdDrawer: closeDrawer,
          ),
          buildpage()
        ]));
  }

  Widget buildpage() {
    return GestureDetector(
      onHorizontalDragStart:
          isDrawingOpen ? (details) => isDragging = true : null,
      onHorizontalDragUpdate: isDrawingOpen
          ? (details) {
              if (!isDragging) return;
              const delta = 1;
              if (details.delta.dx > delta) {
                // onpenDrawer();
              } else if (details.delta.dx < -delta) {
                closeDrawer();
              }
            }
          : null,
      onTap: closeDrawer,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawingOpen ? 30 : 0),
            child: Homepage(
              opendrawer: onpenDrawer,
            ),
          )),
    );
  }
}
