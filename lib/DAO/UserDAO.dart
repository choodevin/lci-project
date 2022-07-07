import 'dart:io';

import 'package:LCI/Model/SevenThings/SevenThingsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/UserModel.dart';
import 'FirebaseService.dart';

class UserDAO {
  static Future<bool> createUser(UserModel user) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (!await FirebaseService.firestore(user).createDocument(id: userId)) return false;

    if (user.profilePictureFile != null) if (!await FirebaseService.storage(user).uploadFile()) return false;

    return true;
  }

  static Future<UserModel> findUserById(String id, bool loadProfilePicture) async {
    UserModel user = await FirebaseService.firestore(UserModel()).getDocumentById(id);
    if (loadProfilePicture) await UserDAO.loadProfilePicture(user);
    return user;
  }

  static Future loadProfilePicture(UserModel user) async {
    user.profilePictureBits = await FirebaseService.storage(user).downloadFile("profilePicture");
  }
}
