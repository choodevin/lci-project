import 'dart:ui';

class LCIScore {
  late Map<String, dynamic> score;

  LCIScore(score) {
    this.score = score;
  }

  Map<String, double> dividedScore() {
    Map<String, double> result = {};

    var cognitiveTotal = 0.0; // 3
    var cognitiveOccurrence = 0;
    var spiritTotal = 0.0; // 1
    var spiritOccurrence = 0;
    var relationTotal = 0.0; // 3
    var relationOccurrence = 0;
    var physicalTotal = 0.0; // 3
    var physicalOccurrence = 0;

    score.forEach((key, value) {
      if (key == "Finance") {
        value.forEach((key, value) {
          cognitiveTotal += value;
          cognitiveOccurrence++;
        });
      } else if (key == "Career or Study") {
        value.forEach((key, value) {
          cognitiveTotal += value;
          cognitiveOccurrence++;
        });
      } else if (key == "Self-Development") {
        value.forEach((key, value) {
          cognitiveTotal += value;
          cognitiveOccurrence++;
        });
      } else if (key == "Spiritual Life") {
        value.forEach((key, value) {
          spiritTotal += value;
          spiritOccurrence++;
        });
      } else if (key == "Family") {
        value.forEach((key, value) {
          relationTotal += value;
          relationOccurrence++;
        });
      } else if (key == "Romance Relationship") {
        value.forEach((key, value) {
          relationTotal += value;
          relationOccurrence++;
        });
      } else if (key == "Social Life") {
        value.forEach((key, value) {
          relationTotal += value;
          relationOccurrence++;
        });
      } else if (key == "Health & Fitness") {
        value.forEach((key, value) {
          physicalTotal += value;
          physicalOccurrence++;
        });
      } else if (key == "Hobby & Leisure") {
        value.forEach((key, value) {
          physicalTotal += value;
          physicalOccurrence++;
        });
      } else if (key == "Physical Environment") {
        value.forEach((key, value) {
          physicalTotal += value;
          physicalOccurrence++;
        });
      }
    });

    result = {
      "Cognitive": cognitiveTotal / cognitiveOccurrence,
      "Spirit": spiritTotal / spiritOccurrence,
      "Relationship": relationTotal / relationOccurrence,
      "Physical": physicalTotal / physicalOccurrence,
    };

    return result;
  }

  String firstDisplay() {
    var dividedScore = this.dividedScore();
    var displayResult;
    var spiritHealth = 0;
    var cogHealth = 0;
    var relationHealth = 0;
    var physicalHealth = 0;

    if (dividedScore['Spirit']! >= 8) {
      spiritHealth = 1;
    }
    if (dividedScore['Cognitive']! >= 8) {
      cogHealth = 1;
    }
    if (dividedScore['Relationship']! >= 8) {
      relationHealth = 1;
    }
    if (dividedScore['Physical']! >= 8) {
      physicalHealth = 1;
    }

    if (spiritHealth == 1) {
      if (physicalHealth == 1) {
        if (relationHealth == 1) {
          if (cogHealth == 1) {
            displayResult =
            "You are living fullness in your life! You are enjoying your life every day. If you do not feel so, we highly recommend you to look into your spiritual life or talk to our coach.";
          } else {
            displayResult =
            "You are living a good and healthy life. However you feel like you can do more in your life to achieve a better displayResult. If you do not sure how and what you can be improved, we highly recommend you talk to our coach.";
          }
        } else {
          if (cogHealth == 1) {
            displayResult =
            "Overall, you are living a good life. However there might be some relationship challenges that you are facing or you do not aware. If your [Romance Relationship], [Family], and [Social] life is not in your current focus, we recommend that you may look into it. Or you can talk to our coach to explore more.";
          } else {
            displayResult =
            "Overall, you are living a healthy life, but you may be having obstacle in your relationships with others and you may be looking for changes in your life. We recommend you to define a clearer direction for your life first, and then start work on the direction. If you not sure how to do it, feel free to contact our coach.";
          }
        }
      } else {
        if (relationHealth == 1) {
          if (cogHealth == 1) {
            displayResult =
            'Overall you are living a good live. However, you might have not look into living a healthy life style. Making time for your rest, having \"me\" time, exercise or taking care your diet are very important too. We recommend you to start work on your life style to improve your life. You may talk to our coach to explore more as well.';
          } else {
            displayResult =
            "It is good to have healthy relationships with people around you. You might feel that you are not as good as them sometimes, but that is simply you haven\'t fully utilise your potential. If you wish to improve that, please feel free to contact our coach.";
          }
        } else {
          if (cogHealth == 1) {
            displayResult =
            "You might aware that there are changes in your relationship and life style that you need to make, and you might already doing it. If you want to accelerate your progress, please feel free to contact our coach.";
          } else {
            displayResult =
            "You may be on the journey of recovering from a significant event of your life. Other wise, our coach can talk to you and assist you in your growth.";
          }
        }
      }
    } else {
      if (physicalHealth == 1) {
        if (relationHealth == 1) {
          if (cogHealth == 1) {
            displayResult =
            "Overall, you are living a good life. However, you might have questions about meaning of life some times, that you might wonder what is the reason of your existance. We recommend you to look into your spiritual life.";
          } else {
            displayResult =
            "You might feeling lost in your life sometimes, where you aren't able to find direction and purpose for your life. All you need is a guide to help you discover this part of your life. You may contact our coach as we will assist you in your discovery journey.";
          }
        } else {
          if (cogHealth == 1) {
            displayResult =
            "It is good that you take care yourself both physically and mentally. We would like to remind you, true happiness comes from healthy relationships with others. Do not over work but forget the people around you. If you are facing unsolvable relationship issue, please feel free to talk to our coach.";
          } else {
            displayResult =
            "You may feel like there is a lot of things in your life that you need to improve. Please feel free to talk to our coach for your future development.";
          }
        }
      } else {
        if (relationHealth == 1) {
          if (cogHealth == 1) {
            displayResult =
            "When was the last time you take good care of yourself? You might spend lot of time in your work and your relationships with people, but your personal well being is important too. Do not forget to refresh yourself from time to time. If you not sure what to do, please feel free to contact our coach.";
          } else {
            displayResult =
            "You may feel like there is a lot of things in your life that you need to improve. Please feel free to talk to our coach for your future development.";
          }
        } else {
          if (cogHealth == 1) {
            displayResult =
            "You may feel like there is a lot of things in your life that you need to improve. Please feel free to talk to our coach for your future development.";
          } else {
            displayResult =
            "It is good that you are here! This is a right place if you are looking for changes and growth! Please let our coach to assist you, and develop a plan for you.";
          }
        }
      }
    }

    return displayResult;
  }

  Map<String, double> subScore() {
    Map<String, double> result = {};
    Map<String, double> sorted = {};
    List<double> sortVal = [];

    score.forEach((key, value) {
      var questionCount = 0;
      result[key] = 0;
      value.forEach((x, value) {
        result[key] = result[key]! + value;
        questionCount++;
      });
      result[key] = result[key]! / questionCount;
      sortVal.add(result[key]!);
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
