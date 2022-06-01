import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseModel {
  String? tableName;
  Timestamp? creationTime;
  Timestamp? updateTime;
  String? id;

  Map<String, dynamic> objectMap = {};
  Map<String, File> fileList = {};

  BaseModel({this.tableName});

  @mustCallSuper
  void toObject(String id, Object? obj) {
    Map<String, dynamic> map;

    map = obj! as Map<String, dynamic>;

    this.creationTime = map['creationTime'];
    this.creationTime = map['updateTime'];
    this.creationTime = map['id'];
  }

  @mustCallSuper
  Map<String, dynamic> toMap() {
    objectMap["creationTime"] = this.creationTime;
    objectMap["updateTime"] = this.updateTime;

    return this.objectMap;
  }

  Map<String, File> getFileList();
}
