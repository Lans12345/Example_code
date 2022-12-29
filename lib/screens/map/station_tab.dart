import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_new/screens/map/station_page.dart';

import '../../widgets/text_widget.dart';

class StationTab extends StatefulWidget {
  @override
  State<StationTab> createState() => _StationTabState();
}

class _StationTabState extends State<StationTab> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    _determinePosition();
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

  final cntrlr = TextEditingController();

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
    return Column(
      children: [
        const SizedBox(
          height: 20,
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

              return Expanded(
                child: SizedBox(
                  child: ListView.builder(
                      itemCount: snapshot.data?.size ?? 0,
                      itemBuilder: ((context, index) {
                        double rate = (data.docs[index]['ratings'] /
                            data.docs[index]['nums']);
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                subtitle: TextRegular(
                                    text: '${rate.toStringAsFixed(2)} ★',
                                    fontSize: 12,
                                    color: Colors.amber),
                                onTap: () {
                                  box.write('uid', data.docs[index].id);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => StationPage()));
                                },
                                leading: Container(
                                  height: 80,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              data.docs[index]['logo']))),
                                ),
                                title: TextBold(
                                    text: data.docs[index]['name'],
                                    fontSize: 18,
                                    color: Colors.black),
                                trailing: TextRegular(
                                    text:
                                        '${calculateDistance(lat, long, data.docs[index]['lat'], data.docs[index]['lang']).toStringAsFixed(2)}km',
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              );
            })
      ],
    );
  }
}
