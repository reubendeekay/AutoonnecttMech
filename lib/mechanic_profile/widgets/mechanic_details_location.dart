import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/mechanic_profile/widgets/my_marker.dart';

class MechanicLocation extends StatefulWidget {
  final LatLng? location;
  final String? imageUrl;
  const MechanicLocation({Key? key, this.location, this.imageUrl})
      : super(key: key);
  @override
  _MechanicLocationState createState() => _MechanicLocationState();
}

class _MechanicLocationState extends State<MechanicLocation> {
  final GlobalKey globalKey = GlobalKey();
  GoogleMapController? mapController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    mapController!.setMapStyle(value);

    _markers.add(Marker(
      markerId: const MarkerId('1'),
      icon: await MarkerIcon.downloadResizePictureCircle(
          widget.imageUrl ??
              'https://www.kenyans.co.ke/files/styles/article_style/public/images/media/mechanic_admin.jpg?itok=-c2o5ygc',
          borderSize: 10,
          size: 130,
          addBorder: true,
          borderColor: kPrimaryColor),
      position: LatLng(widget.location!.latitude, widget.location!.longitude),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  MyMarker(globalKey),
                  GoogleMap(
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(widget.location!.latitude,
                            widget.location!.longitude),
                        zoom: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
