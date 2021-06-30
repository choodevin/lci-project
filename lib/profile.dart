import 'package:LCI/custom-components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'entity/UserData.dart';
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
