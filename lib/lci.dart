import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:spider_chart/spider_chart.dart';

import 'custom-components.dart';
import 'entity/LCIScore.dart';
import 'entity/UserData.dart';

class Lci extends StatelessWidget {
  final userdata;

  const Lci({this.userdata});

  @override
  Widget build(BuildContext context) {
    var lciRules = ['Any Rules can state here'];

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
                  text: 'Welcome to LCI Test',
                  metaText: 'Brief explanation of LCI Test here',
                ),
                Padding(padding: EdgeInsets.all(20)),
                PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Things before test',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      for (var i = 0; i < lciRules.length; i++)
                        Text(
                          (i + 1).toString() + '. ' + lciRules[i],
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF5D88FF),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                PrimaryButton(
                  color: Color(0xFF00A83B),
                  textColor: Colors.white,
                  text: 'Let\'s get started',
                  onClickFunction: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LciPartOne(userdata: userdata)));
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

class LciPartOne extends StatefulWidget {
  final userdata;

  const LciPartOne({this.userdata});

  _LciPartOneState createState() => _LciPartOneState(userdata: userdata);
}

class _LciPartOneState extends State<LciPartOne> {
  UserData userdata;

  _LciPartOneState({this.userdata});

  String selected = "Single";

  var sections = ['Spiritual Life', 'Single', 'Engaged', 'Family', 'Social Life', 'Health & Fitness', 'Hobby & Leisure', 'Physical Environment', 'Self-Development', 'Career or Study', 'Finance'];

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageHeadings(
                      text: 'Part 1',
                      metaText: 'Hello, ' + userdata.name,
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    Text(
                      'Are you single or engaged?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = "Single";
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            decoration: BoxDecoration(
                              color: selected == "Single" ? Color(0xFF5D88FF) : Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'SINGLE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: selected == "Single" ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = "Engaged";
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            decoration: BoxDecoration(
                              color: selected == "Engaged" ? Color(0xFF5D88FF) : Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'ENGAGED',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: selected == "Engaged" ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                PrimaryButton(
                  onClickFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoadQuestions(
                          userdata: userdata,
                          selected: selected,
                          sectionLeft: sections,
                          point: 2,
                        ),
                      ),
                    );
                  },
                  text: 'Confirm & Proceed',
                  color: Color(0xFF299E45),
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

class LciTestForm extends StatefulWidget {
  final userdata;
  final selected;
  final current;
  final questions;
  final sections;
  final part;
  final score;

  _LciTestFormState createState() => _LciTestFormState(selected, userdata, questions, sections, current, part, score);

  const LciTestForm({Key key, this.userdata, this.selected, this.questions, this.sections, this.current, this.part, this.score}) : super(key: key);
}

class _LciTestFormState extends State<LciTestForm> {
  final userdata;
  final selected;
  Map<String, dynamic> questions;
  final current;
  List<String> sections;
  final part;
  Map<String, dynamic> score = new Map<String, dynamic>();
  Map<String, dynamic> subScore = new Map<String, dynamic>();

  _LciTestFormState(this.selected, this.userdata, this.questions, this.sections, this.current, this.part, this.score);

  DateTime dateNow;

  Future<DateTime> getNetworkTime() async {
    DateTime _myTime;
    _myTime = await NTP.now();
    return _myTime;
  }

  @override
  void initState() {
    super.initState();
    getNetworkTime().then((value) {
      setState(() {
        dateNow = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var toGet = ['1', '2', '3', '4', '5'];
    String val;
    bool startOver = false;

    Future<void> showStartOver() {
      return showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return AlertDialog(
            title: Text('Are you sure you want to start over ?'),
            content: Text('You will lose all your answers if you start over.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  startOver = true;
                  Navigator.of(context).pop();
                },
                child: Text('Start Over'),
              ),
              TextButton(
                onPressed: () {
                  startOver = false;
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await showStartOver();
        if (startOver) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        return false;
      },
      child: Scaffold(
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
                    text: 'Part ' + part.toString(),
                    metaText: current == "Romance Relationship" ? '$current ($selected)' : current,
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: questions.keys.map((key) {
                      if (toGet.length == 1) {
                        val = toGet[0];
                      } else {
                        var temp = Random().nextInt(toGet.length);
                        val = toGet[temp];
                        toGet.removeAt(temp);
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: PrimaryCard(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                questions[val]['title'].toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              CustomSlider(
                                index: val,
                                callBack: (value, index) {
                                  if (questions[index]['reverse']) {
                                    subScore[index] = 10 - (value * 10);
                                  } else {
                                    subScore[index] = value * 10;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  sections.length != 0
                      ? PrimaryButton(
                          text: 'Next',
                          color: Color(0xFF170E9A),
                          textColor: Colors.white,
                          onClickFunction: () {
                            if (subScore.length < 5) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please answer all the questions'),
                              ));
                            } else {
                              if (score == null) {
                                score = {current: subScore};
                              } else {
                                score[current] = subScore;
                              }
                              var point = part + 1;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoadQuestions(
                                        userdata: userdata,
                                        selected: selected,
                                        point: point,
                                        sectionLeft: sections,
                                        score: score,
                                      )));
                            }
                          },
                        )
                      : PrimaryButton(
                          text: 'Submit',
                          color: Color(0xFF170E9A),
                          textColor: Colors.white,
                          onClickFunction: () async {
                            if (subScore.length < 5) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please answer all the questions'),
                              ));
                            } else {
                              if (score == null) {
                                score = {current: subScore};
                              } else {
                                score[current] = subScore;
                              }
                            }
                            CollectionReference ref = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('LCIScore');
                            await ref.doc(DateTime(dateNow.year, dateNow.month, dateNow.day).toString()).set(score).then((value) {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => LciResult(
                                        score: score,
                                      )));
                            }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred'))));
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadQuestions extends StatelessWidget {
  final userdata;
  final selected;
  final point;
  final List<String> sectionLeft;
  final score;

  const LoadQuestions({Key key, this.userdata, this.selected, this.point, this.sectionLeft, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentReference ref = FirebaseFirestore.instance.collection('LCITest').doc(selected);
    String current;

    if (point == 2) {
      ref = FirebaseFirestore.instance.collection('LCITest').doc(selected);
      sectionLeft.remove('Single');
      sectionLeft.remove('Engaged');
      current = "Romance Relationship";
    } else {
      int toGet = Random().nextInt(sectionLeft.length);
      current = sectionLeft[toGet];
      sectionLeft.removeAt(toGet);
      ref = FirebaseFirestore.instance.collection('LCITest').doc(current);
    }

    return FutureBuilder<DocumentSnapshot>(
      future: ref.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> questions = snapshot.data.data();

          return LciTestForm(
            userdata: userdata,
            selected: selected,
            sections: sectionLeft,
            questions: questions,
            current: current,
            part: point,
            score: score,
          );
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class CustomSlider extends StatefulWidget {
  final callBack;
  final index;

  const CustomSlider({Key key, this.callBack, this.index}) : super(key: key);

  _CustomSliderState createState() => _CustomSliderState(callBack, index);
}

class _CustomSliderState extends State<CustomSlider> {
  final index;
  Function callBack;

  var x = 0.0;

  _CustomSliderState(this.callBack, this.index);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xFF6EC8F4),
              inactiveTrackColor: Color(0xFFAFAFAF),
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 8,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
              thumbColor: Color(0xFF453EAE),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: Slider(
                label: (x * 10).toInt().toString(),
                divisions: 10,
                value: x,
                onChanged: (value) {
                  setState(() {
                    x = value;
                    callBack(x, index);
                  });
                }),
          ),
          Text(
            (x * 10).toInt().toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class LciResult extends StatelessWidget {
  final score;

  const LciResult({Key key, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LCIScore scoreObj = LCIScore();
    scoreObj.score = score;
    var dividedScore = scoreObj.dividedScore();
    var subScore = scoreObj.subScore();

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
                PageHeadings(text: 'Your LCI Result'),
                Container(
                  height: 300,
                  child: SpiderChart(
                    data: [
                      subScore['Finance'],
                      subScore['Career or Study'],
                      subScore['Self-Development'],
                      subScore['Spiritual Life'],
                      subScore['Family'],
                      subScore['Romance Relationship'],
                      subScore['Social Life'],
                      subScore['Health & Fitness'],
                      subScore['Hobby & Leisure'],
                      subScore['Physical Environment']
                    ],
                    maxValue: 10,
                    colors: [
                      Color(0xFF8C8B8B),
                      Color(0xFF7C0E6F),
                      Color(0xFF6EC8F4),
                      Color(0xFFC4CF54),
                      Color(0xFFE671A8),
                      Color(0xFF003989),
                      Color(0xFFF27C00),
                      Color(0xFFFFE800),
                      Color(0xFF00862F),
                      Color(0xFFD9000D),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
