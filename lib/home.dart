import 'package:LCI/custom-components.dart';
import 'package:LCI/entity/GoalsDetails.dart';
import 'package:LCI/entity/Video.dart';
import 'package:LCI/lci.dart';
import 'package:LCI/profile.dart';
import 'package:LCI/register.dart';
import 'package:LCI/seventhings.dart';
import 'package:LCI/wheeloflife.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radar_chart/radar_chart.dart';
import 'campaign.dart';
import 'entity/LCIScore.dart';
import 'entity/UserData.dart';
import 'goal.dart';

class Home extends StatefulWidget {
  final UserData userdata;
  final wheelData;
  final sevenThings;
  final goals;

  const Home({this.userdata, this.wheelData, this.sevenThings, this.goals});

  @override
  _HomeState createState() => _HomeState(userdata, wheelData, sevenThings, goals);
}

class _HomeState extends State<Home> {
  UserData userdata = UserData();
  final wheelData;
  Map<String, dynamic> sevenThings;
  Map<String, dynamic> goals;
  List<dynamic> contentOrder = [];

  _HomeState(this.userdata, this.wheelData, this.sevenThings, this.goals);

  CollectionReference user = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('SevenThings');

  DateTime toChange;

  @override
  void initState() {
    super.initState();
    toChange = getTime();

    if (sevenThings != null && sevenThings.containsKey('contentOrder')) {
      contentOrder = sevenThings['contentOrder'];
    } else {
      if (sevenThings == null) {
        sevenThings = {'content': {}, 'status': {}, 'contentOrder': {}};
        contentOrder = [];
      } else {
        var primaryCounter = 0;
        var secondaryCounter = 0;

        if(sevenThings['content'] == null) {
          sevenThings['content'] = {};
        }

        sevenThings['content'].forEach((k, v) {
          if (v['type'] == 'Primary') {
            contentOrder.add(k);
            primaryCounter++;
          }
        });
        if (primaryCounter < 3) {
          while (primaryCounter < 3) {
            contentOrder.add("");
            primaryCounter++;
          }
        }

        if(sevenThings['content'] != null) {
          sevenThings['content'].forEach((k, v) {
            if (v['type'] == 'Secondary') {
              contentOrder.add(k);
              secondaryCounter++;
            }
          });
        }

        if (secondaryCounter < 4) {
          while (secondaryCounter < 4) {
            contentOrder.add("");
            secondaryCounter++;
          }
        }
      }
    }
  }

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

  Widget build(BuildContext context) {
    var goalDetails = GoalsDetails();

    var subScore;
    if (wheelData != null) {
      subScore = wheelData.subScore();
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GetUserData()));
          return;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Container(
              padding: EdgeInsets.fromLTRB(32, 25, 32, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeadings(text: 'Home', padding: EdgeInsets.zero),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        wheelData != null
                            ? Stack(
                                children: [
                                  ClickablePrimaryCard(
                                    onClickFunction: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadWheelOfLife()));
                                    },
                                    padding: EdgeInsets.fromLTRB(30, 25, 30, 30),
                                    child: Column(
                                      children: [
                                        TextWithIcon(
                                          assetPath: 'assets/wheel_of_life.svg',
                                          text: 'Wheel of Life',
                                        ),
                                        Padding(padding: EdgeInsets.all(15)),
                                        Stack(
                                          children: [
                                            Center(
                                                child: Image.asset(
                                              'assets/radar-bg.png',
                                              height: 200,
                                              width: 200,
                                            )),
                                            Padding(
                                              padding: EdgeInsets.only(top: 24),
                                              child: Center(
                                                child: RadarChart(
                                                  initialAngle: 5,
                                                  length: 10,
                                                  radius: 76,
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
                                      ],
                                    ),
                                  ),
                                  userdata.subscription != "Premium"
                                      ? Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(0, 0, 0, 0.4),
                                              borderRadius: BorderRadius.all(Radius.circular(25)),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            : PrimaryCard(
                                padding: EdgeInsets.fromLTRB(30, 25, 30, 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextWithIcon(
                                      assetPath: 'assets/wheel_of_life.svg',
                                      text: 'Wheel of Life',
                                    ),
                                    Padding(padding: EdgeInsets.all(30)),
                                    Text(
                                      'Lets Get Started with taking LCI Test',
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(padding: EdgeInsets.all(30)),
                                    PrimaryButton(
                                      text: 'Take LCI Test',
                                      color: Color(0xFFBC7AFE),
                                      textColor: Colors.white,
                                      onClickFunction: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => Lci(
                                                  userdata: userdata,
                                                )));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                        Padding(padding: EdgeInsets.all(20)),
                        Stack(
                          children: [
                            ClickablePrimaryCard(
                              onClickFunction: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadGoals(userdata: userdata)));
                              },
                              padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                              child: Column(
                                children: [
                                  TextWithIcon(
                                    assetPath: 'assets/star.svg',
                                    text: 'Your Goals',
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  goals != null && goals.length != 0
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: goals.keys.map((key) {
                                            if (key != 'targetLCI') {
                                              if (goals[key]['selected']) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                                      decoration: BoxDecoration(
                                                        color: goalDetails.getColor(key),
                                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color.fromRGBO(0, 0, 0, 0.3),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                goalDetails.getAssetPath(key),
                                                                height: 18,
                                                                color: Colors.white,
                                                              ),
                                                              Padding(padding: EdgeInsets.all(3.5)),
                                                              Text(
                                                                key,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 18,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.all(6)),
                                                  ],
                                                );
                                              } else {
                                                return SizedBox.shrink();
                                              }
                                            } else {
                                              return SizedBox.shrink();
                                            }
                                          }).toList(),
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(padding: EdgeInsets.all(30)),
                                            Text(
                                              'Lets Get Started with taking LCI Test',
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(padding: EdgeInsets.all(30)),
                                            PrimaryButton(
                                              text: 'Set Goals',
                                              color: Color(0xFFFE7A7A),
                                              textColor: Colors.white,
                                              onClickFunction: () {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadGoals(userdata: userdata)));
                                              },
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            userdata.subscription != "Premium"
                                ? Positioned.fill(
                                    child: UnlockPremium(),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
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

class GetUserData extends StatefulWidget {
  final point;

  const GetUserData({Key key, this.point}) : super(key: key);

  _GetUserDataState createState() => _GetUserDataState(point);
}

class _GetUserDataState extends State<GetUserData> {
  final point;
  var toSearch;

  _GetUserDataState(this.point);

  @override
  void initState() {
    super.initState();
    toSearch = getTime();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference userRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid);
    DocumentReference sThingsRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('SevenThings').doc(toSearch.toString());
    Query wheelRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('LCIScore');
    CollectionReference goalsRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('Goals');

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([userRef.get(), sThingsRef.get(), wheelRef.get(), goalsRef.get()]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          DocumentSnapshot ud = snapshot.data[0];
          if (ud.exists) {
            var userdata = UserData();
            var wheelData;
            var sevenThings;
            var goals;
            if (snapshot.data[2].docs.length != 0) {
              wheelData = LCIScore(snapshot.data[2].docs.last.data());
            }
            if (snapshot.data[3].docs.length != 0) {
              goals = snapshot.data[3].docs.last.data();
            }
            if (snapshot.data[1].data() != null) {
              sevenThings = snapshot.data[1].data();
            }
            userdata.name = snapshot.data[0].get('name');
            userdata.gender = snapshot.data[0].get('gender');
            userdata.country = snapshot.data[0].get('country');
            userdata.dateOfBirth = snapshot.data[0].get('dateOfBirth');
            userdata.subscription = snapshot.data[0].get('subscription');
            Map<String, dynamic> udx = ud.data();
            if (udx.containsKey('currentEnrolledCampaign')) {
              userdata.currentEnrolledCampaign = snapshot.data[0].get('currentEnrolledCampaign');
            } else {
              userdata.currentEnrolledCampaign = "";
            }
            if (udx.containsKey('isCoach')) {
              userdata.isCoach = snapshot.data[0].get('isCoach');
            } else {
              userdata.isCoach = false;
            }
            userdata.email = FirebaseAuth.instance.currentUser.email;

            return HomeBase(userdata: userdata, wheeldata: wheelData, sevenThings: sevenThings, goals: goals, point: point);
          } else {
            var userdata = UserData();
            var sso = true;
            userdata.email = FirebaseAuth.instance.currentUser.email;
            return RegisterDetails(user: userdata, sso: sso);
          }
        }

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class HomeBase extends StatefulWidget {
  final UserData userdata;
  final LCIScore wheeldata;
  final sevenThings;
  final goals;
  final point;
  final isViewed;

  const HomeBase({this.userdata, this.wheeldata, this.sevenThings, this.goals, this.point, this.isViewed});

  _HomeBaseState createState() => _HomeBaseState(userdata, wheeldata, sevenThings, goals, point, isViewed);
}

class _HomeBaseState extends State<HomeBase> {
  final point;
  final isViewed;
  UserData userdata;
  LCIScore wheelData;
  var sevenThings;
  var goals;

  var campaignPage;

  int index = 0;

  FirebaseMessaging messaging;

  _HomeBaseState(this.userdata, this.wheelData, this.sevenThings, this.goals, this.point, this.isViewed);

  Future<void> updateToken(String token) async {
    FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({"token": token});
  }

  @override
  void initState() {
    super.initState();

    if(kIsWeb) {
      FirebaseMessaging.instance.getToken(vapidKey: "BB1Z1ItGirpcYo3x3tfy3vqsuGznPARNIuhjnN2sUEFmgCoNtwOzH1B1BnNT92-EvJ4i5SKiVfxdqjbOKMl9MSc").then((token) {
        updateToken(token);
      });
    } else {
      FirebaseMessaging.instance.getToken().then((token) {
        updateToken(token);
      });
    }

    campaignPage = userdata.currentEnrolledCampaign.isNotEmpty
        ? LoadCampaign(userdata: userdata)
        : CampaignNew(
            userdata: userdata,
          );
    if (point != null) {
      setState(() {
        index = point;
      });
    }
  }

  void onTap(int i) {
    setState(() {
      index = i;
    });
  }

  Future<bool> showConfirmExit() {
    return showDialog<bool>(
      context: context,
      builder: (c) {
        return PrimaryDialog(
          title: Text("Exit the app"),
          content: Text("Are you sure you want to exit?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Color(0xFFFF0000),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = <Widget>[
      Home(userdata: userdata, wheelData: wheelData, sevenThings: sevenThings, goals: goals),
      SevenThingsMain(),
      campaignPage,
      Profile(userdata: userdata),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          setState(() {
            index = 0;
          });
          return false;
        } else {
          return await showConfirmExit();
        }
      },
      child: Scaffold(
        body: screen.elementAt(index),
        bottomNavigationBar: Theme(
          data: ThemeData(
            brightness: Brightness.light,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black,
            selectedItemColor: Color(0xFF170E9A),
            unselectedLabelStyle: TextStyle(fontSize: 11),
            selectedLabelStyle: TextStyle(fontSize: 11),
            selectedIconTheme: IconThemeData(
              color: Color(0xFF170E9A),
            ),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            currentIndex: index,
            onTap: onTap,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 2),
                  child: SvgPicture.asset(
                    'assets/home.svg',
                    height: 24,
                    color: index == 0 ? Color(0xFF170E9A) : Colors.black,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 2),
                  child: SvgPicture.asset(
                    'assets/tasks.svg',
                    height: 24,
                    color: index == 1 ? Color(0xFF170E9A) : Colors.black,
                  ),
                ),
                label: '7 Things',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 2),
                  child: SvgPicture.asset(
                    'assets/users.svg',
                    height: 24,
                    color: index == 2 ? Color(0xFF170E9A) : Colors.black,
                  ),
                ),
                label: 'Campaign',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 2),
                  child: SvgPicture.asset(
                    'assets/user.svg',
                    height: 22,
                    color: index == 3 ? Color(0xFF170E9A) : Colors.black,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
