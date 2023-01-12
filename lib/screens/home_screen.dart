import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_new/auth/login_page.dart.dart';
import 'package:the_serve_new/screens/map/map_screen.dart';
import 'package:the_serve_new/screens/terms_conditions_page.dart';
import 'package:the_serve_new/widgets/service_container.dart';
import 'package:the_serve_new/widgets/text_widget.dart';
import 'dart:math' as math;

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final box = GetStorage();

  List<Color> color = [
    Colors.blue,
    Colors.red,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TermsPage()));
            },
            icon: const Icon(Icons.info),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Logout Confirmation',
                            style: TextStyle(
                                fontFamily: 'QBold',
                                fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            'Are you sure you want to Logout?',
                            style: TextStyle(fontFamily: 'QRegular'),
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ));
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
          backgroundColor: Colors.blue,
          title: TextRegular(
              text: 'Service Providers', fontSize: 18, color: Colors.white),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Categ').snapshots(),
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
              return GridView.builder(
                  itemCount: snapshot.data?.size ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ServiceContainer(
                          onTap: () {
                            box.write('service', data.docs[index]['name']);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MapScreen()));
                          },
                          label: data.docs[index]['name'],
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1),
                          icon: Icons.category_rounded),
                    );
                  });
            }));
  }
}
