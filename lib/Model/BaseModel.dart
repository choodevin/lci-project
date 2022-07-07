import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseModel {
  String tableName;
  DateTime? creationTime;
  DateTime? updateTime;
  String? id;

  BaseModel? parentTable;

  Map<String, dynamic> objectMap = {};
  Map<String, File> fileList = {};

  BaseModel({required this.tableName, this.parentTable});

  @mustCallSuper
  void toObject(String id, Object? obj) {
    Map<String, dynamic> map;

    map = obj! as Map<String, dynamic>;

    this.creationTime = map['creationTime'].toDate();
    this.updateTime = map['updateTime'].toDate();
    this.id = id;
  }

  @mustCallSuper
  Map<String, dynamic> toMap() {
    objectMap["creationTime"] = this.creationTime;
    objectMap["updateTime"] = this.updateTime;

    return this.objectMap;
  }

  Map<String, File> getFileList();
}
