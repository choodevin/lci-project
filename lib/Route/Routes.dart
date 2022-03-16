import 'package:LCI/main.dart';
import 'package:flutter/material.dart';

import '../Screen/Login.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case "/" :
        return MaterialPageRoute(builder: (_) => Login());
      case "home" :
        //return MaterialPageRoute(builder: (_) => Home());
    }

    return null;
  }
}