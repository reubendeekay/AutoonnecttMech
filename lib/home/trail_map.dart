import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:marker_icon/marker_icon.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/loading_screen.dart';
import 'package:mechanic_admin/home/actions_sheet.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:mechanic_admin/providers/location_provider.dart';
import 'package:mechanic_admin/providers/mechanic_provider.dart';
import 'package:provider/provider.dart';

class TrailMapScreen extends StatefulWidget {
  final RequestModel request;
  const TrailMapScreen(this.request, {Key? key}) : super(key: key);
  @override
  _TrailMapScreenState createState() => _TrailMapScreenState();
}

class _TrailMapScreenState extends State<TrailMapScreen> {
  // late GoogleMapController mapController;
  Set<Marker> _markers = {};
  // ignore: prefer_final_fields
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
//Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = const PolylineId("1");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
    });
  }

//google cloud api key
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyDxbfpRGmq3Wjex1SfTXwySuxQaCiQZxUM");

  void _onMapCreated(GoogleMapController controller) async {
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData;
    _markers.addAll([
      Marker(
        markerId: MarkerId(widget.request.id!),
        onTap: () {},
        icon: await MarkerIcon.downloadResizePictureCircle(
            widget.request.user!.imageUrl!,
            borderSize: 10,
            size: 100,
            addBorder: true,
            borderColor: kPrimaryColor),
        position: LatLng(widget.request.userLocation!.latitude,
            widget.request.userLocation!.longitude),
        infoWindow: InfoWindow(title: widget.request.user!.fullName!),
      ),
      Marker(
        markerId: MarkerId(widget.request.id!),
        onTap: () {},
        icon: await MarkerIcon.downloadResizePictureCircle(
            widget.request.user!.imageUrl!,
            borderSize: 10,
            size: 80,
            addBorder: true,
            borderColor: kPrimaryColor),
        position: LatLng(loc!.latitude!, loc.longitude!),
        infoWindow: InfoWindow(title: widget.request.user!.fullName!),
      ),
    ]);

    var _coordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(loc.latitude!, loc.longitude!),
        destination: LatLng(widget.request.userLocation!.latitude,
            widget.request.userLocation!.longitude),
        mode: RouteMode.driving);
    _addPolyline(_coordinates!);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData;

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<LocationData>(
              stream: Location.instance.onLocationChanged,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.time == loc!.time) {
                    if (GeoPoint(snapshot.data!.latitude!,
                            snapshot.data!.latitude!) ==
                        widget.request.userLocation) {
                      FirebaseFirestore.instance
                          .collection('userData')
                          .doc('bookings')
                          .collection(widget.request.user!.userId!)
                          .doc(widget.request.id)
                          .update({'status': 'arrived'});
                      FirebaseFirestore.instance
                          .collection('requests/mechanics/$uid')
                          .doc(widget.request.id)
                          .update({'status': 'arrived'});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You have reached your destination'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                    // MechanicModel mechanic = widget.request.mechanic!;

                    // mechanic.location !=
                    //     GeoPoint(
                    //         snapshot.data!.latitude!, snapshot.data!.longitude!);
                    // FirebaseFirestore.instance
                    //     .collection('userData')
                    //     .doc('bookings')
                    //     .collection(widget.request.user!.userId!)
                    //     .doc(widget.request.id)
                    //     .update({'mechanic': mechanic.toJson()});
                  }
                }
                return GoogleMap(
                  // myLocationEnabled: true,
                  onMapCreated: _onMapCreated,

                  markers: _markers,
                  polylines: _polylines.values.toSet(),

                  initialCameraPosition: CameraPosition(
                      target: LatLng(loc!.latitude!, loc.longitude!), zoom: 16),
                );
              }),
          Positioned(
            left: 15,
            right: 15,
            top: 10,
            child: InkWell(
              onTap: () {
                actionSheet(context, widget.request);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.request.user!.fullName}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Heading to destination',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.request.user!.imageUrl!)),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          actionSheet(context, widget.request);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

Future completeRequest(BuildContext context, RequestModel request) async {
  final size = MediaQuery.of(context).size;
  await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Center(
                child: Text('Request Completion for ${request.user!.fullName!}',
                    style: const TextStyle(color: Colors.black))),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/complete.json',
                    repeat: false,
                    height: 100,
                  ),
                  const Text(
                      'This will mark the request as completed and will prompt the driver for payment. This action is irreversible.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey)),
                ],
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: size.width * 0.23,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green.withOpacity(0.8),
                  ),
                  child: const Center(
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // Navigator.of(context).pop();
                  await Provider.of<MechanicProvider>(context, listen: false)
                      .completeBooking(request);
                  Get.offAll(() => const InitialLoadingScreen());
                },
                child: Container(
                  width: size.width * 0.23,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.red.withOpacity(0.8),
                  ),
                  child: const Center(
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                width: 25,
              )
            ],
          ));
}
