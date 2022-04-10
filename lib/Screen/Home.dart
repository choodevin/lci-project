import 'package:flutter/cupertino.dart';

import 'Utility/BaseScreen.dart';

class Home extends StatefulWidget {
  @override
  StateHome createState() => StateHome();
}

class StateHome extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Text("Welcome")
    );
  }
}