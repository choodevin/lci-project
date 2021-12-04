import 'package:LCI/Service/FirebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String id;
  String email;
  String password;
  String name;
  String gender;
  String country;
  String dateOfBirth;
  String subscription;
  String currentEnrolledCampaign;
  bool isCoach;

  User(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.gender,
      this.country,
      this.dateOfBirth,
      this.subscription,
      this.currentEnrolledCampaign,
      this.isCoach});

  User.fromMap(Map snapshot, String id)
      : id = id ?? "",
        email = snapshot['email'] ?? "",
        password = snapshot['password'] ?? "",
        name = snapshot['name'] ?? "",
        gender = snapshot['gender'] ?? "",
        country = snapshot['country'] ?? "",
        dateOfBirth = snapshot['dateOfBirth'] ?? "",
        subscription = snapshot['subscription'] ?? "",
        currentEnrolledCampaign = snapshot['currentEnrolledCampaign'] ?? "",
        isCoach = snapshot['isCoach'] ?? "";

  Future<String> getName(String id) async {
    var result;
    FirebaseService db = FirebaseService("UserData");
    result = await db.getDocumentById(id);
    result = result.get("name");
    return result;
  }
}
