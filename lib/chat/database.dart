import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserByFirstName(String firstName) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "Doctor")
        .where("firstName", isEqualTo: firstName)
        .snapshots();
  }

  Future adduserinfo(Map<String, dynamic> userinfomap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc()
        .set(userinfomap);
  }
}
