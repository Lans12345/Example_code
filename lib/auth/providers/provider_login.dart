import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_new/auth/signup_page.dart.dart';
import 'package:the_serve_new/screens/home_screen.dart';
import 'package:the_serve_new/widgets/text_widget.dart';

class ProviderLogin extends StatefulWidget {
  const ProviderLogin({Key? key}) : super(key: key);

  @override
  State<ProviderLogin> createState() => _ProviderLoginState();
}

class _ProviderLoginState extends State<ProviderLogin> {
  late String email;

  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 10),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'QRegular'),
                  onChanged: (input) {
                    email = input;
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontFamily: 'QRegular',
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: TextFormField(
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'QRegular'),
                  onChanged: (input) {
                    password = input;
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'QRegular',
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minWidth: 250,
                color: Colors.blue,
                onPressed: () async {
                  late var status;
                  try {
                    var collection = FirebaseFirestore.instance
                        .collection('Users')
                        .where('email', isEqualTo: email);

                    var querySnapshot = await collection.get();
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);

                    setState(() {
                      for (var queryDocumentSnapshot in querySnapshot.docs) {
                        Map<String, dynamic> data =
                            queryDocumentSnapshot.data();
                        status = data['status'];
                      }
                    });

                    if (status == 'Deleted') {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: TextRegular(
                                    text: "Your account has been deleted!",
                                    color: Colors.black,
                                    fontSize: 12),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: TextBold(
                                        text: 'Close',
                                        color: Colors.black,
                                        fontSize: 12),
                                  ),
                                ],
                              ));
                      await FirebaseAuth.instance.signOut();
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    }
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: TextRegular(
                                  text: "$e",
                                  color: Colors.black,
                                  fontSize: 12),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: TextBold(
                                      text: 'Close',
                                      color: Colors.black,
                                      fontSize: 12),
                                ),
                              ],
                            ));
                  }
                },
                child: TextBold(
                    text: 'Login as Provider',
                    fontSize: 18,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextRegular(
                      text: "Haven't registered yet?",
                      fontSize: 14,
                      color: Colors.grey),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignupPage()));
                    },
                    child: TextBold(
                        text: "Register now",
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
