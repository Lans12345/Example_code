import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future addRatings(
    String name, int star, String userId, String profilePicture) async {
  final docUser = FirebaseFirestore.instance.collection('Ratings').doc();

  String tdata = DateFormat("hh:mm a").format(DateTime.now());

  final json = {
    'name': name,
    'star': star,
    'id': docUser.id,
    'uid': userId,
    'profilePicture': profilePicture,
    'date': tdata,
    'myId': FirebaseAuth.instance.currentUser!.uid,
  };

  await docUser.set(json);
}
