import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_serve_new/auth/providers/provider_login.dart';
import 'package:the_serve_new/services/cloud_function/add_comp.dart';
import 'package:the_serve_new/widgets/button_widget.dart';
import 'package:the_serve_new/widgets/text_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../screens/terms_conditions_page.dart';

class ProviderSignup extends StatefulWidget {
  const ProviderSignup({Key? key}) : super(key: key);

  @override
  State<ProviderSignup> createState() => _ProviderSignupState();
}

class _ProviderSignupState extends State<ProviderSignup> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    determinePosition();
  }

  late String address;

  var imageUrls = [];

  Future<Position> determinePosition() async {
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

  late String name;

  late String contactNumber;

  late String email;

  late String password;

  late String url;

  var hasLoaded = false;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';
  var imageUrlsPermit = [];
  var course = 'Laundry Shops';

  var dropDownValue1 = 0;

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Logo/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Logo/$fileName')
            .getDownloadURL();

        imageUrls.add(imageURL);

        setState(() {
          hasLoaded = true;
        });

        Fluttertoast.showToast(
            msg: 'Image added! You can upload multiple images');

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  late double lat = 0;
  late double long = 0;

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  late String open = '';

  late String close = '';
  var isObscure = true;
  var isObscure1 = true;
  late String forgotPassword = '';

  var hasLoaded1 = false;

  late String fileName1 = '';

  late File imageFile1;

  late String imageURL1 = '';

  Future<void> uploadPicture1(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName1 = path.basename(pickedImage.path);
      imageFile1 = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Permit/$fileName')
            .putFile(imageFile1);
        imageURL1 = await firebase_storage.FirebaseStorage.instance
            .ref('Permit/$fileName')
            .getDownloadURL();

        imageUrlsPermit.add(imageURL1);

        setState(() {
          hasLoaded1 = true;
        });

        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Image added! You can upload multiple images');
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            hasLoaded
                ? GestureDetector(
                    onTap: () {
                      uploadPicture('gallery');
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      minRadius: 50,
                      maxRadius: 50,
                      backgroundImage: NetworkImage(imageUrls[0]),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      uploadPicture('gallery');
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      minRadius: 50,
                      maxRadius: 50,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 5,
            ),
            TextRegular(
                text: 'Picture of Establishment',
                fontSize: 12,
                color: Colors.grey),
            // Image.asset(
            //   'assets/images/signup.gif',
            //   height: 180,
            // ),
            const SizedBox(height: 20),
            TextBold(
                text: 'Store/Shop Information',
                fontSize: 18,
                color: Colors.black),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: TextFormField(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  name = input;
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Store/Shop Name',
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
                keyboardType: TextInputType.number,
                maxLength: 11,
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  contactNumber = input;
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Store/Shop Contact Number',
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
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  url = input;
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.web,
                    color: Colors.black,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Website/Facebook/Instagram Link',
                  labelStyle: const TextStyle(
                    fontFamily: 'QRegular',
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            TextRegular(text: 'Sector', fontSize: 12, color: Colors.black),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Categ').snapshots(),
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
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                        child: DropdownButton(
                          underline: Container(color: Colors.transparent),
                          iconEnabledColor: Colors.black,
                          isExpanded: true,
                          value: dropDownValue1,
                          items: [
                            for (int i = 0; i < data.size; i++)
                              DropdownMenuItem(
                                onTap: () {
                                  course = data.docs[i]['name'];
                                },
                                value: i,
                                child: Center(
                                    child: Row(children: [
                                  Text(data.docs[i]['name'],
                                      style: const TextStyle(
                                        fontFamily: 'QRegular',
                                        color: Colors.black,
                                      ))
                                ])),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              dropDownValue1 = int.parse(value.toString());
                            });
                          },
                        ),
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: TextFormField(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  open = input;
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.timelapse_rounded,
                    color: Colors.black,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Opening hours',
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
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  close = input;
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.timelapse_rounded,
                    color: Colors.black,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Closing hours',
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
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  address = input;
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Address',
                  labelStyle: const TextStyle(
                    fontFamily: 'QRegular',
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextRegular(
                text: 'Picture to Business Permit/Other Permits',
                fontSize: 12,
                color: Colors.grey),
            const SizedBox(
              height: 5,
            ),
            hasLoaded1
                ? GestureDetector(
                    onTap: () {
                      uploadPicture1('gallery');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: NetworkImage(imageUrlsPermit[0]),
                            fit: BoxFit.cover),
                      ),
                      height: 100,
                      width: 100,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      uploadPicture1('gallery');
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.black,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 20),
            TextBold(
                text: 'Login Credentials', fontSize: 18, color: Colors.black),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: TextFormField(
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  email = input;
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
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
                obscureText: isObscure,
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  password = input;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: TextFormField(
                obscureText: isObscure1,
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'QRegular'),
                onChanged: (input) {
                  forgotPassword = input;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure1 = !isObscure1;
                      });
                    },
                    icon: Icon(
                      isObscure1 ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'Confirm Password',
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
                LocationPermission permission;
                permission = await Geolocator.requestPermission();

                bool serviceEnabled;

                // Test if location services are enabled.
                serviceEnabled = await Geolocator.isLocationServiceEnabled();

                permission = await Geolocator.requestPermission();

                if (name == '' ||
                    contactNumber == '' ||
                    email == '' ||
                    password == '' ||
                    forgotPassword == '') {
                  Fluttertoast.showToast(
                      msg: 'Cannot procceed with missing fields!');
                } else {
                  if (password == forgotPassword) {
                    if (serviceEnabled == true) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                        addComp(
                            name,
                            contactNumber,
                            email,
                            url,
                            imageUrls,
                            lat,
                            long,
                            course,
                            close,
                            open,
                            address,
                            imageUrlsPermit);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: SizedBox(
                                    height: 300,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline_outlined,
                                          size: 75,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextBold(
                                            text: 'Registered Succesfully!',
                                            fontSize: 18,
                                            color: Colors.black),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        ButtonWidget(
                                            onPressed: () async {
                                              await FirebaseAuth
                                                  .instance.currentUser!
                                                  .sendEmailVerification();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ProviderLogin()));

                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Verification was sent to your email\nPlease verify your account');
                                            },
                                            text: 'Continue'),
                                      ],
                                    )),
                              );
                            });
                      } catch (e) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                    e.toString(),
                                    style:
                                        const TextStyle(fontFamily: 'QRegular'),
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Close',
                                        style: TextStyle(
                                            fontFamily: 'QRegular',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ));
                        await Geolocator.requestPermission();
                      }
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                                content: const Text(
                                  'Cannot Proceed. Location is off',
                                  style: TextStyle(fontFamily: 'QRegular'),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ));
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'Password do not match');
                  }
                }
                print(lat);
              },
              child:
                  TextBold(text: 'Register', fontSize: 18, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => TermsPage()));
              },
              child: TextBold(
                  text:
                      'Signing up means you agree\nto our Terms and Conditions',
                  fontSize: 14,
                  color: Colors.blue),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
