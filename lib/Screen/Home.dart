import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '_Utility/BaseScreen.dart';

class Home extends StatefulWidget {
  @override
  StateHome createState() => StateHome();
}

class StateHome extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    auth.signOut();
    return BaseScreen(
      child: Text("Welcome"),
    );
  }
}
