import 'package:LCI/custom-components.dart';
import 'package:LCI/seventhings.dart';
import 'package:LCI/wheeloflife.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ntp/ntp.dart';
import 'package:spider_chart/spider_chart.dart';

import 'campaign.dart';
import 'entity/LCIScore.dart';
import 'entity/UserData.dart';
import 'goal.dart';
import 'login.dart';

class TabletHome extends StatelessWidget {
  Future<void> signOut() async {
    GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext build) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: ElevatedButton(
              child: Text('sign out'),
              onPressed: () {
                signOut().then((value) => {Navigator.pushReplacement(build, MaterialPageRoute(builder: (build) => Login()))});
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final UserData userdata;
  final wheelData;
  final sevenThings;

  const Home({this.userdata, this.wheelData, this.sevenThings});

  @override
  _HomeState createState() => _HomeState(userdata, wheelData, sevenThings);
}

class _HomeState extends State<Home> {
  UserData userdata = UserData();
  final wheelData;
  Map<String, dynamic> sevenThings;

  _HomeState(this.userdata, this.wheelData, this.sevenThings);

  CollectionReference user = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('SevenThings');

  DateTime toChange;

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
        toChange = DateTime(value.year, value.month, value.day);
      });
    });
  }

  Future<void> updateSevenThings() {
    return user.doc(toChange.toString()).set(sevenThings).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('There was an error inserting the item, please try again.'),
        )));
  }

  Widget build(BuildContext context) {
    var subScore;
    if (wheelData != null) {
      subScore = wheelData.subScore();
    }

    arrangeSevenThings() {
      Map<String, dynamic> primary = {};
      Map<String, dynamic> secondary = {};
      sevenThings.forEach((key, value) {
        if (value['type'] == 'Primary') {
          primary[key] = sevenThings[key];
        } else {
          secondary[key] = sevenThings[key];
        }
      });
      primary.addAll(secondary);
      setState(() {
        sevenThings = primary;
      });
    }

    if (sevenThings != null) {
      arrangeSevenThings();
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GetUserData()));
          return;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeadings(
                    text: 'Good Morning,\n' + userdata.name,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
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
                                        Center(
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
                            : PrimaryCard(),
                        Padding(padding: EdgeInsets.all(20)),
                        Stack(
                          children: [
                            ClickablePrimaryCard(
                              padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                              onClickFunction: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetSevenThings()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextWithIcon(
                                    assetPath: 'assets/tasks.svg',
                                    text: 'Today\'s 7 Things',
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  sevenThings != null && sevenThings.length > 0
                                      ? Column(
                                          children: sevenThings.keys.map((key) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  sevenThings[key]['status'] = !sevenThings[key]['status'];
                                                  updateSevenThings();
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child: Checkbox(
                                                            activeColor: Color(0xFFF48A1D),
                                                            checkColor: Colors.white,
                                                            value: sevenThings[key]['status'],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                sevenThings[key]['status'] = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Padding(padding: EdgeInsets.all(7.5)),
                                                        Text(
                                                          key,
                                                          style: TextStyle(fontSize: 17),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      : Text('No 7 Things assigned today.'),
                                ],
                              ),
                            ),
                          ],
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 13, bottom: 13),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF003989),
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.3),
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/heart.svg',
                                              height: 20,
                                              color: Colors.white,
                                            ),
                                            Padding(padding: EdgeInsets.all(3.5)),
                                            Text(
                                              'Health',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 22,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        padding: EdgeInsets.only(top: 13, bottom: 13),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD9000D),
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.3),
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/suitcase.svg',
                                              height: 20,
                                              color: Colors.white,
                                            ),
                                            Padding(padding: EdgeInsets.all(3.5)),
                                            Text(
                                              'Career',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 22,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        padding: EdgeInsets.only(top: 13, bottom: 13),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF8C8B8B),
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.3),
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/coins.svg',
                                              height: 20,
                                              color: Colors.white,
                                            ),
                                            Padding(padding: EdgeInsets.all(3.5)),
                                            Text(
                                              'Finance',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 22,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
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
  _GetUserDataState createState() => _GetUserDataState();
}

class _GetUserDataState extends State<GetUserData> {
  var toSearch;

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
        toSearch = DateTime(value.year, value.month, value.day);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference userRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid);
    DocumentReference sThingsRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('SevenThings').doc(toSearch.toString());
    Query wheelRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('LCIScore');

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([userRef.get(), sThingsRef.get(), wheelRef.get()]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var userdata = UserData();
          var wheeldata;
          var seventhings;
          if (snapshot.data[2].docs.length != 0) {
            wheeldata = LCIScore(snapshot.data[2].docs.last.data());
          }
          seventhings = snapshot.data[1].data();
          userdata.name = snapshot.data[0].get('name');
          userdata.gender = snapshot.data[0].get('gender');
          userdata.country = snapshot.data[0].get('country');
          userdata.dateOfBirth = snapshot.data[0].get('dateOfBirth');
          userdata.type = snapshot.data[0].get('type');
          userdata.subscription = snapshot.data[0].get('subscription');
          userdata.currentEnrolledCampaign = snapshot.data[0].get('currentEnrolledCampaign');

          return HomeBase(userdata: userdata, wheeldata: wheeldata, sevenThings: seventhings);
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class HomeBase extends StatefulWidget {
  final UserData userdata;
  final LCIScore wheeldata;
  final sevenThings;

  const HomeBase({this.userdata, this.wheeldata, this.sevenThings});

  _HomeBaseState createState() => _HomeBaseState(userdata, wheeldata, sevenThings);
}

class _HomeBaseState extends State<HomeBase> {
  UserData userdata;
  LCIScore wheeldata;
  var sevenThings;

  int index = 0;

  _HomeBaseState(this.userdata, this.wheeldata, this.sevenThings);

  void onTap(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = <Widget>[
      Home(userdata: userdata, wheelData: wheeldata, sevenThings: sevenThings),
      userdata.currentEnrolledCampaign.isNotEmpty ? LoadCampaign(userdata: userdata) : CampaignNew(),
      Text(
        'Profile',
      ),
    ];
    return Scaffold(
      body: screen.elementAt(index),
      bottomNavigationBar: Theme(
        data: ThemeData(
          brightness: Brightness.light,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/home.svg',
                  height: 24,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/home.svg',
                  height: 24,
                  color: Color(0xFF170E9A),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/users.svg',
                  height: 24,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/users.svg',
                  height: 24,
                  color: Color(0xFF170E9A),
                ),
                label: 'Campaign',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/user.svg',
                  height: 24,
                  color: Colors.black,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/user.svg',
                  height: 24,
                  color: Color(0xFF170E9A),
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: index,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
