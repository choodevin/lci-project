import 'package:LCI/custom-components.dart';
import 'package:LCI/entity/LCIScore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radar_chart/radar_chart.dart';
import 'package:spider_chart/spider_chart.dart';

import 'entity/Video.dart';
import 'lci.dart';

class LoadWheelOfLife extends StatelessWidget {
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
          return WheelOfLife(scoreBundle: score);
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class WheelOfLife extends StatefulWidget {
  final scoreBundle;
  final getSpecific;

  const WheelOfLife({Key key, this.scoreBundle, this.getSpecific}) : super(key: key);

  _WheelOfLife createState() => _WheelOfLife(scoreBundle, getSpecific);
}

class _WheelOfLife extends State<WheelOfLife> {
  final scoreBundle;
  final getSpecific;

  bool isCurrentYear = false;
  bool isLastYear = false;
  bool isAverage = false;

  _WheelOfLife(this.scoreBundle, this.getSpecific);

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) async {
        if (!value.get('viewedWheelOfLife')) {
          infoVideo();
          await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({
            "viewedWheelOfLife": true,
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var score;
    if (getSpecific != null && getSpecific) {
      score = scoreBundle;
    } else {
      score = scoreBundle.docs.last.data();
    }
    LCIScore scoreObj = new LCIScore(score);
    var subScore = scoreObj.subScore();
    var colors = scoreObj.colors();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Wheel of Life',
                popAvailable: true,
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Center(child: Image.asset('assets/radar-bg.png', height: 260, width: 260,)),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: RadarChart(
                              initialAngle: 5,
                              length: 10,
                              radius: 100,
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
                                    subScore['Career or Study'] / 10 ,
                                    subScore['Finance'] / 10,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Padding(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: PrimaryCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Statistics',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Current Year',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: isCurrentYear,
                                  onChanged: (value) {
                                    setState(() {
                                      isCurrentYear = value;
                                      isLastYear = false;
                                      isAverage = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Last Year',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: isLastYear,
                                  onChanged: (value) {
                                    setState(() {
                                      isLastYear = value;
                                      isCurrentYear = false;
                                      isAverage = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Average',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: isAverage,
                                  onChanged: (value) {
                                    setState(() {
                                      isAverage = value;
                                      isCurrentYear = false;
                                      isLastYear = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Column(
                      children: subScore.keys.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                                  ),
                                  Text(
                                    subScore[e].toString(),
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                                  ),
                                ],
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
                    PrimaryButton(
                      text: "LCI Tests",
                      textColor: Colors.white,
                      color: Color(0xFFBC7AFE),
                      onClickFunction: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LCIMain()));
                      },
                    ),
                    Padding(padding: EdgeInsets.all(10)),
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
