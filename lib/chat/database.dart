import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserByFirstName(String firstName) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "Doctor")
        .where("firstName", isEqualTo: firstName)
        .snapshots();
  }
}
