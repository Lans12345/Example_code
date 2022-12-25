import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/text_widget.dart';

class MapTab extends StatefulWidget {
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  @override
  void initState() {
    super.initState();
    getLocation();
    _determinePosition();

    print(lat);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  GoogleMapController? mapController;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void dispose() {
    super.dispose();
  }

  late Polyline _poly;

  addPolyline(double lat1, double lang2, Color color) {
    _poly = Polyline(
        color: color,
        polylineId: const PolylineId('lans'),
        points: [
          // User Location
          LatLng(lat, long),
          LatLng(lat1, lang2),
        ],
        width: 4);
  }

  late double lat = 0;
  late double long = 0;

  var hasLoaded = false;
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (!mounted) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;

        hasLoaded = true;
      });
    }

    addPolyline(0, 0, Colors.transparent);
  }

  final box = GetStorage();

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );

    return Column(
      children: [
        hasLoaded
            ? Expanded(
                child: GoogleMap(
                  myLocationEnabled: true,
                  polylines: {_poly},
                  mapType: MapType.normal,
                  initialCameraPosition: kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Providers')
                .where('type', isEqualTo: box.read('service'))
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print('error');
                return const Center(child: Text('Error'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('waiting');
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                );
              }

              final data = snapshot.requireData;
              return Container(
                color: Colors.white30,
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: snapshot.data?.size ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(data.docs[index]['lat'],
                                        data.docs[index]['lang']),
                                    zoom: 16)));

                            setState(() {
                              addPolyline(data.docs[index]['lat'],
                                  data.docs[index]['lang'], Colors.blue);
                            });
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              width: 180,
                              height: 50,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      minRadius: 18,
                                      maxRadius: 18,
                                      backgroundImage: NetworkImage(
                                          data.docs[index]['logo']),
                                      backgroundColor: Colors.grey,
                                    ),
                                    title: TextBold(
                                        text: data.docs[index]['name'],
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextBold(
                                      text:
                                          '${calculateDistance(lat, long, data.docs[index]['lat'], data.docs[index]['lang']).toStringAsFixed(2)}kms away, ${(calculateDistance(lat, long, data.docs[index]['lat'], data.docs[index]['lang']) / 55).toStringAsFixed(2)}mins',
                                      fontSize: 12,
                                      color: Colors.black),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
              );
            }),
      ],
    );
  }
}
