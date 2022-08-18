import 'package:LCI/Model/UserModel.dart';
import 'package:LCI/Repository/SevenThingsRepository.dart';
import 'package:LCI/Service/DateService.dart';

import '../Model/SevenThings/SevenThingsContent.dart';
import '../Model/SevenThings/SevenThingsModel.dart';

class SevenThingsService {
  SevenThingsRepository sevenThingsRepository = SevenThingsRepository();

  static const SEVEN_THINGS_LOCK_FLAG_FULL_LOCK = "LOCK_FULL";
  static const SEVEN_THINGS_LOCK_FLAG_EDIT_LOCK = "LOCK_EDIT";

  Future<SevenThingsModel> loadSevenThingsByDate(UserModel user, DateTime date) async {
    try {
      if (user.id != null) {
        Map<String, dynamic> paramMap = {};
        Map<String, String> idMap = {};

        paramMap.putIfAbsent("sevenThingsDate", () => DateService.getDateOnly(date));
        idMap.putIfAbsent("Users", () => user.id!);

        List<SevenThingsModel> sevenThingsList = await sevenThingsRepository.getCollection(paramMap: paramMap, idMap: idMap);

        SevenThingsModel result = sevenThingsList.length > 0 ? sevenThingsList.first : SevenThingsModel();

        result.parentModel = user;
        result.contentList.sort((a, b) => a.order.compareTo(b.order));

        return result;
      } else {
        throw Exception("User id supplied is NULL");
      }
    } catch (e) {
      print("Error when loadSevenThingsByDate : $e");
    }

    return SevenThingsModel();
  }

  Future saveSevenThings(SevenThingsModel sevenThings) async {
    await sevenThingsRepository.save(sevenThings);
  }

  Future createSevenThings(SevenThingsModel sevenThings, String userId) async {
    await sevenThingsRepository.create(sevenThings);
  }

  SevenThingsModel setSevenThingsId(SevenThingsModel sevenThings, {DateTime? date}) {
    if (date == null) date = DateService.getDateOnly(DateTime.now());

    sevenThings.id = date.toString();
    sevenThings.sevenThingsDate = date;

    return sevenThings;
  }

  List<SevenThingsContent> reorderSevenThings(List<SevenThingsContent> contentList, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    SevenThingsContent tempContent = contentList.removeAt(oldIndex);
    contentList.insert(newIndex, tempContent);

    for (int i = 0; i < contentList.length; i++) {
      if (contentList[i].order != i) contentList[i].order = i;
    }

    return contentList;
  }
}
