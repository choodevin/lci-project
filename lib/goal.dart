import 'package:LCI/custom-components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Goals extends StatefulWidget {
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  int totalSelected;
  var goals = {
    'Spiritual': false,
    'Romance': false,
    'Family': false,
    'Social': false,
    'Health': false,
    'Hobby': false,
    'Environment': false,
    'Development': false,
    'Career': false,
    'Finance': false
  };

  @override
  void initState() {
    super.initState();
    int i = 0;
    goals.forEach((key, value) {
      if (value) {
        i++;
      }
    });
    totalSelected = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Setting Up Your Goals',
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  'Choose your Goals',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF5D88FF),
                  ),
                ),
                Padding(padding: EdgeInsets.all(3)),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/info.svg',
                      color: Color(0xFFFFCC00),
                      height: 18,
                      width: 18,
                    ),
                    Padding(padding: EdgeInsets.all(3.5)),
                    Text(
                      'Recommended to select only 3',
                      style: TextStyle(
                        color: Color(0xFFFFCC00),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Spiritual',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFF7C0E6F),
                  value: goals.entries.elementAt(0).value,
                  assetPath: 'assets/star.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(0).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Romance',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFF6EC8F4),
                  value: goals.entries.elementAt(1).value,
                  assetPath: 'assets/heart.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(1).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Family',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFFC4CF54),
                  value: goals.entries.elementAt(2).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(2).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Social',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFFEB8EBA),
                  value: goals.entries.elementAt(3).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(3).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Health',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFF003989),
                  value: goals.entries.elementAt(4).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(4).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Hobby',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFFF27C00),
                  value: goals.entries.elementAt(5).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(5).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Environment',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFFFFE910),
                  value: goals.entries.elementAt(6).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(6).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Development',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFF00862F),
                  value: goals.entries.elementAt(7).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(7).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Career',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFFD9000D),
                  value: goals.entries.elementAt(8).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(8).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(5)),
                GoalSelection(
                  title: 'Finance',
                  description:
                      'This is the explanation of Spiritual. There are some examples given below to show that what are actually spiritual activities and how important it is.',
                  color: Color(0xFF8C8B8B),
                  value: goals.entries.elementAt(9).value,
                  assetPath: 'assets/user-friends.svg',
                  callBack: (bool newValue) {
                    goals.update(
                        goals.entries.elementAt(9).key, (x) => x = newValue);
                    setState(() {
                      newValue ? totalSelected++ : totalSelected--;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(30)),
                Text(
                  totalSelected.toString() + '/10 Goals Selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                Padding(padding: EdgeInsets.all(30)),
                PrimaryButton(
                  color: Color(0xFF299E45),
                  textColor: Colors.white,
                  text: 'Confirm & Proceed',
                  onClickFunction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GoalsNoLci()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalsNoLci extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'LCI Result Missing',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
