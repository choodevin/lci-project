import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom-components.dart';
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

  _LciTestFormState createState() => _LciTestFormState(userdata, selected, questions, sections, current, part);

  const LciTestForm({Key key, this.userdata, this.selected, this.questions, this.sections, this.current, this.part}) : super(key: key);
}

class _LciTestFormState extends State<LciTestForm> {
  final userdata;
  final selected;
  Map<String, dynamic> questions;
  final current;
  List<String> sections;
  final part;

  _LciTestFormState(this.selected, this.userdata, this.questions, this.sections, this.current, this.part);

  @override
  Widget build(BuildContext context) {
    var toGet = ['1', '2', '3', '4', '5'];
    String val;

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
                  text: 'Part ' + part.toString(),
                  metaText: current,
                ),
                Padding(padding: EdgeInsets.all(20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: questions.keys.map((key) {
                    if (toGet.length == 1) {
                      val = toGet[0];
                    } else {
                      var temp = Random().nextInt(toGet.length - 1);
                      val = toGet[temp];
                      toGet.removeAt(temp);
                    }
                    return PrimaryCard(
                      child: Text(questions[val]['title'].toString()),
                    );
                  }).toList(),
                )
              ],
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

  const LoadQuestions({Key key, this.userdata, this.selected, this.point, this.sectionLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentReference ref = FirebaseFirestore.instance.collection('LCITest').doc(selected);
    String current;
    int futurePoint;

    if (point == 2) {
      ref = FirebaseFirestore.instance.collection('LCITest').doc(selected);
      sectionLeft.remove('Single');
      sectionLeft.remove('Engaged');
      current = "Romance Relationship";
      futurePoint = point;
    } else {
      int toGet = Random().nextInt(sectionLeft.length);
      current = sectionLeft[toGet];
      futurePoint = point + 1;
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
            questions: questions,
            current: current,
            part: futurePoint,
          );
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}
