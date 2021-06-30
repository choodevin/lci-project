import 'package:LCI/custom-components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: Column(
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
                PrimaryButton(
                  text: 'Sign Out',
                  color: Colors.red,
                  textColor: Colors.white,
                  onClickFunction: () {
                    FirebaseAuth.instance.signOut().whenComplete(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login())));
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
                            'It is good that you are here! This is a right place if you are looking for changes and growth! Please let our coach to assist you, and develop a plan for you.',
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
                            'It is good that you are here! This is a right place if you are looking for changes and growth! Please let our coach to assist you, and develop a plan for you.',
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
                            'It is good that you are here! This is a right place if you are looking for changes and growth! Please let our coach to assist you, and develop a plan for you.',
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
                            'It is good that you are here! This is a right place if you are looking for changes and growth! Please let our coach to assist you, and develop a plan for you.',
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
