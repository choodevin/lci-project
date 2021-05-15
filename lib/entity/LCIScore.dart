class LCIScore {
  Map<String, dynamic> score;

  LCIScore({this.score});

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

    score.forEach((key, value) {
      result[key] = 0;
      value.forEach((x, value) {
        result[key] += value;
      });
      result[key] = result[key] / 5;
    });

    return result;
  }
}
