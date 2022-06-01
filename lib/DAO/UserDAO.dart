import 'dart:io';

import '../Model/UserModel.dart';
import 'FirebaseService.dart';

class UserDAO {
  static Future<UserModel?> findUserById(String id) async {
    return await FirebaseService.firestore(UserModel()).getDocumentById(id);
  }

  static Future<bool> createUser(UserModel user) async {
    if (!await FirebaseService.firestore(user).createDocument()) return false;

    if (user.profilePicture != null) if (!await FirebaseService.storage(user).uploadFile()) return false;

    return true;
  }
}
