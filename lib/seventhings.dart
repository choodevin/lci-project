import 'package:LCI/custom-components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SevenThings extends StatefulWidget {
  _SevenThingsState createState() => _SevenThingsState();
}

class _SevenThingsState extends State<SevenThings> {
  var sevenThings = {
    'Wake up early': false,
    'Exercise': false,
    'Project': false,
    'Make Healthy Food': false,
    'Working': false,
    'Play Games': false,
    'Sleep': false,
  };

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Map<String, int> getThisWeek() {
      int firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1)).day;
      Map<String, int> result = {
        'MON': firstDayOfWeek,
        'TUE': firstDayOfWeek + 1,
        'WED': firstDayOfWeek + 2,
        'THU': firstDayOfWeek + 3,
        'FRI': firstDayOfWeek + 4,
        'SAT': firstDayOfWeek + 5,
        'SUN': firstDayOfWeek + 6,
      };
      return result;
    }

    final Map<String, int> thisWeek = getThisWeek();
    var format = DateFormat('MMMM');
    String thisMonth = format.format(now);

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
                        text: thisMonth,
                      ),
                      Padding(padding: EdgeInsets.all(7.5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0; i < thisWeek.length; i++)
                            Container(
                              height: 45,
                              width: 45,
                              decoration: thisWeek.entries.elementAt(i).value ==
                                      now.day
                                  ? BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: Color(0xFF170E9A),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    thisWeek.entries.elementAt(i).key,
                                    style: TextStyle(
                                      color:
                                          thisWeek.entries.elementAt(i).value ==
                                                  now.day
                                              ? Colors.white
                                              : Color(0xFFAFAFAF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                      thisWeek.entries
                                          .elementAt(i)
                                          .value
                                          .toString(),
                                      style: TextStyle(
                                        color: thisWeek.entries
                                                    .elementAt(i)
                                                    .value ==
                                                now.day
                                            ? Colors.white
                                            : Color(0xFFAFAFAF),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Progress',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            '75%',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        value: 0.75,
                        color: Color(0xFF170E9A),
                      ),
                      Padding(padding: EdgeInsets.all(30)),
                      Text(
                        '7 Things Suggestions',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(7.5)),
                      PrimaryCard(
                        child: Column(
                          children: [
                            Text(
                              'Do exercise',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    textColor: Colors.white,
                                    text: 'Add',
                                    color: Color(0xFFF48A1D),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      PrimaryCard(
                        child: Column(
                          children: [
                            Text(
                              'Sleep early',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    textColor: Colors.white,
                                    text: 'Add',
                                    color: Color(0xFFF48A1D),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      PrimaryCard(
                        child: Column(
                          children: [
                            Text(
                              'Read a book',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    textColor: Colors.white,
                                    text: 'Add-',
                                    color: Color(0xFFF48A1D),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(30)),
                      Text(
                        'Your 7 Things',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      PrimaryCard(
                        child: Column(
                          children: sevenThings.keys.map((key) {
                            return CheckboxListTile(
                              value: sevenThings[key],
                              onChanged: (value) {
                                setState(() {
                                  sevenThings[key] = value;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
