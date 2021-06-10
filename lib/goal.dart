import 'package:LCI/custom-components.dart';
import 'package:LCI/entity/GoalsDetails.dart';
import 'package:LCI/entity/LCIScore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'lci.dart';

class LoadGoals extends StatelessWidget {
  final userdata;

  const LoadGoals({Key key, this.userdata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('Goals').doc();

    return FutureBuilder<DocumentSnapshot>(
      future: ref.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          QuerySnapshot goals = snapshot.data.data();
          if (goals == null || goals.size == 0) {
            return Goals(userdata: userdata);
          } else {
            return GoalStatus(goals: goals);
          }
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class Goals extends StatefulWidget {
  final userdata;

  const Goals({this.userdata});

  _GoalsState createState() => _GoalsState(userdata: userdata);
}

class _GoalsState extends State<Goals> {
  final userdata;

  _GoalsState({this.userdata});

  int totalSelected;
  Map<String, dynamic> goals = {};

  @override
  void initState() {
    super.initState();
    goals['Spiritual Life'] = {"selected": false};
    goals['Romance Relationship'] = {"selected": false};
    goals['Family'] = {"selected": false};
    goals['Social Life'] = {"selected": false};
    goals['Health & Fitness'] = {"selected": false};
    goals['Hobby & Leisure'] = {"selected": false};
    goals['Physical Environment'] = {"selected": false};
    goals['Self-Development'] = {"selected": false};
    goals['Career or Study'] = {"selected": false};
    goals['Finance'] = {"selected": false};
    int i = 0;
    goals.forEach((key, value) {
      if (value['selected']) {
        i++;
      }
    });
    totalSelected = i;
  }

  @override
  Widget build(BuildContext context) {
    var goalDetails = GoalsDetails();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
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
                Column(
                  children: goals.keys.map((key) {
                    return Column(
                      children: [
                        GoalSelection(
                          title: key,
                          description: goalDetails.getDesc(key),
                          color: goalDetails.getColor(key),
                          value: goals[key]['selected'],
                          assetPath: goalDetails.getAssetPath(key),
                          callBack: (bool newValue) {
                            goals[key]['selected'] = newValue;
                            setState(() {
                              newValue ? totalSelected++ : totalSelected--;
                            });
                          },
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                      ],
                    );
                  }).toList(),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoadScore(userdata: userdata, goals: goals)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadScore extends StatelessWidget {
  final userdata;
  final goals;

  const LoadScore({Key key, this.userdata, this.goals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('LCIScore');

    return FutureBuilder<QuerySnapshot>(
      future: ref.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          QuerySnapshot score = snapshot.data;

          if (score == null || score.size == 0) {
            return GoalsNoLci(userdata: userdata);
          } else {
            return GoalSetting(userdata: userdata, score: score, goals: goals);
          }
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class GoalsNoLci extends StatelessWidget {
  final userdata;

  const GoalsNoLci({this.userdata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'LCI Result Missing',
                ),
                Text(
                  'You haven\'t done any LCI Test before. Please do the following test below',
                  style: TextStyle(color: Color(0xFF5D88FF), fontSize: 17),
                ),
                Padding(padding: EdgeInsets.all(5)),
                PrimaryButton(
                  onClickFunction: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Lci(userdata: userdata)));
                  },
                  text: 'Take LCI Test',
                  color: Color(0xFFBC7AFE),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalSetting extends StatefulWidget {
  final userdata;
  final score;
  final goals;
  final displayedList;

  const GoalSetting({Key key, this.userdata, this.score, this.goals, this.displayedList}) : super(key: key);

  _GoalSettingState createState() => _GoalSettingState(userdata, score, goals, displayedList);
}

class _GoalSettingState extends State<GoalSetting> {
  final userdata;
  final score;
  final _qOneController = new TextEditingController();

  List<String> displayedList;
  Map<String, dynamic> goals;
  String toDisplay;
  FocusNode _qOneNode;
  Map<String, double> subScore;

  var goalDetails = new GoalsDetails();
  var targetScore = 0.0;
  var questionStyle;
  var scoreObj;

  _GoalSettingState(this.userdata, this.score, this.goals, this.displayedList);

  void initState() {
    super.initState();
    _qOneNode = FocusNode();
    _qOneNode.addListener(() {
      setState(() {});
    });

    if (displayedList == null) {
      displayedList = [];
    }

    goals.entries.forEach((element) {
      if (element.value['selected']) {
        if (!displayedList.contains(element.key)) {
          toDisplay = element.key;
          return;
        }
      }
    });

    scoreObj = new LCIScore(score.docs.last.data());
    subScore = scoreObj.subScore();

    questionStyle = TextStyle(
      fontSize: 16,
      color: goalDetails.getColor(toDisplay),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: "Milestone Goals",
                  metaText: "Review your current status with your goals",
                ),
                Padding(padding: EdgeInsets.all(20)),
                PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextWithIcon(
                        text: toDisplay,
                        assetPath: goalDetails.getAssetPath(toDisplay),
                        assetColor: goalDetails.getColor(toDisplay),
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: goalDetails.getColor(toDisplay),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(7.5)),
                      Text(
                        goalDetails.getDesc(toDisplay),
                        style: TextStyle(
                          color: goalDetails.getColor(toDisplay),
                          fontSize: 16,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Value",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: goalDetails.getColor(toDisplay),
                            ),
                          ),
                          Text(
                            subScore[toDisplay].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: goalDetails.getColor(toDisplay),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                      RoundedLinearProgress(
                        value: subScore[toDisplay] / 10,
                        color: Color(0xFF170E9A),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        "Your Goal",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: goalDetails.getColor(toDisplay),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Text(
                  "How do you define your goal ?",
                  style: questionStyle,
                ),
                Padding(padding: EdgeInsets.all(2)),
                InputBox(
                  focusNode: _qOneNode,
                  controller: _qOneController,
                  minLines: 5,
                ),
                Padding(padding: EdgeInsets.all(15)),
                PrimaryButton(
                  text: "Confirm & Proceed",
                  color: Color(0xFF299E45),
                  textColor: Colors.white,
                  onClickFunction: () async {
                    var selectedCount = 0;
                    displayedList.add(toDisplay);
                    goals.values.forEach((element) {
                      if (element['selected']) {
                        selectedCount++;
                      }
                    });
                    if (displayedList.length != selectedCount) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalSetting(
                            userdata: userdata,
                            score: score,
                            goals: goals,
                            displayedList: displayedList,
                          ),
                        ),
                      );
                      displayedList.remove(toDisplay);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalStatus(
                            score: score,
                            goals: goals,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalStatus extends StatelessWidget {
  final goals;
  final score;

  const GoalStatus({Key key, this.goals, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
