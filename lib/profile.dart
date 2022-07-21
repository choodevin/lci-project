import 'package:LCI/custom-components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'coach.dart';
import 'entity/UserData.dart';
import 'entity/Video.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  final userdata;

  const Profile({Key key, this.userdata}) : super(key: key);

  _ProfileState createState() => _ProfileState(userdata);
}

class _ProfileState extends State<Profile> {
  final UserData userData;

  _ProfileState(this.userData);

  var version = "";

  @override
  void initState() {
    super.initState();
    getPackageName().then((value) {
      setState(() {
        version = value;
      });
    });
  }

  Future<String> getPackageName() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<bool> showConfirmLogout() {
    return showDialog<bool>(
      context: context,
      builder: (c) {
        return PrimaryDialog(
          title: Text("Signing out"),
          content: Text("Are you sure you want to sign out?"),
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 72,
            ),
            padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageHeadings(
                      text: 'Your Profile',
                      padding: EdgeInsets.zero,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    PrimaryCard(
                      child: Column(
                        children: [
                          TextWithIcon(
                            text: 'Basic Information',
                            assetPath: 'assets/user.svg',
                          ),
                          Padding(padding: EdgeInsets.all(12)),
                          Information(
                            label: 'Name',
                            text: userData.name,
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Information(
                            label: 'Email',
                            text: userData.email,
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Information(
                            label: 'Gender',
                            text: userData.gender,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    PrimaryButton(
                      text: 'Tutorial & References',
                      color: Color(0xFF170E9A),
                      textColor: Colors.white,
                      onClickFunction: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Tutorial()));
                      },
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    userData.isCoach
                        ? PrimaryButton(
                            text: 'Coach Screen',
                            color: Color(0xFF170E9A),
                            textColor: Colors.white,
                            onClickFunction: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoachMain()));
                            },
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      text: 'Sign Out',
                      color: Colors.red,
                      textColor: Colors.white,
                      onClickFunction: () async {
                        await showConfirmLogout().then((value) {
                          if (value) {
                            showLoading(context);
                            FirebaseFirestore.instance.collection("UserData").doc(FirebaseAuth.instance.currentUser.uid).update({"token": ""}).whenComplete(() {
                              FirebaseAuth.instance.signOut().whenComplete(() {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
                              });
                            });
                          }
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Text(
                      'Version : v' + version + "(alpha)",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFA7A7A7), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: "Tutorials",
                metaText: "Video tutorials and references can be found here.",
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Life Compass Inventory - LCI',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Text(
                            'Life Compass Inventory (LCI) is a tools that quantify 10 areas in your life, and therefore able to visually understand your current life’s condition. It is an inventory that helps individual to explore and aware of different areas in life in a deeper level, by transforming the result to a readable quantification. It gives a deeper understanding to each areas of life.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          VideoPlayer(url: Video.VIDEO_1),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Goal Settings',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Text(
                            'Goal setting is not something new to many people. However, we want to let you know that, there are 3 levels of goal when come to Goal Setting.\n\nLevel 1: Presenting Goal – Presenting Goal is a goal that focus on only outcome where it is often measurable or able to visually identify the differences. E.g. I want to have 6 packs.\n\nLevel 2: Performance Goal – Performance Goal is a goal that focus on process that usually help individuals to achieve presenting goal. E.g. I will do 50 push up and 100 sit-up every day.\n\nLevel3: Identity Goal – Identity Goal is a goal that focus on who you truly want to be, instead of just focus around the external factors. Identity Goal often provide a long lasting momentum compare to other 2 types of goal. Usually it the core, and once you achieve it, the other 2 will follow. E.g. I am a person who loves exercise.\n\nPeople often set goal but unable to follow through the process, or setback immediately after achieving their goal. That is before whatever Presenting & Performance Goal they set, are not consistent with their identity. Besides that, the real challenge is not how much you want the result, but if how willing you are to accept the sacrifices required to achieve your goal. That can usually be overcome by exploring on the Identity Goal.\n',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          VideoPlayer(url: Video.VIDEO_1),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Campaign',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Text(
                            'Campaign is an accountability event where you and your mates come together and support each other. In a campaign, you can set your own duration, goals, and reward & punishment system with everyone’s agreement, and every participants will be accountable and support for each other. You will witness the growth together, and encourage each other to move further. It is not about the speed, but consistency.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          VideoPlayer(url: Video.VIDEO_1),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wheel of Life',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Text(
                            'Wheel of life is a tool that consists of 10 areas of individual’s life, where it helps individual to have an overall picture on life’s situation. With Wheel of Life, an individual can have a better understand and clearer direction on how to achieve fullness in life.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          VideoPlayer(url: Video.VIDEO_1),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '7 Things',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Text(
                            '7 things is a simple yet powerful tool for time management. In 7 things, you need to set your 7 daily items that you want to achieve with following guidelines:\n- The first item should be your core of the day, where it is usually take up most of your time and energy of the day.\n- The 2nd and 3rd items are something important that you want to achieve on that day, yet it doesn’t take as much time & energy as per 1st item.\n- The 4th to 7th items are something else that you need or want to do on that day, but less important compare to first three items.\n- Whenever you set your 7 things, it is important to always keep in mind that the items that you set should be align with your identity goals.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          VideoPlayer(url: Video.VIDEO_1),
                        ],
                      ),
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
