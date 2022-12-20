import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final box = GetStorage();

  int _currentIndex = 0;

  final tabs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextRegular(
            text: box.read('service'), fontSize: 18, color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Container(
            color: Colors.white30,
            height: 100,
            width: double.infinity,
            child: ListView.builder(
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        iconSize: 25,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.map,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              label: '${box.read('service')} Maps'),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.drive_eta_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              label: '${box.read('service')} Table'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
