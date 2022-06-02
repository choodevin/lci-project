import 'dart:io';
import 'dart:typed_data';

import 'package:LCI/Model/BaseModel.dart';

class UserModel extends BaseModel {
  static String TABLE_NAME = "Users"; // Table name for Firebase DB usage

  // Column names
  String? email;
  String? password;
  String? name;
  String? gender;
  String? country;
  DateTime? dateOfBirth;
  String? subscriptionType;
  String? currentEnrolledCampaign;
  bool? isCoach;

  // Storage file name
  File? profilePictureFile;
  Uint8List? profilePictureBits;

  UserModel() : super(tableName: TABLE_NAME); // Must initialize BaseModel's table name

  void toObject(String id, Object? obj) {
    super.toObject(id, obj);

    Map<String, dynamic> map;

    map = obj! as Map<String, dynamic>;

    this.email = map['email'];
    this.name = map['name'];
    this.gender = map['gender'];
    this.country = map['country'];
    this.dateOfBirth = map['dateOfBirth'].toDate();
    this.subscriptionType = map['subscriptionType'];
    this.currentEnrolledCampaign = map['currentEnrolledCampaign'];
    this.isCoach = map['isCoach'];
  }

  Map<String, dynamic> toMap() {
    super.toMap();

    this.objectMap["email"] = this.email;
    this.objectMap["name"] = this.name;
    this.objectMap["gender"] = this.gender;
    this.objectMap["country"] = this.country;
    this.objectMap["dateOfBirth"] = this.dateOfBirth;
    this.objectMap["subscriptionType"] = this.subscriptionType;
    this.objectMap["currentEnrolledCampaign"] = this.currentEnrolledCampaign;
    this.objectMap["isCoach"] = this.isCoach;

    return this.objectMap;
  }

  Map<String, File> getFileList() {
    this.fileList["profilePicture"] = this.profilePictureFile!;

    return fileList;
  }
}
