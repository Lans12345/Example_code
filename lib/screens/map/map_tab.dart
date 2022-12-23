import 'dart:async';

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
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void dispose() {
    super.dispose();
  }

  late double lat = 0;
  late double long = 0;

  var hasLoaded = false;
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      long = position.longitude;

      hasLoaded = true;
    });
  }

  final box = GetStorage();

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
                  mapType: MapType.normal,
                  initialCameraPosition: kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
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
                          onTap: () {},
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
                                    leading: const CircleAvatar(
                                      minRadius: 18,
                                      maxRadius: 18,
                                      backgroundColor: Colors.grey,
                                    ),
                                    title: TextBold(
                                        text: 'Name of Shop',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextBold(
                                      text: '100kms away, 1.71mins',
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
