import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechanic_admin/helpers/loading_screen.dart';
import 'package:mechanic_admin/home/trail_map.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:mechanic_admin/providers/chat_provider.dart';
import 'package:mechanic_admin/providers/location_provider.dart';
import 'package:mechanic_admin/widgets/my_popup.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Homepage extends StatefulWidget {
  Homepage({Key? key, this.opendrawer}) : super(key: key);
  VoidCallback? opendrawer;
  static const routeName = '/home';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController? mapController;

  Set<Marker> _markers = <Marker>{};
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    if (mounted) {
      String value = await DefaultAssetBundle.of(context)
          .loadString('assets/map_style.json');
      mapController!.setMapStyle(value);
    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    var _locationData = Provider.of<LocationProvider>(
      context,
    ).locationData;

    final size = MediaQuery.of(context).size;
    Provider.of<AuthProvider>(context, listen: false)
        .getCurrentUser(FirebaseAuth.instance.currentUser!.uid);
    Provider.of<ChatProvider>(context, listen: false).getChats();

    return Scaffold(
      key: _key,
      // drawer: const SideDrawer(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requests/mechanics/$uid')
                .snapshots(),
            builder: (context, snapshot) {
              // if (!snapshot.hasData ) {

              return Stack(
                children: [
                  // MyMarker(globalKey),
                  _locationData == null
                      ? const LoadingScreen()
                      : GoogleMap(
                          markers: _markers,
                          onMapCreated: _onMapCreated,
                          mapType: MapType.normal,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(_locationData.latitude!,
                                  _locationData.longitude!),
                              zoom: 15),
                        ),

                  Positioned(
                    left: 10,
                    right: 0,
                    top: 10,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.all(5.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: widget.opendrawer,
                                child: const Icon(
                                  Icons.menu,
                                  color: Colors.grey,
                                  size: 25,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (snapshot.hasData &&
                      snapshot.data!.docs
                          .where((element) => element['status'] == 'ongoing')
                          .isNotEmpty)
                    TrailMapScreen(
                      RequestModel.fromJson(snapshot.data!.docs.first),
                    ),

                  if (snapshot.hasData &&
                      snapshot.data!.docs
                          .where((element) => element['status'] == 'pending')
                          .isNotEmpty)
                    MyPopDialog(
                      request: RequestModel.fromJson(snapshot.data!.docs
                          .where((element) => element['status'] == 'pending')
                          .first),
                    ),
                ],
              );
              // }

              // List<DocumentSnapshot> docs = snapshot.data!.docs;

              // return GeneralMapScreen(
              //   request: RequestModel.fromJson(docs.first),
              // );
            }),
      ),
    );
  }
}
