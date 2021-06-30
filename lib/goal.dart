import 'package:LCI/custom-components.dart';
import 'package:LCI/entity/GoalsDetails.dart';
import 'package:LCI/entity/LCIScore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'campaign.dart';
import 'entity/Video.dart';
import 'lci.dart';

class LoadGoals extends StatelessWidget {
  final userdata;
  final toGetUid;
  final isSelf;

  const LoadGoals({Key key, this.userdata, this.isSelf = true, this.toGetUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ref;
    if (isSelf) {
      ref = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('Goals');
    } else {
      ref = FirebaseFirestore.instance.collection('UserData').doc(toGetUid).collection('Goals');
    }

    return FutureBuilder<QuerySnapshot>(
      future: ref.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var goals = snapshot.data;

          if (goals == null || goals.size == 0) {
            if (isSelf) {
              return Goals(userdata: userdata, edit: false);
            } else {
              return CampaignUserDetails(goalExists: false, userdata: userdata);
            }
          } else {
            var goalDate = goals.docs.last.id;
            return GetScoreFromGoals(userdata: userdata, goals: goals.docs.last.data(), goalDate: goalDate, isSelf: isSelf, toGetUid: toGetUid);
          }
        }

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class GetScoreFromGoals extends StatelessWidget {
  final goals;
  final goalDate;
  final isSelf;
  final userdata;
  final toGetUid;

  const GetScoreFromGoals({Key key, this.goals, this.goalDate, this.isSelf, this.userdata, this.toGetUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ref;
    if (isSelf) {
      ref = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('LCIScore').doc(goals['targetLCI']);
    } else {
      ref = FirebaseFirestore.instance.collection('UserData').doc(toGetUid).collection('LCIScore').doc(goals['targetLCI']);
    }

    return FutureBuilder<DocumentSnapshot>(
      future: ref.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var score = snapshot.data;
          if (isSelf) {
            return GoalStatus(goals: goals, score: score, goalDate: goalDate);
          } else {
            return CampaignUserDetails(goals: goals, score: score, userdata: userdata, goalExists: true);
          }
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class Goals extends StatefulWidget {
  final userdata;
  final goals;
  final edit;

  const Goals({this.userdata, this.edit, this.goals});

  _GoalsState createState() => _GoalsState(userdata: userdata, edit: edit, goals: goals);
}

class _GoalsState extends State<Goals> {
  final userdata;
  final edit;
  Map<String, dynamic> goals;

  _GoalsState({this.userdata, this.edit, this.goals});

  int totalSelected;

  Future<void> infoVideo() {
    return showDialog<void>(
      context: context,
      builder: (c) {
        return PopupPlayer(
          url: Video.VIDEO_1,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (!edit) {
      goals = Map<String, dynamic>();
      goals['Spiritual Life'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Romance Relationship'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Family'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Social Life'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Health & Fitness'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Hobby & Leisure'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Physical Environment'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Self-Development'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Career or Study'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
      goals['Finance'] = {"selected": false, "q1": "", "q2": "", "q3": "", "q4": "", "target": 0.0};
    }
    int i = 0;
    goals.forEach((key, value) {
      if (key != "targetLCI") {
        if (value['selected']) {
          i++;
        }
      }
    });
    totalSelected = i;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) async {
        if (!value.get('viewedGoals')) {
          infoVideo();
          await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({
            "viewedGoals": true,
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var goalDetails = GoalsDetails();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Setting Up Your Goals',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                        if (key != "targetLCI") {
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
                        } else {
                          return SizedBox.shrink();
                        }
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
                        if (totalSelected == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select at least one goal')));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoadScore(userdata: userdata, goals: goals)));
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
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
          var scoreTemp = snapshot.data;
          var score;

          if (scoreTemp == null || scoreTemp.size == 0) {
            return GoalsNoLci(userdata: userdata);
          } else {
            var latest = DateFormat('d-M-y').format(DateFormat('d-M-y').parse(scoreTemp.docs.last.id));
            scoreTemp.docs.forEach((e) {
              var temp = DateFormat('d-M-y').format(DateFormat('d-M-y').parse(e.id));
              if (temp.compareTo(latest) >= 0) {
                score = e;
              }
            });
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
          child: Column(
            children: [
              PageHeadings(
                text: 'LCI Result Missing',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'You haven\'t done any LCI Test before. Please do the following test below',
                      style: TextStyle(color: Color(0xFF5D88FF), fontSize: 16),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
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
            ],
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
  final _targetController = new TextEditingController();
  final _qOneController = new TextEditingController();
  final _qTwoController = new TextEditingController();
  final _qThreeController = new TextEditingController();
  final _qFourController = new TextEditingController();

  List<String> displayedList;
  Map<String, dynamic> goals;
  String toDisplay;
  FocusNode _targetNode;
  FocusNode _qOneNode;
  FocusNode _qTwoNode;
  FocusNode _qThreeNode;
  FocusNode _qFourNode;
  Map<String, double> subScore;

  var goalDetails = new GoalsDetails();
  var targetScore = 0.0;
  var questionStyle;
  var scoreObj;

  _GoalSettingState(this.userdata, this.score, this.goals, this.displayedList);

  void initState() {
    super.initState();
    _targetNode = FocusNode();
    _qOneNode = FocusNode();
    _qTwoNode = FocusNode();
    _qThreeNode = FocusNode();
    _qFourNode = FocusNode();
    _targetNode.addListener(() {
      setState(() {});
    });
    _qOneNode.addListener(() {
      setState(() {});
    });
    _qTwoNode.addListener(() {
      setState(() {});
    });
    _qThreeNode.addListener(() {
      setState(() {});
    });
    _qFourNode.addListener(() {
      setState(() {});
    });

    if (displayedList == null) {
      displayedList = [];
    }

    goals.entries.forEach((element) {
      if (element.key != "targetLCI") {
        if (element.value['selected']) {
          if (!displayedList.contains(element.key)) {
            toDisplay = element.key;
            return;
          }
        }
      }
    });

    _targetController.text = goals[toDisplay]['target'].toString();
    _qOneController.text = goals[toDisplay]['q1'];
    _qTwoController.text = goals[toDisplay]['q2'];
    _qThreeController.text = goals[toDisplay]['q3'];
    _qFourController.text = goals[toDisplay]['q4'];

    scoreObj = new LCIScore(score.data());
    subScore = scoreObj.subScore();

    questionStyle = TextStyle(
      fontSize: 16,
      color: goalDetails.getColor(toDisplay),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('Goals');

    Future<void> updateGoals() {
      var dateNow = DateTime.now();
      return user.doc(DateTime(dateNow.year, dateNow.month, dateNow.day).toString()).set(goals).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('There was an error inserting the item, please try again.'),
          )));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: "Milestone Goals",
                metaText: "Review your current status with your goals",
                popAvailable: true,
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                              Row(
                                children: [
                                  Text(
                                    "Current Value",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: goalDetails.getColor(toDisplay),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  SvgPicture.asset('assets/info.svg', height: 16, width: 16, color: Color(0xFFFFCC00)),
                                ],
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
                          Row(
                            children: [
                              Text(
                                "Your Goal",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: goalDetails.getColor(toDisplay),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              SvgPicture.asset('assets/info.svg', height: 16, width: 16, color: Color(0xFFFFCC00)),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          InputBox(
                            focusNode: _targetNode,
                            focusNodeNext: _qOneNode,
                            controller: _targetController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    Row(
                      children: [
                        Text(
                          "How do you define your goal ?",
                          style: questionStyle,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        SvgPicture.asset('assets/info.svg', height: 16, width: 16, color: Color(0xFFFFCC00)),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    InputBox(focusNode: _qOneNode, focusNodeNext: _qTwoNode, controller: _qOneController, minLines: 5, maxLines: 5, color: goalDetails.getColor(toDisplay)),
                    Padding(padding: EdgeInsets.all(20)),
                    Row(
                      children: [
                        Text(
                          "What do you want to achieve in 1 month ?",
                          style: questionStyle,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        SvgPicture.asset('assets/info.svg', height: 16, width: 16, color: Color(0xFFFFCC00)),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    InputBox(focusNode: _qTwoNode, focusNodeNext: _qThreeNode, controller: _qTwoController, minLines: 5, maxLines: 5, color: goalDetails.getColor(toDisplay)),
                    Padding(padding: EdgeInsets.all(20)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "What do you need to do weekly to achieve the above ?",
                            style: questionStyle,
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SvgPicture.asset('assets/info.svg', height: 16, width: 16, color: Color(0xFFFFCC00)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    InputBox(focusNode: _qThreeNode, focusNodeNext: _qFourNode, controller: _qThreeController, color: goalDetails.getColor(toDisplay)),
                    Padding(padding: EdgeInsets.all(20)),
                    Row(
                      children: [
                        Text(
                          "How many times a week ?",
                          style: questionStyle,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        SvgPicture.asset('assets/info.svg', height: 16, width: 16, color: Color(0xFFFFCC00)),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    InputBox(focusNode: _qFourNode, controller: _qFourController, keyboardType: TextInputType.number, color: goalDetails.getColor(toDisplay)),
                    Padding(padding: EdgeInsets.all(20)),
                    PrimaryButton(
                      text: "Confirm & Proceed",
                      color: Color(0xFF299E45),
                      textColor: Colors.white,
                      onClickFunction: () async {
                        var targetScore = double.tryParse(_targetController.text);
                        if (targetScore != null) {
                          if (targetScore <= subScore[toDisplay] || targetScore > 10) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Goal input cannot be lesser than current value and cannot be higher than 10'),
                            ));
                            return;
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid goal input.'),
                          ));
                          return;
                        }

                        var selectedCount = 0;
                        displayedList.add(toDisplay);
                        goals.entries.forEach((element) {
                          if (element.key != "targetLCI") {
                            if (element.value['selected']) {
                              selectedCount++;
                            }
                          }
                        });

                        if (displayedList.length != selectedCount) {
                          if (_qOneController.text.isNotEmpty && _qTwoController.text.isNotEmpty && _qThreeController.text.isNotEmpty && _qFourController.text.isNotEmpty) {
                            goals[toDisplay]['target'] = _targetController.text;
                            goals[toDisplay]['q1'] = _qOneController.text;
                            goals[toDisplay]['q2'] = _qTwoController.text;
                            goals[toDisplay]['q3'] = _qThreeController.text;
                            goals[toDisplay]['q4'] = _qFourController.text;
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please make sure all questions had been answered.'),
                            ));
                            return;
                          }
                        } else {
                          if (_qOneController.text.isNotEmpty && _qTwoController.text.isNotEmpty && _qThreeController.text.isNotEmpty && _qFourController.text.isNotEmpty) {
                            goals[toDisplay]['target'] = _targetController.text;
                            goals[toDisplay]['q1'] = _qOneController.text;
                            goals[toDisplay]['q2'] = _qTwoController.text;
                            goals[toDisplay]['q3'] = _qThreeController.text;
                            goals[toDisplay]['q4'] = _qFourController.text;
                            goals['targetLCI'] = score.id;
                            var dateNow = DateTime.now();
                            await updateGoals();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GoalStatus(
                                  score: score,
                                  goals: goals,
                                  goalDate: DateTime(dateNow.year, dateNow.month, dateNow.day).toString(),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please make sure all questions had been answered.'),
                            ));
                            return;
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalStatus extends StatelessWidget {
  final goals;
  final goalDate;
  final score;

  const GoalStatus({Key key, this.goals, this.score, this.goalDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var goalDetails = new GoalsDetails();
    var scoreObj = new LCIScore(score.data());

    Map<String, dynamic> getSelected() {
      Map<String, dynamic> result = {};
      goals.forEach((key, value) {
        if (key != "targetLCI") {
          if (value['selected']) {
            result[key] = value;
          }
        }
      });
      return result;
    }

    Map<String, dynamic> goalsTemp = getSelected();
    Map<String, dynamic> subScore = scoreObj.subScore();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: "Milestone Goals",
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: goalsTemp.keys.map((key) {
                        return Column(
                          children: [
                            PrimaryCard(
                              padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextWithIcon(
                                    assetColor: goalDetails.getColor(key),
                                    assetPath: goalDetails.getAssetPath(key),
                                    text: key,
                                    textStyle: TextStyle(fontSize: 22, color: goalDetails.getColor(key), fontWeight: FontWeight.w700),
                                  ),
                                  Padding(padding: EdgeInsets.all(7.5)),
                                  MultiColorProgressBar(subScore[key] / 10, double.parse(goalsTemp[key]['target']) / 10, Color(0xFF170E9A), Color(0xFF0DC5B2)),
                                  Padding(padding: EdgeInsets.all(15)),
                                  Text(
                                    "Definition of Success/Goal",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: goalDetails.getColor(key),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text(
                                    goalsTemp[key]['q1'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: goalDetails.getColor(key),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(15)),
                                  Text(
                                    "Achivemenet within this month",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: goalDetails.getColor(key),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text(
                                    goalsTemp[key]['q2'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: goalDetails.getColor(key),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(15)),
                                  Text(
                                    "Weekly tasks to achieve",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: goalDetails.getColor(key),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text(
                                    goalsTemp[key]['q3'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: goalDetails.getColor(key),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(30)),
                          ],
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Goal Setting Date:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('d/M/y').format(DateTime.parse(goalDate)),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    PrimaryButton(
                      text: "Review / Revise Goals",
                      color: Color(0xFF170E9A),
                      textColor: Colors.white,
                      onClickFunction: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Goals(goals: goals, edit: true)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
