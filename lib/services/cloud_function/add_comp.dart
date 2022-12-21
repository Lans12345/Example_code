import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addComp(
  String name,
  String contactNumber,
  String email,
  String url,
  String imageURL,
) async {
  final docUser = FirebaseFirestore.instance
      .collection('Providers')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'email': email,
    'contactNumber': contactNumber,
    'url': url,
    'id': docUser.id,
    'logo': imageURL,
  };

  await docUser.set(json);
}
