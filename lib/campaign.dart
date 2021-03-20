import 'package:LCI/custom-components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'entity/CampaignData.dart';

class CampaignNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 35, 30, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeadings(
                text: 'Campaign',
                metaText: 'Haven\'t join any Campaign yet?',
              ),
              Padding(padding: EdgeInsets.all(25)),
              PrimaryButton(
                text: 'Create New Campaign',
                color: Color(0xFF299E45),
                textColor: Colors.white,
                onClickFunction: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SetupCampaign()));
                },
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text(
                'OR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6E6E6E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(padding: EdgeInsets.all(20)),
              PrimaryButton(
                text: 'Join Campaign',
                color: Color(0xFF170E9A),
                textColor: Colors.white,
                onClickFunction: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupCampaign extends StatefulWidget {
  _SetupCampaignState createState() => _SetupCampaignState();
}

class _SetupCampaignState extends State<SetupCampaign> {
  final CampaignData campaignData = CampaignData();
  String selectedDeadline = "0:00";
  String goalSettingLabel = "On Member";
  bool goalSettingDecision = true;
  bool penaltyDecision = false;
  int selectedMonth = 1;

  @override
  Widget build(BuildContext context) {
    List<int> monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    List<String> generateTimes() {
      List<String> list = <String>[];
      for (var i = 0; i < 24; i++) {
        list.add(i.toString() + ':00');
      }
      return list;
    }

    List<String> timeList = generateTimes();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 35, 30, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Setting up New Campaign',
                ),
                Padding(padding: EdgeInsets.all(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duration of the campaign',
                      style: TextStyle(
                        color: Color(0xFF6E6E6E),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: Colors.white,
                                isExpanded: true,
                                style: TextStyle(
                                  color: Color(0xFF6E6E6E),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                                value: selectedMonth,
                                items: monthList
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Center(
                                      child: Text(
                                        value.toString(),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (int newValue) {
                                  setState(
                                    () {
                                      selectedMonth = newValue;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Text(
                          'months',
                          style: TextStyle(
                            color: Color(0xFF6E6E6E),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(12)),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(padding: EdgeInsets.all(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Goal Setting Decision',
                      style: TextStyle(
                        color: Color(0xFF6E6E6E),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          goalSettingLabel,
                          style: TextStyle(
                            color: goalSettingDecision
                                ? Color(0xFF36C164)
                                : Color(0xFF999999),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        CupertinoSwitch(
                          activeColor: Color(0xFF36C164),
                          value: goalSettingDecision,
                          onChanged: (value) {
                            setState(() {
                              goalSettingDecision = value;
                              if (goalSettingDecision) {
                                goalSettingLabel = "On Member";
                              } else {
                                goalSettingLabel = "On Campaign";
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(12)),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(padding: EdgeInsets.all(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '7 Things Deadline',
                      style: TextStyle(
                        color: Color(0xFF6E6E6E),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            style: TextStyle(
                              color: Color(0xFF6E6E6E),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            value: selectedDeadline,
                            items: timeList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: Text(
                                    value,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(
                                () {
                                  selectedDeadline = newValue;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(12)),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(padding: EdgeInsets.all(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '7 Things Penalty (On/Off)',
                      style: TextStyle(
                        color: Color(0xFF6E6E6E),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoSwitch(
                      activeColor: Color(0xFF36C164),
                      value: penaltyDecision,
                      onChanged: (value) {
                        setState(() {
                          penaltyDecision = value;
                        });
                      },
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(12)),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(padding: EdgeInsets.all(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '7 Things Penalty',
                      style: TextStyle(
                        color: penaltyDecision
                            ? Color(0xFF6E6E6E)
                            : Color(0xFFAAAAAA),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            style: TextStyle(
                              color: Color(0xFF6E6E6E),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            value: selectedDeadline,
                            items: timeList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: Text(
                                    value,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(
                                () {
                                  selectedDeadline = newValue;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(12)),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(padding: EdgeInsets.all(20)),
                PrimaryButton(
                  textColor: Colors.white,
                  text: 'Next',
                  color: Color(0xFF299E45),
                  onClickFunction: () {
                    campaignData.duration = selectedMonth;
                    campaignData.goalDecision =
                        goalSettingDecision ? "On Member" : "On Campaign";
                    campaignData.sevenThingsDeadline = selectedDeadline;
                    campaignData.sevenThingsPenaltyDecision = penaltyDecision;
                    if (penaltyDecision) {
                      //PENALTY ON > PENALTY REQUIRED
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SetupCampaignRules(campaignData: campaignData)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SetupCampaignRules extends StatefulWidget {
  final CampaignData campaignData;

  const SetupCampaignRules({this.campaignData});

  _SetupCampaignRulesState createState() =>
      _SetupCampaignRulesState(campaignData);
}

class _SetupCampaignRulesState extends State<SetupCampaignRules> {
  final CampaignData campaignData;

  _SetupCampaignRulesState(this.campaignData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 35, 30, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Setting up New Campaign',
                ),
                Padding(padding: EdgeInsets.all(15)),
                Text(
                  'Any other rules for the campaign',
                  style: TextStyle(
                    color: Color(0xFF6E6E6E),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                PrimaryCard(),
                PrimaryButton(
                  textColor: Colors.white,
                  text: 'Next',
                  color: Color(0xFF299E45),
                  onClickFunction: () async {
                    campaignData.campaignAdmin =
                        FirebaseAuth.instance.currentUser.uid;
                    DocumentReference campaignRef = FirebaseFirestore.instance
                        .collection('CampaignData')
                        .doc();
                    await campaignRef.set({
                      'duration': campaignData.duration,
                      'startDate': Timestamp.now(),
                      'goalDecision': campaignData.goalDecision,
                      'sevenThingDeadline': campaignData.sevenThingsDeadline,
                      'sevenThingsPenaltyDecision':
                          campaignData.sevenThingsPenaltyDecision,
                      'sevenThingsPenalties': campaignData.sevenThingsPenalty,
                      'campaignAdmin': campaignData.campaignAdmin
                    }).whenComplete(() {
                      campaignData.invitationCode = campaignRef.id;
                    });
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            SetupCampaignFinal(campaignData: campaignData)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SetupCampaignFinal extends StatelessWidget {
  final CampaignData campaignData;

  const SetupCampaignFinal({Key key, this.campaignData}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 35, 30, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Final Step!',
                ),
                Padding(padding: EdgeInsets.all(15)),
                Text(
                  'Share it out to your peers to join this campaign!',
                  style: TextStyle(
                    color: Color(0xFF6E6E6E),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 5, // Space between underline and text
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFAAAAAA),
                        width: 1.0, // Underline thickness
                      ),
                    ),
                  ),
                  child: Text(
                    campaignData.invitationCode,
                    style: TextStyle(
                      color: Color(0xFF6E6E6E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
                PrimaryButton(
                  textColor: Colors.white,
                  text: 'Finish',
                  color: Color(0xFF170E9A),
                  onClickFunction: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CampaignMain()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CampaignMain extends StatelessWidget {
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
                    'Campaign',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 35, 30, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryCard(
                        child: Column(
                          children: [
                            TextWithIcon(
                              assetPath: 'assets/medal.svg',
                              text: '7 Things Ranking Board',
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'John',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
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
                                    'Leela',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
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
                                    'Jason',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
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
                                    'Ah Beng',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
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
                                    'Ah Kaw',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  RoundedLinearProgress(
                                    color: Color(0xFF6EC8F4),
                                    value: 0.6,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
