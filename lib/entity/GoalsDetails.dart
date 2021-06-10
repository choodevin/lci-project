import 'dart:ui';

class GoalsDetails {
  String getDesc(String key) {
    var desc;
    if (key == "Spiritual Life") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Romance Relationship") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Family") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Social Life") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Health & Fitness") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Hobby & Leisure") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Physical Environment") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Self-Development") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Career or Study") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    } else if (key == "Finance") {
      desc = "This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.";
    }
    return desc;
  }

  String getAssetPath(String key) {
    var path;
    if (key == "Spiritual Life") {
      path = "assets/star.svg";
    } else if (key == "Romance Relationship") {
      path = "assets/heart.svg";
    } else if (key == "Family") {
      path = "assets/user-friends.svg";
    } else if (key == "Social Life") {
      path = "assets/user-friends.svg";
    } else if (key == "Health & Fitness") {
      path = "assets/user-friends.svg";
    } else if (key == "Hobby & Leisure") {
      path = "assets/user-friends.svg";
    } else if (key == "Physical Environment") {
      path = "assets/user-friends.svg";
    } else if (key == "Self-Development") {
      path = "assets/user-friends.svg";
    } else if (key == "Career or Study") {
      path = "assets/user-friends.svg";
    } else if (key == "Finance") {
      path = "assets/user-friends.svg";
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
