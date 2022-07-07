import 'package:LCI/DAO/FirebaseService.dart';
import 'package:LCI/Model/SevenThings/SevenThingsModel.dart';
import 'package:LCI/Model/SevenThings/SevenThingsStatus.dart';
import 'package:LCI/Model/UserModel.dart';
import 'package:LCI/Service/DateService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/SevenThings/SevenThingsContent.dart';

class SevenThingsDAO {
  static Future<SevenThingsModel> loadSevenThings(DateTime date, String userId) async {
    Map<String, dynamic> paramMap = {};

    paramMap.putIfAbsent("sevenThingsDate", () => DateService.getDateOnly(date));

    List? sevenThingsList = await FirebaseService.firestore(UserModel()).subCollection(SevenThingsModel(), parentId: userId).getDocumentByFieldValue(paramMap);

    return sevenThingsList != null && sevenThingsList.length > 0 ? sevenThingsList.first : SevenThingsModel();
  }

  static Future<bool> createSevenThings(SevenThingsModel sevenThings, String userId) async {
    return await FirebaseService.firestore(UserModel()).subCollection(sevenThings, parentId: userId).createDocument();
  }

  static Future<bool> saveSevenThings(SevenThingsModel sevenThings, String userId) async {
    return await FirebaseService.firestore(UserModel()).subCollection(sevenThings, parentId: userId).save();
  }
}
