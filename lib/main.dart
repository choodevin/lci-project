import 'package:LCI/Screen/Landing.dart';
import 'package:LCI/Screen/_Utility/HomeContainer.dart';
import 'package:LCI/Screen/_Utility/PrimaryLoading.dart';
import 'package:LCI/notification/NotificationListener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'Route/Routes.dart';
import 'Screen/_Utility/BaseTheme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BuildApp());
}

class BuildApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        bool isLoggedIn = false;
        if (snapshot.connectionState == ConnectionState.done) {
          initNotifications();
          FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
          FirebaseMessaging.onBackgroundMessage(notificationReceiver);

          if (FirebaseAuth.instance.currentUser != null) {
            isLoggedIn = true;
          }

          return MaterialApp(
            theme: BaseTheme.defaultTheme,
            onGenerateRoute: Routes.generateRoute,
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: NoGlowScroll(),
                child: child!,
              );
            },
            home: isLoggedIn ? HomeContainer() : Landing(),
          );
        }

        return Center(child: PrimaryLoading());
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