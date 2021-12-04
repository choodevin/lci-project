import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class MonthlyRankings {
  String id;
  int days;
  int totalLeave;
  double totalScore;
  String name;
  double averageScore;

  MonthlyRankings({this.id, this.days, this.totalLeave, this.totalScore, this.name, this.averageScore});

  MonthlyRankings.fromMap(Map snapshot, String id)
      : id = id ?? "",
        days = snapshot['days'] ?? 0,
        totalLeave = snapshot['totalLeave'] ?? 0,
        totalScore = snapshot['totalScore'] ?? 0.0;

  Future<List<MonthlyRankings>> documentToList(DocumentSnapshot snapshot) async {
    List<MonthlyRankings> result = [];
    User userModel = User();
    if (snapshot.exists) {
      Map resultMap = snapshot.data();

      for(var entry in resultMap.entries) {
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
