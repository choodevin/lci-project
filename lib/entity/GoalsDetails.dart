import 'dart:ui';

class GoalsDetails {
  String getDesc(String key) {
    var desc;
    if (key == "Spiritual Life") {
      desc = " Spirituality is area of your life where it refers to either your believe system or what you believe in about how the world or universe works. A healthy belief empower a person to live a healthier and better life.";
    } else if (key == "Romance Relationship") {
      desc = "This area of life refer to your relationship's satisfaction, where how well you and your partner work on the relationship. If you are single, this refer to how satisfy you are with your single hood. Some people can be single and enjoy the freedom and personal moment.";
    } else if (key == "Family") {
      desc = " Refer to your satisfaction and your relationship toward your origin family or extended family if you have built your own family.";
    } else if (key == "Social Life") {
      desc = "It refers to your social activities, which included with friends’ relationship, community work, contribution and etc.";
    } else if (key == "Health & Fitness") {
      desc = "It refer to the condition of your body and physical ability & functioning of your body.";
    } else if (key == "Hobby & Leisure") {
      desc = "It refers to your activity of interest or activities that non-working related, yet you enjoy. It also include how is your resting’s quality and personal time.";
    } else if (key == "Physical Environment") {
      desc = "Your physical environment refer where you spend most of your time with, such as office and house. A healthy environment bring positive emotion such as relax and peacefulness.";
    } else if (key == "Self-Development") {
      desc = "It refers to the area where you constantly seek improvement on your interpersonal and intrapersonal skills, such as your knowledge, people skills, emotion management and etc.";
    } else if (key == "Career or Study") {
      desc = "It refers to your satisfaction and performance toward what you do for living if you are working adult / what you are current pursuing if you are student.";
    } else if (key == "Finance") {
      desc = "It includes your understanding and management toward your income and expenses.";
    }
    return desc;
  }

  String getAssetPath(String key) {
    var path;
    if (key == "Spiritual Life") {
      path = "assets/spiritual.svg";
    } else if (key == "Romance Relationship") {
      path = "assets/heart.svg";
    } else if (key == "Family") {
      path = "assets/family.svg";
    } else if (key == "Social Life") {
      path = "assets/user-friends.svg";
    } else if (key == "Health & Fitness") {
      path = "assets/heart.svg";
    } else if (key == "Hobby & Leisure") {
      path = "assets/gamepad.svg";
    } else if (key == "Physical Environment") {
      path = "assets/home.svg";
    } else if (key == "Self-Development") {
      path = "assets/light-bulb.svg";
    } else if (key == "Career or Study") {
      path = "assets/briefcase.svg";
    } else if (key == "Finance") {
      path = "assets/wallet.svg";
    }
    return path;
  }

  Color getColor(String key) {
    var color;
    if (key == "Spiritual Life") {
      color = Color(0xFF7C0E6F);
    } else if (key == "Romance Relationship") {
      color = Color(0xFF6EC8F4);
    } else if (key == "Family") {
      color = Color(0xFFC4CF54);
    } else if (key == "Social Life") {
      color = Color(0xFFE671A8);
    } else if (key == "Health & Fitness") {
      color = Color(0xFF003989);
    } else if (key == "Hobby & Leisure") {
      color = Color(0xFFF27C00);
    } else if (key == "Physical Environment") {
      color = Color(0xFFFFE800);
    } else if (key == "Self-Development") {
      color = Color(0xFF00862F);
    } else if (key == "Career or Study") {
      color = Color(0xFFD9000D);
    } else if (key == "Finance") {
      color = Color(0xFF8C8B8B);
    }
    return color;
  }
}
