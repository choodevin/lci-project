import 'package:LCI/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case "/" :
        return MaterialPageRoute(builder: (_) => LoggedInMain());
    }
  }
}