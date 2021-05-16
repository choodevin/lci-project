import 'dart:ui';

class LCIScore {
  Map<String, dynamic> score;

  LCIScore(score) {
    this.score = score;
  }

  Map<String, double> dividedScore() {
    Map<String, double> result = {};

    var cognitiveTotal = 0.0; // 3
    var spiritTotal = 0.0; // 1
    var relationTotal = 0.0; // 3
    var physicalTotal = 0.0; // 3

    score.forEach((key, value) {
      if (key == "Finance") {
        value.forEach((key, value) {
          cognitiveTotal += value;
        });
      } else if (key == "Career or Study") {
        value.forEach((key, value) {
          cognitiveTotal += value;
        });
      } else if (key == "Self-Development") {
        value.forEach((key, value) {
          cognitiveTotal += value;
        });
      } else if (key == "Spiritual Life") {
        value.forEach((key, value) {
          spiritTotal += value;
        });
      } else if (key == "Family") {
        value.forEach((key, value) {
          relationTotal += value;
        });
      } else if (key == "Romance Relationship") {
        value.forEach((key, value) {
          relationTotal += value;
        });
      } else if (key == "Social Life") {
        value.forEach((key, value) {
          relationTotal += value;
        });
      } else if (key == "Health & Fitness") {
        value.forEach((key, value) {
          physicalTotal += value;
        });
      } else if (key == "Hobby & Leisure") {
        value.forEach((key, value) {
          physicalTotal += value;
        });
      } else if (key == "Physical Environment") {
        value.forEach((key, value) {
          physicalTotal += value;
        });
      }
    });

    result = {
      "Cognitive": cognitiveTotal / 15,
      "Spirit": spiritTotal / 5,
      "Relationship": relationTotal / 15,
      "Physical": physicalTotal / 15,
    };

    return result;
  }

  Map<String, double> subScore() {
    Map<String, double> result = {};
    Map<String, double> sorted = {};
    List<double> sortVal = [];

    score.forEach((key, value) {
      result[key] = 0;
      value.forEach((x, value) {
        result[key] += value;
      });
      result[key] = result[key] / 5;
      sortVal.add(result[key]);
    });

    sortVal.sort((b, a) => a.compareTo(b));

    sortVal.forEach((x) {
      result.forEach((key, value) {
        if (value == x) {
          sorted[key] = x;
        }
      });
    });

    return sorted;
  }

  Map<String, Color> colors() {
    Map<String, Color> result = {
      "Spiritual Life": Color(0xFF7C0E6F),
      "Romance Relationship": Color(0xFF6EC8F4),
      "Family": Color(0xFFC4CF54),
      "Social Life": Color(0xFFE671A8),
      "Health & Fitness": Color(0xFF003989),
      "Hobby & Leisure": Color(0xFFF27C00),
      "Physical Environment": Color(0xFFFFE800),
      "Self-Development": Color(0xFF00862F),
      "Career or Study": Color(0xFFD9000D),
      "Finance": Color(0xFF8C8B8B),
    };

    return result;
  }
}
