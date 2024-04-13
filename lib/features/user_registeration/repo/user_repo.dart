import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockfolio/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<bool> checkExistingUser(String uid) async {
    final DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('Users').doc(uid).get();
    if (snapshot.exists) {
      if (kDebugMode) {
        print('USER EXISTS');
      }
      return true;
    } else {
      if (kDebugMode) {
        print('NEW USER');
      }
      return false;
    }
  }

  Future<void> saveDataToPrefs(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currUser_uid', uid);
  }

  Future<void> removeUidFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currUser_uid');
  }

  Future<UserModel> saveUserDataToFirebase({
    required UserModel userModel,
    required File profilePic,
  }) async {
    userModel.uid = _firebaseAuth.currentUser!.uid;
    // saving uid to prefs
    await saveDataToPrefs(userModel.uid!);
    // uploading image to firebase storage.
    await storeFileToStorage('profilePic/${userModel.uid}', profilePic)
        .then((String value) {
      userModel.profilePic = value;
    });

    // uploading to database
    await _firebaseFirestore
        .collection('Users')
        .doc(userModel.uid)
        .set(userModel.toJson());
    return userModel;
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    final UploadTask uploadTask =
        _firebaseStorage.ref().child(ref).putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<UserModel> fetchUserData(String uid) async {
    // saving uid to prefs
    await saveDataToPrefs(uid);
    final DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('Users').doc(uid).get();
    return UserModel.fromJson(snapshot.data()! as Map<String, dynamic>);
  }
}
