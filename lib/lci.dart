import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:spider_chart/spider_chart.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
          child: Column(
            children: [
              PageHeadings(
                text: 'Welcome to LCI Test',
                metaText: 'Brief explanation of LCI Test here',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PartOne()));
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

class PartOne extends StatefulWidget {
  _PartOne createState() => _PartOne();
}

class _PartOne extends State<PartOne> {
  var selected = 'Single';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Part 1',
                popAvailable: true,
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 86,
                ),
                padding: EdgeInsets.fromLTRB(25, 10, 25, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Are you single or engaged?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = "Single";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
                                decoration: BoxDecoration(
                                  color: selected == "Single" ? Color(0xFF170E9A) : Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: selected != "Single" ? Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)) : Border.all(color: Colors.transparent),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/check.svg',
                                      color: selected == "Single" ? Colors.white : Color(0xFFCDCDCD),
                                      height: 20,
                                      width: 20,
                                    ),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Text(
                                      'Single',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: selected == "Single" ? Colors.white : Color(0xFF9B9B9B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = "Engaged";
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
                                decoration: BoxDecoration(
                                  color: selected == "Engaged" ? Color(0xFF170E9A) : Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: selected != "Engaged" ? Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)) : Border.all(color: Colors.transparent),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/check.svg',
                                      color: selected == "Engaged" ? Colors.white : Color(0xFFCDCDCD),
                                      height: 20,
                                      width: 20,
                                    ),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Text(
                                      'Engaged',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: selected == "Engaged" ? Colors.white : Color(0xFF9B9B9B),
                                      ),
                                    ),
                                  ],
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
                            builder: (context) => PartTwo(
                              selected: selected,
                            ),
                          ),
                        );
                      },
                      text: 'Next',
                      color: Color(0xFF299E45),
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

class PartTwo extends StatefulWidget {
  final selected;

  const PartTwo({Key key, this.selected}) : super(key: key);

  _PartTwoState createState() => _PartTwoState(selected);
}

class _PartTwoState extends State<PartTwo> {
  final selected;

  _PartTwoState(this.selected);

  var score = Map<String, Map<String, double>>();
  var questionRef;
  var list = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    score = {
      "Career or Study": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Family": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Finance": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Health & Fitness": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Hobby & Leisure": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Physical Environment": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Romance Relationship": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Self-Development": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Social Life": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      },
      "Spiritual Life": {
        "1": 1.0,
        "2": 1.0,
        "3": 1.0,
        "4": 1.0,
        "5": 1.0,
      }
    };
    questionRef = FirebaseFirestore.instance.collection('LCITest').doc(selected).get();
    list.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: questionRef,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Text('Something went wrong'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var questions = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PageHeadings(
                      text: 'Part 2',
                      metaText: 'Romance Relationship',
                      popAvailable: true,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var q in list)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PrimaryCard(
                                  padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        questions.get(q)['title'],
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                      ),
                                      SfSlider(
                                        min: 1.0,
                                        max: 10.0,
                                        interval: 1.0,
                                        showTicks: true,
                                        showLabels: true,
                                        stepSize: 1.0,
                                        value: score['Romance Relationship'][q],
                                        onChanged: (value) {
                                          setState(() {
                                            score['Romance Relationship'][q] = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                              ],
                            ),
                          PrimaryButton(
                            text: 'Next',
                            color: Color(0xFF299E45),
                            textColor: Colors.white,
                            onClickFunction: () {
                              for (var q in list) {
                                if (questions.get(q)['reverse']) {
                                  score['Romance Relationship'][q] = 11.0 - score['Romance Relationship'][q];
                                  break;
                                }
                              }
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllQuestionForm(score: score)));
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

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class AllQuestionForm extends StatefulWidget {
  final score;

  const AllQuestionForm({Key key, this.score}) : super(key: key);

  _AllQuestionFormState createState() => _AllQuestionFormState(score);
}

class _AllQuestionFormState extends State<AllQuestionForm> {
  final score;

  _AllQuestionFormState(this.score);

  var _getAllQuestions;

  var list = [];
  var subList = [];
  var loading = false;

  DateTime dateNow;

  Future<DateTime> getNetworkTime() async {
    DateTime _myTime;
    _myTime = await NTP.now();
    return _myTime;
  }

  @override
  void initState() {
    super.initState();
    _getAllQuestions = FirebaseFirestore.instance.collection('LCITest').doc('All').get();
    for (var i = 1; i <= 45; i++) {
      list.add(i.toString());
      var x = i;
      var f = x % 5;
      if(x == 0) {
        f = 5;
      }
      subList.add(f.toString());
    }
    list.shuffle();
    getNetworkTime().then((value) {
      setState(() {
        dateNow = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> setScore() async {
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('LCIScore')
          .doc(DateFormat('d-M-y').format(DateTime(dateNow.year, dateNow.month, dateNow.day)).toString())
          .set(score)
          .then((value) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => LciResult(score: score)));
      });
    }

    return !loading
        ? FutureBuilder(
            future: _getAllQuestions,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: SafeArea(
                    child: Text('Something went wrong'),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                var questions = snapshot.data;
                return Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          PageHeadings(
                            text: 'Part 3',
                            metaText: 'LCI Test',
                            popAvailable: true,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(25, 10, 25, 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var q in list)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      PrimaryCard(
                                        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              questions.get(q)['title'],
                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                            ),
                                            SfSlider(
                                              min: 1.0,
                                              max: 10.0,
                                              interval: 1.0,
                                              showTicks: true,
                                              showLabels: true,
                                              stepSize: 1.0,
                                              value: score[questions.get(q)['type']][subList[int.parse(q) - 1]],
                                              onChanged: (value) {
                                                setState(() {
                                                  score[questions.get(q)['type']][subList[int.parse(q) - 1]] = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                    ],
                                  ),
                                PrimaryButton(
                                  text: 'Next',
                                  color: Color(0xFF299E45),
                                  textColor: Colors.white,
                                  onClickFunction: () async {
                                    for (var q in list) {
                                      if (questions.get(q)['reverse']) {
                                        score[questions.get(q)['type']][subList[int.parse(q) - 1]] = 11.0 - score[questions.get(q)['type']][subList[int.parse(q) - 1]];
                                      }
                                    }
                                    setState(() {
                                      loading = true;
                                    });
                                    await setScore();
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

              return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          )
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class LciResult extends StatelessWidget {
  final score;

  const LciResult({Key key, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LCIScore scoreObj = LCIScore(score);
    var subScore = scoreObj.subScore();
    var colors = scoreObj.colors();

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
                      subScore['Spiritual Life'],
                      subScore['Romance Relationship'],
                      subScore['Family'],
                      subScore['Social Life'],
                      subScore['Health & Fitness'],
                      subScore['Hobby & Leisure'],
                      subScore['Physical Environment'],
                      subScore['Self-Development'],
                      subScore['Career or Study'],
                      subScore['Finance']
                    ],
                    maxValue: 10,
                    colors: [
                      Color(0xFF7C0E6F),
                      Color(0xFF6EC8F4),
                      Color(0xFFC4CF54),
                      Color(0xFFE671A8),
                      Color(0xFF003989),
                      Color(0xFFF27C00),
                      Color(0xFFFFE800),
                      Color(0xFF00862F),
                      Color(0xFFD9000D),
                      Color(0xFF8C8B8B),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text(
                  'Your top 3 focused fields',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                Column(
                  children: subScore.keys.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            e,
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          RoundedLinearProgress(
                            color: colors[e],
                            value: subScore[e] / 10,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Padding(padding: EdgeInsets.all(20)),
                PrimaryButton(
                  text: 'Back to home',
                  textColor: Colors.white,
                  color: Color(0xFF170E9A),
                  onClickFunction: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
