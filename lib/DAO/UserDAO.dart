import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../Model/UserModel.dart';
import 'FirebaseService.dart';

class UserDAO {
  static Future<UserModel> findUserById(String id) async {
    UserModel user = await FirebaseService.firestore(UserModel()).getDocumentById(id);
    user.profilePictureBits = await FirebaseService.storage(user).downloadFile("profilePicture");
    return user;
  }

  static Future<bool> createUser(UserModel user) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (!await FirebaseService.firestore(user).createDocument(id: userId)) return false;

    if (user.profilePictureFile != null) if (!await FirebaseService.storage(user).uploadFile()) return false;

    return true;
  }
}
