import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  Widget build(BuildContext build) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Text('SPLASH PAGE'),
          ),
        ),
      ),
    );
  }
}