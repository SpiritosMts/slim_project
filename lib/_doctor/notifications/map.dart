


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker extends StatefulWidget {
  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker> {
  final Completer<GoogleMapController> gMapctr = Completer();

  LatLng pos = Get.arguments['pos'];

  @override
  void initState() {

    print('## pos: $pos');

    super.initState();
  }
  // {
  // 'userID':'3K2reSQKHQoFlbLtrTtE',
  // 'userName':'hama olwany',
  // 'time':'18:45 18/08/2022',
  // 'alertType':'blood',
  // 'alertValue':'50',
  // 'lat':'20',
  // 'lng':'20',
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Location"),
        centerTitle: true,
        backgroundColor: Color(0xff024855),
        elevation: 10,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ///map
            GoogleMap(
              zoomControlsEnabled: false,

              onMapCreated: (GoogleMapController controller) {
                gMapctr.complete(controller);
              },
              initialCameraPosition: CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 16.0),
              markers: {
                  Marker(
                    draggable: true,
                    markerId: const MarkerId('markerID'),
                    position: LatLng(pos.latitude, pos.longitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure
                    ),
                  ),
                }),

          ],
        ),
      ),
    );
  }
}

