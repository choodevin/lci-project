import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class MonthlyRankings {
  late String id;
  late int days;
  late int totalLeave;
  late double totalScore;
  late String name;
  late double averageScore;

  MonthlyRankings({this.id = "", this.days = 0, this.totalLeave = 0, this.totalScore = 0, this.name = "", this.averageScore = 0});

  MonthlyRankings.fromMap(Map snapshot, String id)
      : id = id ?? "",
        days = snapshot['days'] ?? 0,
        totalLeave = snapshot['totalLeave'] ?? 0,
        totalScore = snapshot['totalScore'] ?? 0.0;

  Future<List<MonthlyRankings>> documentToList(DocumentSnapshot snapshot) async {
    List<MonthlyRankings> result = [];
    User userModel = User();
    if (snapshot.exists) {
      Map? resultMap = snapshot.data() as Map?;

      for(var entry in resultMap!.entries) {
        String key = entry.key;
        var value = entry.value;
        double averageScore = value['totalScore'] / value['days'] * 10;
        String name = await userModel.getName(key);
        result.add(MonthlyRankings(
          id: key,
          name: name,
          days: value['days'],
          totalLeave: value['totalLeave'],
          totalScore: value['totalScore'].toDouble(),
          averageScore: averageScore.isNaN ? 0.0 : averageScore,
        ));
      }
    }
    result.sort((a, b) => b.averageScore.compareTo(a.averageScore));
    return result;
  }
}
