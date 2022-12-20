import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addUser(
  String name,
  String contactNumber,
  String email,
) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'email': email,
    'contactNumber': contactNumber,
    'id': docUser.id,
    'profilePicture': 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
  };

  await docUser.set(json);
}
