import 'package:LCI/custom-components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spider_chart/spider_chart.dart';

class WheelOfLife extends StatefulWidget {
  _WheelOfLife createState() => _WheelOfLife();
}

class _WheelOfLife extends State<WheelOfLife> {
  bool isCurrentYear = false;
  bool isLastYear = false;
  bool isAverage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(35, 35, 35, 10),
            child: Column(
              children: [
                TextWithIcon(
                  text: 'Wheel of Life',
                  assetPath: 'assets/wheel_of_life.svg',
                  assetHeight: 32,
                  assetColor: Color(0xFF170E9A),
                  textStyle: TextStyle(
                      color: Color(0xFF170E9A),
                      fontSize: 28,
                      fontWeight: FontWeight.w900),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  height: 300,
                  child: SpiderChart(
                    data: [3, 5, 7, 2, 6, 8, 9, 3, 5, 8],
                    maxValue: 10,
                    colors: [
                      Color(0xFF8C8B8B),
                      Color(0xFF7C0E6F),
                      Color(0xFF6EC8F4),
                      Color(0xFFC4CF54),
                      Color(0xFFE671A8),
                      Color(0xFF003989),
                      Color(0xFFF27C00),
                      Color(0xFFFFE800),
                      Color(0xFF00862F),
                      Color(0xFFD9000D),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: PrimaryCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Statistics',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Year',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            CupertinoSwitch(
                              value: isCurrentYear,
                              onChanged: (value) {
                                setState(() {
                                  isCurrentYear = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Last Year',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            CupertinoSwitch(
                              value: isLastYear,
                              onChanged: (value) {
                                setState(() {
                                  isLastYear = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Average',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            CupertinoSwitch(
                              value: isAverage,
                              onChanged: (value) {
                                setState(() {
                                  isAverage = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Health',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFF170E9A),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Spiritual',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFF6EC8F4),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Career',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFFC4CF54),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Self Development',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFFE671A8),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Family',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFFF27C00),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Social',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFFFFE800),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Hobby',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFF00862F),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Finance',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFF170E9A),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Environment',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFF170E9A),
                        value: 0.6,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Romance',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RoundedLinearProgress(
                        color: Color(0xFF170E9A),
                        value: 0.6,
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
