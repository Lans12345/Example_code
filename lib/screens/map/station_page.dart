import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_new/services/cloud_function/add_comment.dart';
import 'package:the_serve_new/services/cloud_function/add_ratings.dart';
import 'package:the_serve_new/widgets/button_widget.dart';
import 'package:the_serve_new/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class StationPage extends StatefulWidget {
  @override
  State<StationPage> createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  final box = GetStorage();

  final commentController = TextEditingController();

  showToast() {
    Fluttertoast.showToast(
        msg: "Comment sent succesfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  late String name = '';
  late String profilePicture = '';

  getData() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    var querySnapshot = await collection.get();

    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        name = data['name'];
        profilePicture = data['profilePicture'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Providers')
        .doc(box.read('uid'))
        .snapshots();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Station',
            ),
            Tab(
              text: 'Products',
            ),
          ]),
          backgroundColor: Colors.blue,
          title: TextRegular(
              text: box.read('service'), fontSize: 18, color: Colors.white),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: userData,
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      dynamic data = snapshot.data;

                      List rev = data['reviews'];
                      print(rev);
                      print(FirebaseAuth.instance.currentUser!.uid);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data['logo']))),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextBold(
                              text: data['name'],
                              fontSize: 18,
                              color: Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          TextRegular(
                              text: data['contactNumber'],
                              fontSize: 12,
                              color: Colors.grey),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: TextFormField(
                              maxLines: 5,
                              controller: commentController,
                              decoration: const InputDecoration(
                                hintText: ' Leave a comment',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ButtonWidget(
                              onPressed: () {
                                addComment(
                                    name, commentController.text, data['id']);
                                showToast();
                                commentController.clear();
                              },
                              text: 'Send'),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final text = 'sms:${data['contactNumber']}';
                                  if (await canLaunch(text)) {
                                    await launch(text);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                  ),
                                  height: 40,
                                  width: 75,
                                  child: Center(
                                      child: TextBold(
                                          text: 'MESSAGE',
                                          fontSize: 14,
                                          color: Colors.black)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final text = 'tel:${data['contactNumber']}';
                                  if (await canLaunch(text)) {
                                    await launch(text);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                  ),
                                  height: 40,
                                  width: 75,
                                  child: Center(
                                      child: TextBold(
                                          text: 'CALL',
                                          fontSize: 14,
                                          color: Colors.black)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final text = 'https:${data['url']}';
                                  if (await canLaunch(text)) {
                                    await launch(text);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                  ),
                                  height: 40,
                                  width: 75,
                                  child: Center(
                                      child: TextBold(
                                          text: 'URL',
                                          fontSize: 14,
                                          color: Colors.black)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final text = 'mailto:${data['email']}';
                                  if (await canLaunch(text)) {
                                    await launch(text);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                  ),
                                  height: 40,
                                  width: 75,
                                  child: Center(
                                      child: TextBold(
                                          text: 'EMAIL',
                                          fontSize: 14,
                                          color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: ExpansionTile(
                              title: TextBold(
                                  text: 'View Ratings',
                                  fontSize: 14,
                                  color: Colors.amber),
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Ratings')
                                        .where('uid', isEqualTo: data['id'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        print('error');
                                        return const Center(
                                            child: Text('Error'));
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        print('waiting');
                                        return const Padding(
                                          padding: EdgeInsets.only(top: 50),
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: Colors.black,
                                          )),
                                        );
                                      }

                                      final data111 = snapshot.requireData;
                                      return SizedBox(
                                        height: 250,
                                        child: ListView.builder(
                                            itemCount: snapshot.data?.size ?? 0,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                subtitle: TextRegular(
                                                    text:
                                                        '${data111.docs[index]['star']} ★',
                                                    fontSize: 12,
                                                    color: Colors.amber),
                                                title: TextBold(
                                                    text: data111.docs[index]
                                                        ['name'],
                                                    fontSize: 14,
                                                    color: Colors.black),
                                                trailing: TextRegular(
                                                    text: data111.docs[index]
                                                        ['date'],
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                                leading: CircleAvatar(
                                                  minRadius: 25,
                                                  maxRadius: 25,
                                                  backgroundImage: NetworkImage(
                                                      data111.docs[index]
                                                          ['profilePicture']),
                                                ),
                                                tileColor: Colors.white,
                                              );
                                            }),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          rev.contains(
                                      FirebaseAuth.instance.currentUser!.uid) !=
                                  true
                              ? MaterialButton(
                                  minWidth: 150,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  color: Colors.amber,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: SizedBox(
                                              width: 80,
                                              height: 100,
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextBold(
                                                      text:
                                                          'Rate Service Provider',
                                                      fontSize: 18,
                                                      color: Colors.amber),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Center(
                                                    child: RatingBar.builder(
                                                      initialRating: 5,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 0.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) async {
                                                        var collection =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Providers')
                                                                .where('id',
                                                                    isEqualTo:
                                                                        data[
                                                                            'id']);

                                                        var querySnapshot =
                                                            await collection
                                                                .get();

                                                        for (var queryDocumentSnapshot
                                                            in querySnapshot
                                                                .docs) {
                                                          Map<String, dynamic>
                                                              data1 =
                                                              queryDocumentSnapshot
                                                                  .data();

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Providers')
                                                              .doc(data['id'])
                                                              .update({
                                                            'reviews': FieldValue
                                                                .arrayUnion([
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                            ]),
                                                            'ratings': data1[
                                                                    'ratings'] +
                                                                rating,
                                                            'nums':
                                                                data1['nums'] +
                                                                    1,
                                                          });
                                                        }

                                                        addRatings(
                                                            name,
                                                            rating.toInt(),
                                                            data['id'],
                                                            profilePicture);

                                                        Navigator.pop(context);

                                                        print(rating);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: TextRegular(
                                    text: 'Rate Provider',
                                    fontSize: 14,
                                    color: Colors.white,
                                  ))
                              : const SizedBox(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('uid', isEqualTo: box.read('uid'))
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      itemCount: snapshot.data?.size ?? 0,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: ListTile(
                            title: TextBold(
                                text: data.docs[index]['name'],
                                fontSize: 14,
                                color: Colors.black),
                            trailing: TextBold(
                                text: data.docs[index]['price'],
                                fontSize: 12,
                                color: Colors.grey),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              minRadius: 20,
                              maxRadius: 20,
                              backgroundImage:
                                  NetworkImage(data.docs[index]['imageURL']),
                            ),
                            tileColor: Colors.white,
                          ),
                        );
                      })),
                );
              }),
        ]),
      ),
    );
  }
}
