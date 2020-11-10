import 'dart:io';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';
import 'valtool.dart';
import 'User.dart' as OUser;
import 'package:firebase_storage/firebase_storage.dart';

//rqwrqwrqrew
// some random code

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static DocumentReference currentUserDocRef =
      firestore.collection(USERS).doc(MyAppState.currentUser.userID);
  StorageReference storage = FirebaseStorage.instance.ref();

  Future<OUser.User> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument != null && userDocument.exists) {
      return OUser.User.fromJson(userDocument.data());
    } else {
      return null;
    }
  }

  Future<OUser.User> updateCurrentUser(
      OUser.User user, BuildContext context) async {
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

  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    StorageReference upload = storage.child("images/$userID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
