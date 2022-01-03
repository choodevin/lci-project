import 'package:LCI/notification/NotificationListener.dart';
import 'package:LCI/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Model/Campaign.dart';
import 'Screen/SplashScreen.dart';
import 'home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BuildApp2());
}

class BuildApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          FirebaseMessaging.onBackgroundMessage(notificationReceiver);
          if(FirebaseAuth.instance.currentUser != null) {
            return LoggedInMain();
          } else {
            return NonLoggedInMain();
          }
        }

        return SplashScreen();
      },
    );
  }

}

class LoggedInMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Campaign>(create: (c) => Campaign()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: NoGlowScroll(),
            child: child,
          );
        },
        home: GetUserData(),
      ),
    );
  }
}

class NonLoggedInMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowScroll(),
          child: child,
        );
      },
      home: Login(),
    );
  }
}

class BuildApp2 extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          initNotifications();
          FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
          FirebaseMessaging.onBackgroundMessage(notificationReceiver);
          if (FirebaseAuth.instance.currentUser != null) {
            return LoggedInMain();
          } else {
            return NonLoggedInMain();
          }
        }

        return SplashScreen();
      },
    );
  }
}

class NoGlowScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
