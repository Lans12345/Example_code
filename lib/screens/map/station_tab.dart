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
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
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
                                    fontSize: 14,
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
