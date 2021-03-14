import 'package:LCI/custom-components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SevenThings extends StatefulWidget {
  _SevenThingsState createState() => _SevenThingsState();
}

class _SevenThingsState extends State<SevenThings> {
  Map<int, String> thisWeek;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF170E9A),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFAFAFA),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ));
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  color: Color(0xFF170E9A),
                  child: Text(
                    '7 Things',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'TODAY',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF878787),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(7.5)),
                      TextWithIcon(
                        assetPath: 'assets/calendar.svg',
                        text: 'February',
                      ),
                      Padding(padding: EdgeInsets.all(7.5)),
                      Row(

                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
