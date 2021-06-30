import 'package:LCI/wheeloflife.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:spider_chart/spider_chart.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'custom-components.dart';
import 'entity/LCIScore.dart';
import 'entity/Video.dart';
import 'home.dart';

class Lci extends StatelessWidget {
  final userdata;

  const Lci({this.userdata});

  @override
  Widget build(BuildContext context) {
    var lciRules = "Life Compass Inventory (LCI) is a tool that quantify 10 areas in your life, and therefore able to visually understand your current life’s condition.\n\n" +
        "Imagine today you would like to understand your body health condition, you will go to hospital or clinic to do some test like blood test, urine test and etc. And the function of all these tests is to transform your body condition to a readable number, so that you can understand your body condition. LCI does the same for your life.\n\n" +
        "It is an inventory that helps individual to explore and aware of different areas in life in a deeper level, by transforming the result to a readable quantification. It gives a deeper understanding to each area of life.\n\n" +
        "To do this, we will recommend you do the LCI under these conditions:\n" +
        "First, find a place that you can focus and will not be disturb for 10 minutes \n" +
        "Secondly, clear your mind, take few deep breath\n" +
        "Third, there will be 50 questions, try to answer with your first impression, there is no right or wrong\n\n" +
        "You will need to choose if you are Single or In Relationship/Engage before you start. Once you complete, you will get a chart that shows your wheel of life. You can do it once a month or two to keep track your progress. Enjoy!";
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
                padding: EdgeInsets.fromLTRB(20, 25, 25, 25),
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
                          Text(
                            lciRules,
                            style: TextStyle(
                              fontSize: 16,
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
                  minHeight: MediaQuery
                      .of(context)
                      .size
                      .height - MediaQuery
                      .of(context)
                      .padding
                      .top - MediaQuery
                      .of(context)
                      .padding
                      .bottom - 86,
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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
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
                            builder: (context) =>
                                PartTwo(
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
      if (f == 0) {
        f = 5;
      }
      subList.add(f.toString());
    }
    print(subList);
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GetUserData(point: 0)));
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery
                    .of(context)
                    .size
                    .height - MediaQuery
                    .of(context)
                    .padding
                    .top - MediaQuery
                    .of(context)
                    .padding
                    .bottom,
              ),
              padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeadings(text: 'Your LCI Result', padding: EdgeInsets.zero),
                  Padding(padding: EdgeInsets.all(10)),
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
                  Padding(padding: EdgeInsets.all(10)),
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GetUserData(point: 0)));
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

class LCIMain extends StatefulWidget {
  _LCIMainState createState() => _LCIMainState();
}

class _LCIMainState extends State<LCIMain> {
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

  var ref;

  @override
  void initState() {
    super.initState();
    ref = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('LCIScore').get();
    FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) async {
      if (!value.get('viewedLCI')) {
        infoVideo();
        await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({
          "viewedLCI": true,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: "Welcome to LCI Test",
                metaText: "Brief explanation of LCI Test here.",
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Past LCI Results',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    FutureBuilder(
                      future: ref,
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          var data = snapshot.data.docs.asMap();
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var val = data[index].data();
                              var id = data[index].id.split("-");
                              var day = int.parse(id[0]);
                              var month = int.parse(id[1]);
                              var year = int.parse(id[2]);
                              var displayDate = DateFormat('MMMM y - d/M/y').format(DateTime(year, month, day));
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => WheelOfLife(scoreBundle: val, getSpecific: true)));
                                },
                                child: PrimaryCard(
                                  child: Text(
                                    displayDate,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return Container(
                          padding: EdgeInsets.all(30),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    PrimaryButton(
                      text: "Take New LCI Test",
                      textColor: Colors.white,
                      color: Color(0xFFBC7AFE),
                      onClickFunction: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Lci()));
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
