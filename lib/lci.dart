import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:radar_chart/radar_chart.dart';

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
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 25, 25),
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
                              fontSize: 14,
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
  var ref;

  @override
  void initState() {
    super.initState();
    ref = FirebaseFirestore.instance.collection('LCITest').doc('Questions').get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Text("Something went wrong"),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> questions = snapshot.data.data();
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PageHeadings(
                      text: 'LCI Test',
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
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
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
                                  builder: (context) => QuestionForm(
                                    selected: selected,
                                    questions: questions,
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

class QuestionForm extends StatefulWidget {
  final selected;
  final questions;

  const QuestionForm({Key key, this.questions, this.selected}) : super(key: key);

  _QuestionFormState createState() => _QuestionFormState(questions, selected);
}

class _QuestionFormState extends State<QuestionForm> {
  final String selected;
  final Map<String, dynamic> questions;

  int currentPage = 1;
  int totalPage;
  double progress = 0.0;
  bool allowSubmit = false;
  List<String> randomizedList = [];
  List<String> completedList = [];
  List<String> skipList = [];
  List<double> scoreList = [];
  DateTime dateNow;
  Map<String, dynamic> score = {};

  PageController _pageController = new PageController();

  _QuestionFormState(this.questions, this.selected);

  @override
  void initState() {
    super.initState();
    questions.forEach((key, value) {
      if (value['type'] == "Single" || value['type'] == "Engaged") {
        if (value['type'] != selected) {
          skipList.add(key);
        }
      }
    });

    for (var i = 1; i <= questions.length; i++) {
      if (!skipList.contains(i.toString())) {
        randomizedList.add(i.toString());
        scoreList.add(5.5);
      }
    }
    totalPage = (randomizedList.length % 5 == 0 ? randomizedList.length / 5 : (randomizedList.length / 5) + 1).toInt();

    randomizedList.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> setScore() async {
      if (dateNow == null) {
        dateNow = DateTime.now();
      }
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('LCIScore')
          .doc(DateFormat('d-M-y').format(DateTime(dateNow.year, dateNow.month, dateNow.day)).toString())
          .set(score)
          .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => LciResult(score: score)));
      });
    }

    void getProgress() {
      setState(() {
        progress = completedList.length / randomizedList.length;
        if (progress == 1) {
          allowSubmit = true;
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeadings(
              text: 'LCI Test',
              popAvailable: true,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 160 - 8.6,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page + 1;
                  });
                },
                children: [
                  for (var page = 1; page <= totalPage; page++)
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(padding: EdgeInsets.all(10)),
                            for (var qIndex = (page * 5) - 5; qIndex < randomizedList.length && qIndex < page * 5; qIndex++)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  Padding(padding: EdgeInsets.all(20)),
                                  Text(
                                    questions[randomizedList[qIndex].toString()]['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF170E9A)),
                                  ),
                                  Padding(padding: EdgeInsets.all(24)),
                                  AnswerSlider(
                                    value: scoreList[qIndex],
                                    callBack: (value) {
                                      scoreList[qIndex] = value;
                                      if (!completedList.contains(qIndex.toString())) {
                                        completedList.add(qIndex.toString());
                                        getProgress();
                                      }
                                    },
                                  ),
                                  Padding(padding: EdgeInsets.all(20)),
                                ],
                              ),
                            Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            page == totalPage
                                ? SecondaryButton(
                                    disabled: !allowSubmit,
                                    color: Color(0xFF299E45),
                                    text: "Submit",
                                    onClickFunction: () async {
                                      score = {};
                                      showLoading(context);
                                      for (var i = 0; i < randomizedList.length; i++) {
                                        var key;
                                        if (questions[randomizedList[i].toString()]['type'] == "Single" || questions[randomizedList[i].toString()]['type'] == "Engaged") {
                                          key = "Romance Relationship";
                                        } else {
                                          key = questions[randomizedList[i].toString()]['type'];
                                        }
                                        Map<String, double> scoreContent = score[key];
                                        if (scoreContent == null) {
                                          scoreContent = {
                                            "q1": scoreList[i],
                                          };
                                        } else {
                                          var totalAdded = scoreContent.length;
                                          String questionHeader = "q" + (totalAdded + 1).toString();
                                          scoreContent[questionHeader] = scoreList[i];
                                        }
                                        score[key] = scoreContent;
                                      }
                                      await setScore();
                                    },
                                  )
                                : SizedBox.shrink(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                currentPage != 1
                                    ? GestureDetector(
                                        onTap: () {
                                          _pageController.jumpToPage(_pageController.page.toInt() - 1);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF170E9A),
                                            ),
                                            child: SvgPicture.asset('assets/chevron-left.svg', color: Colors.white, height: 14, width: 14)),
                                      )
                                    : SizedBox(width: 41),
                                Text(currentPage.toString() + "/" + totalPage.toStringAsFixed(0), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6E6E6E))),
                                currentPage != totalPage
                                    ? GestureDetector(
                                        onTap: () {
                                          _pageController.jumpToPage(_pageController.page.toInt() + 1);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF170E9A),
                                            ),
                                            child: SvgPicture.asset('assets/chevron-right.svg', color: Colors.white, height: 14, width: 14)),
                                      )
                                    : SizedBox(width: 41),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(0),
              color: Color(0xFF5E5E5E),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (progress * 100).toStringAsFixed(0) + "%",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: LinearProgressIndicator(
                        value: progress,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF299E45)),
                        backgroundColor: Color(0xFFCDCDCD),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
  var list;

  @override
  void initState() {
    super.initState();
    score = {
      "Career or Study": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      },
      "Family": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      },
      "Finance": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      },
      "Health & Fitness": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      },
      "Hobby & Leisure": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      },
      "Physical Environment": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      },
      "Self-Development": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      },
      "Social Life": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
      },
      "Spiritual Life": {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      }
    };
    if (selected == "Single") {
      list = ["1", "2", "3"];
      score['Romance Relationship'] = {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
      };
    } else {
      list = ["1", "2", "3", "4"];
      score['Romance Relationship'] = {
        "1": 5.5,
        "2": 5.5,
        "3": 5.5,
        "4": 5.5,
      };
    }
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
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                                Padding(padding: EdgeInsets.all(20)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    questions.get(q)['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF170E9A)),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(24)),
                                AnswerSlider(
                                  value: score['Romance Relationship'][q],
                                  callBack: (value) {
                                    setState(() {
                                      score['Romance Relationship'][q] = value;
                                    });
                                  },
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                              ],
                            ),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          Padding(padding: EdgeInsets.all(20)),
                          PrimaryButton(
                            text: 'Next',
                            color: Color(0xFF299E45),
                            textColor: Colors.white,
                            onClickFunction: () {
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
  var completedList = [];
  var loading = false;
  var totalPage;
  var progress = 0.0;
  var currentPage = 1;
  var allowSubmit = false;

  DateTime dateNow;
  PageController _pageController = new PageController();

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

    list.shuffle();

    dateNow = getTime();
    totalPage = list.length / 5;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> setScore() async {
      if (dateNow == null) {
        dateNow = DateTime.now();
      }
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('LCIScore')
          .doc(DateFormat('d-M-y').format(DateTime(dateNow.year, dateNow.month, dateNow.day)).toString())
          .set(score)
          .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => LciResult(score: score)));
      });
    }

    void getProgress() {
      setState(() {
        progress = completedList.length / 45;
        if (progress == 1) {
          allowSubmit = true;
        }
      });
    }

    return FutureBuilder(
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
              child: Column(
                children: [
                  PageHeadings(
                    text: 'Part 3',
                    metaText: 'LCI Test',
                    popAvailable: true,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        currentPage != 1
                            ? GestureDetector(
                                onTap: () {
                                  _pageController.jumpToPage(_pageController.page.toInt() - 1);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF170E9A),
                                    ),
                                    child: SvgPicture.asset('assets/chevron-left.svg', color: Colors.white, height: 14, width: 14)),
                              )
                            : SizedBox(width: 41),
                        Text(currentPage.toString() + "/" + totalPage.toStringAsFixed(0), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6E6E6E))),
                        currentPage != totalPage
                            ? GestureDetector(
                                onTap: () {
                                  _pageController.jumpToPage(_pageController.page.toInt() + 1);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF170E9A),
                                    ),
                                    child: SvgPicture.asset('assets/chevron-right.svg', color: Colors.white, height: 14, width: 14)),
                              )
                            : SizedBox(width: 41),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 116 - 49 - 0.667 - 46,
                    width: MediaQuery.of(context).size.width,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          currentPage = page + 1;
                        });
                      },
                      children: [
                        for (var page = 1; page <= totalPage; page++)
                          Container(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(padding: EdgeInsets.all(10)),
                                  for (var q = (page * 5) - 4; q <= page * 5; q++)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                        ),
                                        Padding(padding: EdgeInsets.all(20)),
                                        Text(
                                          questions.get(q.toString())['title'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF170E9A)),
                                        ),
                                        Padding(padding: EdgeInsets.all(24)),
                                        AnswerSlider(
                                          value: score[questions.get(q.toString())['type']][subList[int.parse(q.toString()) - 1]],
                                          callBack: (value) {
                                            score[questions.get(q.toString())['type']][subList[int.parse(q.toString()) - 1]] = value;
                                            if (!completedList.contains(q)) {
                                              completedList.add(q);
                                              getProgress();
                                            }
                                          },
                                        ),
                                        Padding(padding: EdgeInsets.all(20)),
                                      ],
                                    ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  page == totalPage
                                      ? SecondaryButton(
                                          disabled: !allowSubmit,
                                          color: Color(0xFF299E45),
                                          text: "Submit",
                                          onClickFunction: () async {
                                            showLoading(context);
                                            setState(() {
                                              loading = true;
                                            });
                                            await setScore();
                                          },
                                        )
                                      : SizedBox.shrink(),
                                  Padding(padding: EdgeInsets.all(10)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(0),
                    color: Color(0xFF5E5E5E),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (progress * 100).toStringAsFixed(0) + "%",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: LinearProgressIndicator(
                              value: progress,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF299E45)),
                              backgroundColor: Color(0xFFCDCDCD),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

class LciResult extends StatelessWidget {
  final score;
  final view;

  const LciResult({Key key, this.score, this.view}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LCIScore scoreObj = LCIScore(score);
    var subScore = scoreObj.subScore();
    var colors = scoreObj.colors();

    return WillPopScope(
      onWillPop: () async {
        if (view == null && !view) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GetUserData(point: 0)));
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeadings(text: 'Your LCI Result', padding: EdgeInsets.zero),
                  Padding(padding: EdgeInsets.all(10)),
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/radar-bg-complete.png',
                          height: 260,
                          width: 260,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 46),
                        child: Center(
                          child: RadarChart(
                            initialAngle: 5,
                            length: 10,
                            radius: 84,
                            radars: [
                              RadarTile(
                                borderStroke: 1,
                                borderColor: Color(0xFFFF8000),
                                backgroundColor: Color(0xFFFF8000).withOpacity(0.2),
                                values: [
                                  subScore['Spiritual Life'] / 10,
                                  subScore['Romance Relationship'] / 10,
                                  subScore['Family'] / 10,
                                  subScore['Social Life'] / 10,
                                  subScore['Health & Fitness'] / 10,
                                  subScore['Hobby & Leisure'] / 10,
                                  subScore['Physical Environment'] / 10,
                                  subScore['Self-Development'] / 10,
                                  subScore['Career or Study'] / 10,
                                  subScore['Finance'] / 10,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: Text(
                      scoreObj.firstDisplay(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  view != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Your focused fields",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  view != null
                      ? FutureBuilder(
                          future: FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('Goals').get(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Padding(
                                padding: EdgeInsets.all(30),
                                child: Center(
                                  child: Text("Something went wrong"),
                                ),
                              );
                            }

                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.data.size != 0) {
                                Map<String, dynamic> goal = snapshot.data.docs.last.data();
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: goal.length,
                                    itemBuilder: (c, i) {
                                      if (goal.entries.elementAt(i).key != "targetLCI" && goal.entries.elementAt(i).value['selected']) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 30),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    goal.entries.elementAt(i).key,
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                  ),
                                                  Text(
                                                    (subScore[goal.entries.elementAt(i).key] * 10).toStringAsFixed(0) + "%",
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              Padding(padding: EdgeInsets.all(3)),
                                              RoundedLinearProgress(
                                                color: colors[goal.entries.elementAt(i).key],
                                                value: subScore[goal.entries.elementAt(i).key] / 10,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    });
                              } else {
                                return Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Center(
                                    child: Text('No goals setted'),
                                  ),
                                );
                              }
                            }
                            return Padding(
                              padding: EdgeInsets.all(30),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                  Padding(padding: EdgeInsets.all(15)),
                  Text(
                    view != null ? "All fields" : "Overview",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Column(
                    children: subScore.keys.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e,
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                                Text(
                                  ((subScore[e] * 10).toStringAsFixed(0)) + "%",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(3)),
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
                          Map<dynamic, dynamic> data = snapshot.data.docs.asMap();
                          data.forEach((key, value) {

                          });
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var id = data[index].id.split("-");
                              var day = int.parse(id[0]);
                              var month = int.parse(id[1]);
                              var year = int.parse(id[2]);
                              var displayDate = DateFormat('MMMM y - d/M/y').format(DateTime(year, month, day));
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LciResult(score: data[index].data(), view: true)));
                                  },
                                  child: PrimaryCard(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      displayDate,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
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
