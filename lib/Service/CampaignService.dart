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

    List<MonthlyRankingsModel> result = [];

    return result;
  }
}
