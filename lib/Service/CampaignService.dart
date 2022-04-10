import 'package:LCI/Service/FirebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/MonthlyRankingsModel.dart';

class CampaignService {
  Future<List<MonthlyRankingsModel>> getRankings(String campaignId, String rankingsDate) async {
    if (rankingsDate.length == 0) {
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;
      String monthString = currentMonth.toString().padLeft(2, '0');

      rankingsDate = "$monthString-$currentYear";
    }

    FirebaseService db = FirebaseService("CampaignData/$campaignId/MonthlyRanking/$rankingsDate");
    MonthlyRankingsModel rankingsModel = MonthlyRankingsModel();

    DocumentSnapshot result = await db.getData();

    print(result.exists);

    return await rankingsModel.documentToList(result);
  }
}
