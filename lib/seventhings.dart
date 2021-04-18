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
  List<bool> primarySevenThingsCheck = [false, false, false];
  List<bool> secondarySevenThingsCheck = [false, false, false, false];

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
                                    text: 'Add to Primary',
                                    color: Color(0xFFF48A1D),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Expanded(
                                  child: PrimaryButton(
                                    textColor: Colors.white,
                                    text: 'Add to Secondary',
                                    color: Color(0xFF6D330D),
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
                                    text: 'Add to Primary',
                                    color: Color(0xFFF48A1D),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Expanded(
                                  child: PrimaryButton(
                                    textColor: Colors.white,
                                    text: 'Add to Secondary',
                                    color: Color(0xFF6D330D),
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
                                    text: 'Add to Primary',
                                    color: Color(0xFFF48A1D),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Expanded(
                                  child: PrimaryButton(
                                    textColor: Colors.white,
                                    text: 'Add to Secondary',
                                    color: Color(0xFF6D330D),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(30)),
                      Text(
                        '3 Primary Things',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      PrimaryCard(
                        color: Color(0xFFF48A1D),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          primarySevenThingsCheck[0] = value;
                                        });
                                      },
                                      value: primarySevenThingsCheck[0],
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    'Wake up early',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SvgPicture.asset(
                                    'assets/menu.svg',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          primarySevenThingsCheck[1] = value;
                                        });
                                      },
                                      value: primarySevenThingsCheck[1],
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    'Exercise',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SvgPicture.asset(
                                    'assets/menu.svg',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          primarySevenThingsCheck[2] = value;
                                        });
                                      },
                                      value: primarySevenThingsCheck[2],
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    'Working',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SvgPicture.asset(
                                    'assets/menu.svg',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(30)),
                      Text(
                        '4 Secondary Things',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      PrimaryCard(
                        color: Color(0xFF6D330D),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          secondarySevenThingsCheck[0] = value;
                                        });
                                      },
                                      value: secondarySevenThingsCheck[0],
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    'Study',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SvgPicture.asset(
                                    'assets/menu.svg',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          secondarySevenThingsCheck[1] = value;
                                        });
                                      },
                                      value: secondarySevenThingsCheck[1],
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    'Reading',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SvgPicture.asset(
                                    'assets/menu.svg',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          secondarySevenThingsCheck[2] = value;
                                        });
                                      },
                                      value: secondarySevenThingsCheck[2],
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    'Practice Guitar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SvgPicture.asset(
                                    'assets/menu.svg',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          secondarySevenThingsCheck[3] = value;
                                        });
                                      },
                                      value: secondarySevenThingsCheck[3],
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    'Bring Ah Water for Walk',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: SvgPicture.asset(
                                    'assets/menu.svg',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ],
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
