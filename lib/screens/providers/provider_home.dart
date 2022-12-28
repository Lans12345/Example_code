import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_new/auth/providers/provider_login.dart';
import 'package:the_serve_new/screens/providers/add_product_provider.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

import '../terms_conditions_page.dart';

class ProviderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TermsPage()));
            },
            icon: const Icon(Icons.info),
          ),
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.post_add_rounded),
              text: 'Products',
            ),
            Tab(
              icon: Icon(Icons.feedback),
              text: 'Feedbacks',
            ),
            Tab(
              icon: Icon(Icons.star),
              text: 'Ratings',
            ),
          ]),
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
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProviderLogin()));
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
          title: TextRegular(text: 'Home', fontSize: 18, color: Colors.white),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          Scaffold(
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddProduct()));
                }),
            body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                  return ListView.builder(
                      itemCount: snapshot.data?.size ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: TextBold(
                                text: data.docs[index]['name'],
                                fontSize: 14,
                                color: Colors.black),
                            subtitle: TextBold(
                                text: data.docs[index]['desc'],
                                fontSize: 12,
                                color: Colors.grey),
                            trailing: IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Products')
                                    .doc(data.docs[index].id)
                                    .delete();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            leading: CircleAvatar(
                              minRadius: 25,
                              maxRadius: 25,
                              backgroundImage:
                                  NetworkImage(data.docs[index]['imageURL']),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        );
                      });
                }),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Comments')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                return ListView.builder(
                    itemCount: snapshot.data?.size ?? 0,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: TextRegular(
                              text: data.docs[index]['comment'],
                              fontSize: 12,
                              color: Colors.black),
                          subtitle: TextRegular(
                              text: data.docs[index]['name'],
                              fontSize: 10,
                              color: Colors.grey),
                        ),
                      );
                    }));
              }),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Ratings')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                return ListView.builder(
                    itemCount: snapshot.data?.size ?? 0,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        subtitle: TextRegular(
                            text: '${data.docs[index]['star']} ★',
                            fontSize: 12,
                            color: Colors.amber),
                        title: TextBold(
                            text: data.docs[index]['name'],
                            fontSize: 14,
                            color: Colors.black),
                        trailing: TextRegular(
                            text: data.docs[index]['date'],
                            fontSize: 12,
                            color: Colors.grey),
                        leading: CircleAvatar(
                          minRadius: 25,
                          maxRadius: 25,
                          backgroundImage:
                              NetworkImage(data.docs[index]['profilePicture']),
                        ),
                        tileColor: Colors.white,
                      );
                    }));
              })
        ]),
      ),
    );
  }
}
