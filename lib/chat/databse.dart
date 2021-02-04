import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserByName(String firstname) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("firstname", isEqualTo: firstname)
        .snapshots();
  }
}
