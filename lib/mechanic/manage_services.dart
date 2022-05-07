import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/mechanic/edit_service.dart';
import 'package:mechanic_admin/mechanic/service_tile.dart';
import 'package:mechanic_admin/models/mechanic_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({Key? key, required this.mechanic})
      : super(key: key);
  final MechanicModel mechanic;

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  @override
  Widget build(BuildContext context) {
    final mechanic = Provider.of<AuthProvider>(context, listen: false).mechanic;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Services'),
          backgroundColor: kPrimaryColor,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return await Provider.of<AuthProvider>(context, listen: false)
                .getMechanicDetails(uid)
                .then((_) => setState(() {}));
          },
          child: ListView(
            children: List.generate(
                mechanic!.services!.length,
                (index) => InkWell(
                    onTap: () {
                      Get.to(() => EditServiceScreen(
                          service: mechanic.services![index]));
                    },
                    child: ServiceTile(mechanic.services![index]))),
          ),
        ));
  }
}
