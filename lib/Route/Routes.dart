import 'package:flutter/material.dart';

import '../Screen/Home.dart';
import '../Screen/Landing.dart';
import '../Screen/Register.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Landing());
      case "register":
        return MaterialPageRoute(builder: (_) => Register());
      case "home":
        return MaterialPageRoute(builder: (_) => Home());
    }

    return null;
  }
}
