import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_serve_new/screens/map/map_tab.dart';
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

  final tabs = [MapTab()];

  final cntrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextRegular(
            text: box.read('service'), fontSize: 18, color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black),
              ),
              width: double.infinity,
              height: 50,
              child: TextFormField(
                controller: cntrlr,
                decoration: const InputDecoration(
                  hintText: 'Search a station',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SizedBox(
              child: ListView.builder(itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Container(
                          color: Colors.black,
                          height: 80,
                          width: 100,
                        ),
                        title: TextBold(
                            text: 'Station Name',
                            fontSize: 14,
                            color: Colors.black),
                        trailing: TextRegular(
                            text: '100km', fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              })),
            ),
          )
        ],
      ),
      // body: SafeArea(child: tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        iconSize: 25,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              label: 'Maps'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.drive_eta_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              label: 'Table'),
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
