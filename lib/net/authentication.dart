
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static DocumentReference currentUserDocRef =
      firestore.collection(USERS).doc(MyAppState.currentUser.userID);
  StorageReference storage = FirebaseStorage.instance.ref();

  /// Retrieving user's account information from our database (firebase)
  Future<OurUser.User> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument != null && userDocument.exists) {
      return OurUser.User.fromJson(userDocument.data());
    } else {
      return null;
    }
  }

  /// Updating user's account information into the database (firebase)
  Future<OurUser.User> updateCurrentUser(
      OurUser.User user, BuildContext context) async {
    return await firestore
        .collection(USERS)
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return user;
    }, onError: (e) {
      print(e);
      showAlertDialog(context, 'Error', 'Failed to Update, Please try again.');
      return null;
    });
  }

  /// To upload user's profile picture into the database (firebase) named under their userID
  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    StorageReference upload = storage.child("images/$userID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  /// Can be deleted
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Can be deleted
  getCurrentuser() {
    return auth.currentUser;
  }

}
