import 'dart:io';

import 'package:LCI/Model/BaseModel.dart';
import 'package:LCI/Model/UserModel.dart';

import 'SevenThingsContent.dart';
import 'SevenThingsStatus.dart';

class SevenThingsModel extends BaseModel {
  static String TABLE_NAME = "SevenThings";

  //Column names
  List<SevenThingsContent> contentList = [];
  SevenThingsStatus status = SevenThingsStatus();
  DateTime? sevenThingsDate;

  SevenThingsModel() : super(tableName: TABLE_NAME, containsParent: true, parentModel: UserModel()) {
    for (int i = 0; i < 7; i++) {
      SevenThingsContent sevenThingsContent = SevenThingsContent();
      sevenThingsContent.order = i;
      contentList.add(sevenThingsContent);
    }
  } // Must initialize BaseModel's table name

  void toObject(String id, Object? obj) {
    super.toObject(id, obj);

    Map<String, dynamic> map;

    map = obj! as Map<String, dynamic>;

    Map<String, dynamic>? tempContent = map['content'];

    this.contentList = [];

    this.status = SevenThingsStatus();

    for (int i = 0; i < 7; i++) {
      SevenThingsContent sevenThingsContent = SevenThingsContent();
      sevenThingsContent.order = i;
      this.contentList.add(sevenThingsContent);
    }

    if (tempContent != null && tempContent.length > 0) {
      Iterator it = tempContent.entries.iterator; 

      while (it.moveNext()) {
        MapEntry map = it.current;
        SevenThingsContent content = SevenThingsContent();

        content.toObject(map);

        this.contentList[content.order] = content;
      }
    }

    for (int i = 0; i < 7; i++) {}

    this.status.toObject(map['status']);
    this.sevenThingsDate = map['sevenThingsDate'].toDate();
  }

  Map<String, dynamic> toMap() {
    super.toMap();

    this.objectMap["content"] = SevenThingsContent.toMap(contentList);
    this.objectMap["status"] = this.status.toMap();
    this.objectMap["sevenThingsDate"] = this.sevenThingsDate;

    return this.objectMap;
  }

  Map<String, File> getFileList() {
    return {};
  }
}
