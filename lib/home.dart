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
import 'package:spider_chart/spider_chart.dart';

import 'campaign.dart';
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
            child: RaisedButton(
              child: Text('sign out'),
              onPressed: () {
                signOut().then((value) => {
                      Navigator.pushReplacement(
                          build, MaterialPageRoute(builder: (build) => Login()))
                    });
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

  const Home({this.userdata});

  @override
  _HomeState createState() => _HomeState(userdata);
}

class _HomeState extends State<Home> {
  UserData userdata = UserData();

  var sevenThings = {
    'Wake up early': false,
    'Exercise': false,
    'Project': false,
    'Make Healthy Food': false,
    'Working': false,
    'Play Games': false,
    'Sleep': false,
  };

  _HomeState(this.userdata);

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(30, 35, 30, 25),
            child: Column(
              children: [
                PageHeadings(
                  text: 'Good Morning, ' + userdata.name,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          ClickablePrimaryCard(
                            onClickFunction: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WheelOfLife()));
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
                                    data: [3, 5, 7, 2, 6, 8, 9, 3, 5, 8],
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
                          userdata.subscription != "Premium"
                              ? Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Stack(
                        children: [
                          ClickablePrimaryCard(
                            padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                            onClickFunction: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GetSevenThings()));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextWithIcon(
                                  assetPath: 'assets/tasks.svg',
                                  text: 'Today\'s 7 Things',
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                                SevenThingsList(
                                  data: sevenThings,
                                  callBack: (index, value) {
                                    setState(() {
                                      sevenThings.update(
                                          sevenThings.entries.elementAt(index).key, (x) => value);
                                    });
                                  },
                                ),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Goals(userdata: userdata)));
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 13, bottom: 13),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF003989),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.3),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      padding:
                                          EdgeInsets.only(top: 13, bottom: 13),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFD9000D),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.3),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      padding:
                                          EdgeInsets.only(top: 13, bottom: 13),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF8C8B8B),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.3),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
    );
  }
}

class GetUserData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('UserData')
        .doc(FirebaseAuth.instance.currentUser.uid);

    return FutureBuilder<DocumentSnapshot>(
      future: userRef.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var userdata = UserData();
          userdata.name = snapshot.data.get('name');
          userdata.gender = snapshot.data.get('gender');
          userdata.country = snapshot.data.get('country');
          userdata.dateOfBirth = snapshot.data.get('dateOfBirth');
          userdata.type = snapshot.data.get('type');
          userdata.subscription = snapshot.data.get('subscription');

          return HomeBase(userdata: userdata);
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class HomeBase extends StatefulWidget {
  final UserData userdata;

  const HomeBase({this.userdata});

  _HomeBaseState createState() => _HomeBaseState(userdata: userdata);
}

class _HomeBaseState extends State<HomeBase> {
  UserData userdata;
  int index = 0;

  _HomeBaseState({this.userdata});

  void onTap(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = <Widget>[
      Home(userdata: userdata),
      CampaignNew(),
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
