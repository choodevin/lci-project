import 'package:flutter/material.dart';

import '../Screen/Landing.dart';
import '../Screen/_Utility/HomeContainer.dart';
import '../Screen/register/Register.dart';

class Routes {
  static const String LANDING = "/";
  static const String REGISTER = "register";
  static const String HOME = "home";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LANDING:
        return MaterialPageRoute(builder: (_) => Landing());
      case REGISTER:
        return MaterialPageRoute(builder: (_) => Register());
      case HOME:
        return MaterialPageRoute(builder: (_) => HomeContainer());
    }

    return null;
  }
}
