import 'package:LCI/DAO/SevenThingsDAO.dart';
import 'package:LCI/Model/UserModel.dart';
import 'package:LCI/Screen/sevenThings/SevenThings.dart';
import 'package:LCI/Service/DateService.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../Model/SevenThings/SevenThingsModel.dart';

class SevenThingsService {
  static Future<SevenThingsModel> loadSevenThings(UserModel user, DateTime date) async {
    SevenThingsModel result = await SevenThingsDAO.loadSevenThings(date, user.id!);
    result.contentList.sort((a, b) => a.order!.compareTo(b.order!));
    return result;
  }

  static Future<bool> saveSevenThings(SevenThingsModel sevenThings, String userId) async {
    return await SevenThingsDAO.saveSevenThings(sevenThings, userId);
  }

  static Future<bool> createSevenThings(SevenThingsModel sevenThings, String userId) async {
    return await SevenThingsDAO.createSevenThings(sevenThings, userId);
  }

  static SevenThingsModel setSevenThingsId(SevenThingsModel sevenThings, {DateTime? date}) {
    if (date == null) date = DateService.getDateOnly(DateTime.now());

    sevenThings.id = date.toString();
    sevenThings.sevenThingsDate = date;

    return sevenThings;
  }
}
