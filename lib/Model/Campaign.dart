import 'package:LCI/Service/FirebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'MonthlyRankings.dart';

class Campaign extends ChangeNotifier {
  Future<List<MonthlyRankings>> getRankings(String campaignId, String rankingsDate) async {
    if (rankingsDate == null) {
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;
      String monthString = currentMonth.toString().padLeft(2, '0');

      rankingsDate = "$monthString-$currentYear";
    }

    FirebaseService db = FirebaseService("CampaignData/$campaignId/MonthlyRanking/$rankingsDate");
    MonthlyRankings rankingsModel = MonthlyRankings();

    DocumentSnapshot result = await db.getData();

    print(result.exists);

    return await rankingsModel.documentToList(result);
  }
}
