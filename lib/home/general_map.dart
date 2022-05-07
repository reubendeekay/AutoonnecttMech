import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/location_provider.dart';
import 'package:mechanic_admin/widgets/my_popup.dart';
import 'package:provider/provider.dart';

class GeneralMapScreen extends StatefulWidget {
  const GeneralMapScreen({Key? key, required this.request}) : super(key: key);
  final RequestModel request;

  @override
  State<GeneralMapScreen> createState() => _GeneralMapScreenState();
}

class _GeneralMapScreenState extends State<GeneralMapScreen> {
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    mapController!.setMapStyle(value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () => showMyPopup(context, widget.request));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    var _locationData = Provider.of<LocationProvider>(
      context,
    ).locationData;
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(_locationData!.latitude!, _locationData.longitude!),
            zoom: 15),
      ),
    );
  }
}
