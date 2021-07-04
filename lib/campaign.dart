import 'dart:convert';
import 'dart:math';

import 'package:LCI/custom-components.dart';
import 'package:LCI/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'entity/CampaignData.dart';
import 'entity/GoalsDetails.dart';
import 'entity/LCIScore.dart';
import 'entity/UserData.dart';
import 'entity/Video.dart';
import 'package:http/http.dart' as http;
import 'goal.dart';

class LoadCampaign extends StatelessWidget {
  final userdata;

  const LoadCampaign({Key key, this.userdata}) : super(key: key);

  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance.collection('CampaignData').where('invitationCode', isEqualTo: userdata.currentEnrolledCampaign);

    return FutureBuilder<QuerySnapshot>(
      future: ref.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var campaign = CampaignData();
          campaign.name = snapshot.data.docs.last.get('name');
          campaign.campaignAdmin = snapshot.data.docs.last.get('campaignAdmin');
          campaign.duration = snapshot.data.docs.last.get('duration');
          campaign.goalDecision = snapshot.data.docs.last.get('goalDecision');
          campaign.invitationCode = snapshot.data.docs.last.get('invitationCode');
          campaign.rules = snapshot.data.docs.last.get('rules');
          campaign.selectedGoalReview = snapshot.data.docs.last.get('selectedGoalReview');
          campaign.sevenThingsDeadline = snapshot.data.docs.last.get('sevenThingDeadline');
          campaign.sevenThingsPenaltyDecision = snapshot.data.docs.last.get('sevenThingsPenaltyDecision');
          campaign.sevenThingsPenalty = snapshot.data.docs.last.get('sevenThingsPenalties');
          campaign.startDate = snapshot.data.docs.last.get('startDate');
          campaign.campaignModerator = snapshot.data.docs.last.get('campaignModerator');
          return CampaignMain(campaign: campaign, userdata: userdata, campaignId: snapshot.data.docs.last.id);
        }

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class CampaignNew extends StatelessWidget {
  final userdata;

  const CampaignNew({Key key, this.userdata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeadings(
                text: 'Campaign',
                metaText: 'Haven\'t join any Campaign yet?',
                padding: EdgeInsets.zero,
              ),
              Padding(padding: EdgeInsets.all(25)),
              PrimaryButton(
                text: 'Create New Campaign',
                color: Color(0xFF299E45),
                textColor: Colors.white,
                onClickFunction: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SetupCampaign(
                            userdata: userdata,
                          )));
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
                onClickFunction: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => JoinCampaign()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JoinCampaign extends StatefulWidget {
  final userdata;

  const JoinCampaign({Key key, this.userdata}) : super(key: key);

  _JoinCampaignState createState() => _JoinCampaignState(userdata);
}

class _JoinCampaignState extends State<JoinCampaign> {
  UserData userdata;

  FocusNode _campaignCodeNode;
  var _campaignCodeController = new TextEditingController();
  var loading = false;

  _JoinCampaignState(this.userdata);

  @override
  void initState() {
    super.initState();
    _campaignCodeNode = new FocusNode();
    _campaignCodeNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: !loading
              ? Column(
                  children: [
                    PageHeadings(
                      text: 'Enter Campaign Code',
                      popAvailable: true,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InputBox(
                            focusNode: _campaignCodeNode,
                            controller: _campaignCodeController,
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          PrimaryButton(
                            color: Color(0xFF170E9A),
                            textColor: Colors.white,
                            text: 'Join',
                            onClickFunction: () async {
                              if (_campaignCodeController.text.isNotEmpty) {
                                setState(() {
                                  loading = true;
                                });

                                var message = await joinCampaign();

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

                                setState(() {
                                  loading = false;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a campaign code.')));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<String> joinCampaign() async {
    return await FirebaseFirestore.instance.collection('CampaignData').where('invitationCode', isEqualTo: _campaignCodeController.text).get().then((value) async {
      if (value == null || value.size == 0) {
        return 'No campaign found';
      } else {
        await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({'currentEnrolledCampaign': _campaignCodeController.text});
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GetUserData(point: 1)));
        return "Campaign found and enrolled";
      }
    });
  }
}

class SetupCampaign extends StatefulWidget {
  final userdata;

  const SetupCampaign({Key key, this.userdata}) : super(key: key);

  _SetupCampaignState createState() => _SetupCampaignState(userdata);
}

class _SetupCampaignState extends State<SetupCampaign> {
  final CampaignData campaignData = CampaignData();
  final _scorePenaltyController = new TextEditingController();
  final _campaignNameController = new TextEditingController();
  final userdata;

  String selectedDeadline = "0:00";
  String goalSettingLabel = "On Member";
  bool goalSettingDecision = true;
  bool penaltyDecision = false;
  int selectedMonth = 1;
  int selectedGoalReview = 1;
  FocusNode _scorePenaltyNode;
  FocusNode _campaignNameNode;

  _SetupCampaignState(this.userdata);

  @override
  void initState() {
    super.initState();
    _scorePenaltyNode = new FocusNode();
    _scorePenaltyNode.addListener(() {
      setState(() {});
    });
    _campaignNameNode = new FocusNode();
    _campaignNameNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    List<int> generateDay() {
      List<int> list = <int>[];
      for (var i = 1; i <= 31; i++) {
        list.add(i);
      }
      return list;
    }

    List<String> generateTimes() {
      List<String> list = <String>[];
      for (var i = 0; i < 24; i++) {
        list.add(i.toString() + ':00');
      }
      return list;
    }

    List<String> timeList = generateTimes();
    List<int> dayList = generateDay();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Setup a new Campaign',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      'Campaign Name',
                      style: TextStyle(
                        color: Color(0xFF6E6E6E),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    InputBox(
                      focusNode: _campaignNameNode,
                      controller: _campaignNameController,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
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
                                    items: monthList.map<DropdownMenuItem<int>>((int value) {
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
                    Padding(padding: EdgeInsets.all(10)),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
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
                                color: goalSettingDecision ? Color(0xFF36C164) : Color(0xFF999999),
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
                    Padding(padding: EdgeInsets.all(10)),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
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
                                items: timeList.map<DropdownMenuItem<String>>((String value) {
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
                    Padding(padding: EdgeInsets.all(10)),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
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
                    Padding(padding: EdgeInsets.all(10)),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '7 Things Score Penalty %',
                          style: TextStyle(
                            color: penaltyDecision ? Color(0xFF6E6E6E) : Color(0xFFAAAAAA),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 90,
                          child: InputBox(
                            focusNode: _scorePenaltyNode,
                            controller: _scorePenaltyController,
                            textAlign: TextAlign.center,
                            readOnly: !penaltyDecision,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Goal Settings Review Day',
                          style: TextStyle(
                            color: Color(0xFF6E6E6E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 65,
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
                                  fontSize: 14,
                                ),
                                value: selectedGoalReview,
                                items: dayList.map<DropdownMenuItem<int>>((int value) {
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
                                      selectedGoalReview = newValue;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'of each month',
                          style: TextStyle(
                            color: Color(0xFF6E6E6E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(10)),
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
                        if (_campaignNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Do not leave campaign name blank')));
                          return;
                        }
                        campaignData.name = _campaignNameController.text;
                        campaignData.duration = selectedMonth;
                        campaignData.goalDecision = goalSettingDecision ? "On Member" : "On Campaign";
                        campaignData.sevenThingsDeadline = selectedDeadline;
                        campaignData.sevenThingsPenaltyDecision = penaltyDecision;
                        campaignData.selectedGoalReview = selectedGoalReview;
                        if (penaltyDecision) {
                          campaignData.sevenThingsPenalty = _scorePenaltyController.text;
                          if (int.tryParse(campaignData.sevenThingsPenalty) != null) {
                            var tempPenalty = int.parse(campaignData.sevenThingsPenalty);
                            if (tempPenalty > 0 && tempPenalty <= 100) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaignRules(campaignData: campaignData, userdata: userdata)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('7 Things penalty entered must be within 0-100')));
                              return;
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid 7 things penalty input')));
                            return;
                          }
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaignRules(campaignData: campaignData, userdata: userdata)));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupCampaignRules extends StatefulWidget {
  final CampaignData campaignData;
  final userdata;

  const SetupCampaignRules({this.campaignData, this.userdata});

  _SetupCampaignRulesState createState() => _SetupCampaignRulesState(campaignData, userdata);
}

class _SetupCampaignRulesState extends State<SetupCampaignRules> {
  final CampaignData campaignData;
  final userdata;
  final _rulesController = new TextEditingController();

  _SetupCampaignRulesState(this.campaignData, this.userdata);

  FocusNode _rulesNode;

  Future<String> generateInvitationCode() async {
    var code;
    var duplicate = true;
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    code = String.fromCharCodes(Iterable.generate(5, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    while (duplicate) {
      await FirebaseFirestore.instance.collection('CampaignData').where('invitationCode', isEqualTo: code).get().then((value) {
        if (value == null || value.size == 0) {
          duplicate = false;
        }
      });
    }
    return code;
  }

  @override
  void initState() {
    super.initState();
    _rulesNode = new FocusNode();
    _rulesNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Setup a new Campaign',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Any other rules for the campaign',
                      style: TextStyle(
                        color: Color(0xFF6E6E6E),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    InputBox(
                      focusNode: _rulesNode,
                      controller: _rulesController,
                      minLines: 10,
                      maxLines: 10,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    Padding(padding: EdgeInsets.all(40)),
                    PrimaryButton(
                      textColor: Colors.white,
                      text: 'Next',
                      color: Color(0xFF299E45),
                      onClickFunction: () async {
                        campaignData.campaignAdmin = FirebaseAuth.instance.currentUser.uid;
                        DocumentReference campaignRef = FirebaseFirestore.instance.collection('CampaignData').doc();
                        campaignData.invitationCode = await generateInvitationCode();
                        campaignData.rules = _rulesController.text;
                        await campaignRef.set({
                          'name': campaignData.name,
                          'duration': campaignData.duration,
                          'startDate': Timestamp.now(),
                          'goalDecision': campaignData.goalDecision,
                          'sevenThingDeadline': campaignData.sevenThingsDeadline,
                          'sevenThingsPenaltyDecision': campaignData.sevenThingsPenaltyDecision,
                          'sevenThingsPenalties': campaignData.sevenThingsPenalty,
                          'campaignAdmin': campaignData.campaignAdmin,
                          'invitationCode': campaignData.invitationCode,
                          'selectedGoalReview': campaignData.selectedGoalReview,
                          'rules': campaignData.rules,
                          'campaignModerator': [],
                        });
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaignFinal(campaignData: campaignData, userdata: userdata)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupCampaignFinal extends StatelessWidget {
  final CampaignData campaignData;
  final UserData userdata;

  const SetupCampaignFinal({Key key, this.campaignData, this.userdata}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
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
                  onClickFunction: () async {
                    await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({
                      "currentEnrolledCampaign": campaignData.invitationCode,
                    });
                    userdata.currentEnrolledCampaign = campaignData.invitationCode;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadCampaign(userdata: userdata)));
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

class CampaignMain extends StatefulWidget {
  final campaign;
  final userdata;
  final campaignId;

  const CampaignMain({Key key, this.campaign, this.userdata, this.campaignId}) : super(key: key);

  _CampaignMainState createState() => _CampaignMainState(campaign, userdata, campaignId);
}

class _CampaignMainState extends State<CampaignMain> {
  CampaignData campaign;
  final campaignId;
  UserData userdata;

  _CampaignMainState(this.campaign, this.userdata, this.campaignId);

  DocumentSnapshot selectedUser;

  Future<void> infoVideo() {
    return showDialog<void>(
      context: context,
      builder: (c) {
        return PopupPlayer(
          url: Video.VIDEO_1,
        );
      },
    );
  }

  var userRef;
  var nameRef;

  @override
  void initState() {
    super.initState();

    userRef = FirebaseFirestore.instance.collection('CampaignData').doc(campaignId).collection('Rankings');
    nameRef = FirebaseFirestore.instance.collection('UserData').where('currentEnrolledCampaign', isEqualTo: campaign.invitationCode);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) async {
        if (!value.get('viewedCampaign')) {
          infoVideo();
          await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({
            "viewedCampaign": true,
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageHeadings(
                      text: 'Campaign',
                      padding: EdgeInsets.zero,
                    ),
                    InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampaignSettings(campaignData: campaign, campaignId: campaignId))).then((value) {
                          setState(() {
                            campaign = value;
                          });
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          'assets/cog.svg',
                          height: 20,
                          width: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                getCampaignUsers(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryCard(
                      child: Column(
                        children: [
                          TextWithIcon(
                            text: "7 Things Ranking Board",
                            assetPath: 'assets/medal.svg',
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          FutureBuilder<List<dynamic>>(
                              future: Future.wait([userRef.get(), nameRef.get()]),
                              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasError) {
                                  return Padding(
                                    padding: EdgeInsets.all(50),
                                    child: Center(child: Text("Something went wrong")),
                                  );
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  var rankings = snapshot.data[0].docs.asMap();
                                  var users = snapshot.data[1].docs.asMap();
                                  Map<String, String> names = {};
                                  Map<String, double> result = {};
                                  Map<String, double> sorted = {};
                                  List<double> sortVal = [];
                                  List<Color> colors = [Color(0xFFFFDF00), Color(0xFFB5B7BB), Color(0XFFCD7F32), Color(0XFF299E45), Color(0XFF299E45)];

                                  users.forEach((i, v) {
                                    names[v.id] = v.get('name');
                                  });

                                  rankings.forEach((i, v) {
                                    var finalScore = v.get('totalScore') / v.get('totalDays');
                                    result[v.id] = finalScore;
                                    sortVal.add(finalScore);
                                  });

                                  sortVal.sort((b, a) => a.compareTo(b));

                                  sortVal.forEach((x) {
                                    result.forEach((key, value) {
                                      if (value == x) {
                                        sorted[key] = x;
                                      }
                                    });
                                  });

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: sorted.length > 5 ? 5 : sorted.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  names[sorted.entries.elementAt(index).key],
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                ),
                                                Text(
                                                  (sorted.entries.elementAt(index).value * 10).toStringAsFixed(2) + "%",
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(5)),
                                            RoundedLinearProgress(
                                              color: colors[index],
                                              value: sorted.entries.elementAt(index).value / 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }

                                return Padding(
                                  padding: EdgeInsets.all(50),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    Text(
                      'Custom Ground Rules',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Padding(padding: EdgeInsets.all(7.6)),
                    PrimaryCard(
                      child: Text(
                        campaign.rules,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    Text(
                      'Campaign Information',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Padding(padding: EdgeInsets.all(7.6)),
                    PrimaryCard(
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
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
                              Text(
                                campaign.duration.toString() + " months",
                                style: TextStyle(
                                  color: Color(0xFF6E6E6E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          Padding(padding: EdgeInsets.all(10)),
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
                              Text(
                                campaign.goalDecision,
                                style: TextStyle(
                                  color: Color(0xFF6E6E6E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          Padding(padding: EdgeInsets.all(10)),
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
                              Text(
                                campaign.sevenThingsDeadline,
                                style: TextStyle(
                                  color: Color(0xFF6E6E6E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '7 Things Penalty (' + (campaign.sevenThingsPenaltyDecision ? 'On' : 'Off') + ')',
                                style: TextStyle(
                                  color: Color(0xFF6E6E6E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              campaign.sevenThingsPenalty != null
                                  ? Text(
                                      campaign.sevenThingsPenalty + "%",
                                      style: TextStyle(
                                        color: Color(0xFF6E6E6E),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Goal Settings Review Day ' + campaign.selectedGoalReview.toString() + ' of every month',
                                style: TextStyle(
                                  color: Color(0xFF6E6E6E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCampaignUsers() {
    var users;
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('UserData').where('currentEnrolledCampaign', isEqualTo: campaign.invitationCode).get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          users = snapshot.data;
          if (users.docs.length == 1) {
            return Container(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'No users found',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6E6E6E), fontWeight: FontWeight.w600),
                ),
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.only(top: 20),
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.size,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = users.docs[index];
                  if (user.id != FirebaseAuth.instance.currentUser.uid) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoadGoals(
                              toGetUid: user.id,
                              userdata: user,
                              isSelf: false,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.only(left: 8, right: 8),
                            height: 76,
                            width: 76,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.13),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(23),
                                  child: SvgPicture.asset(
                                    'assets/user.svg',
                                    color: Colors.black,
                                    height: 22,
                                    width: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(3)),
                          Text(
                            user.get('name'),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            );
          }
        }

        return Container(
          margin: EdgeInsets.only(top: 20),
          height: 120,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Loading user data ...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6E6E6E), fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}

class CampaignUserDetails extends StatefulWidget {
  final userdata;
  final goalExists;
  final goals;
  final score;

  const CampaignUserDetails({Key key, this.userdata, this.goalExists, this.goals, this.score}) : super(key: key);

  _CampaignUserDetailsState createState() => _CampaignUserDetailsState(userdata, goalExists, goals, score);
}

class _CampaignUserDetailsState extends State<CampaignUserDetails> {
  final userdata;
  final bool goalExists;
  final goals;
  final score;

  var today;

  _CampaignUserDetailsState(this.userdata, this.goalExists, this.goals, this.score);

  Future<DateTime> getNetworkTime() async {
    var dataJson = await http.get(Uri.parse("http://worldtimeapi.org/api/timezone/Asia/Kuala_Lumpur"));
    var date = DateTime.parse(jsonDecode(dataJson.body)['datetime']);
    date = DateTime(date.year, date.month, date.day);
    return date;
  }

  @override
  void initState() {
    super.initState();
    getNetworkTime().then((value) {
      setState(() {
        today = DateTime(value.year, value.month, value.day);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var goalDetails = new GoalsDetails();
    Map<String, dynamic> goalsTemp;
    Map<String, dynamic> subScore;
    var scoreObj;

    Map<String, dynamic> getSelected() {
      Map<String, dynamic> result = {};
      goals.forEach((key, value) {
        if (key != "targetLCI") {
          if (value['selected']) {
            result[key] = value;
          }
        }
      });
      return result;
    }

    if (goalExists) {
      scoreObj = new LCIScore(score.data());
      goalsTemp = getSelected();
      subScore = scoreObj.subScore();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: userdata.get('name') + "'s Details",
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  children: [
                    getTargetSevenThings(),
                    Padding(padding: EdgeInsets.all(20)),
                    TextWithIcon(
                      text: 'Milestones',
                      assetPath: 'assets/star.svg',
                    ),
                    goalExists
                        ? Column(
                            children: goalsTemp.keys.map((key) {
                              return Column(
                                children: [
                                  PrimaryCard(
                                    padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextWithIcon(
                                          assetColor: goalDetails.getColor(key),
                                          assetPath: goalDetails.getAssetPath(key),
                                          text: key,
                                          textStyle: TextStyle(fontSize: 22, color: goalDetails.getColor(key), fontWeight: FontWeight.w700),
                                        ),
                                        Padding(padding: EdgeInsets.all(7.5)),
                                        MultiColorProgressBar(subScore[key] / 10, double.parse(goalsTemp[key]['target'].toString()) / 10, Color(0xFF170E9A), Color(0xFF0DC5B2)),
                                        Padding(padding: EdgeInsets.all(15)),
                                        Text(
                                          "Definition of Success/Goal",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: goalDetails.getColor(key),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(2)),
                                        Text(
                                          goalsTemp[key]['q1'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: goalDetails.getColor(key),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(15)),
                                        Text(
                                          "Achievement within this month",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: goalDetails.getColor(key),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(2)),
                                        Text(
                                          goalsTemp[key]['q2'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: goalDetails.getColor(key),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(15)),
                                        Text(
                                          "Weekly tasks to achieve",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: goalDetails.getColor(key),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(2)),
                                        Text(
                                          goalsTemp[key]['q3'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: goalDetails.getColor(key),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(30)),
                                ],
                              );
                            }).toList(),
                          )
                        : Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('He/She has no goals set yet'),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTargetSevenThings() {
    DocumentReference sevenThingsRef = userdata.reference.collection('SevenThings').doc(today.toString());
    return FutureBuilder(
      future: sevenThingsRef.get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          List<dynamic> contentOrder = [];
          if(data != null && data.isNotEmpty) {
            if(data.containsKey('contentOrder')) {
              contentOrder = data['contentOrder'];
            } else {
              var primaryCounter = 0;
              var secondaryCounter = 0;

              data['content'].forEach((k, v) {
                if (v['type'] == 'Primary') {
                  contentOrder.add(k);
                  primaryCounter++;
                }
              });
              if (primaryCounter < 3) {
                while (primaryCounter < 3) {
                  contentOrder.add("");
                  primaryCounter++;
                }
              }

              data['content'].forEach((k, v) {
                if (v['type'] == 'Secondary') {
                  contentOrder.add(k);
                  secondaryCounter++;
                }
              });
              if (secondaryCounter < 4) {
                while (secondaryCounter < 4) {
                  contentOrder.add("");
                  secondaryCounter++;
                }
              }
            }
          } else {
            contentOrder = [];
          }
          return SizedBox(
            child: Column(
              children: [
                PrimaryCard(
                  child: Column(
                    children: [
                      TextWithIcon(
                        text: 'Today\'s 7 Things',
                        assetPath: 'assets/tasks.svg',
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      contentOrder.length == 0
                          ? Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('He/She has not set any 7 things for today.', style: TextStyle(color: Color(0xFF6E6E6E))),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var i = 0; i < contentOrder.length; i++)
                                  contentOrder[i].isNotEmpty
                                      ? Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 15),
                                                height: 16,
                                                width: 16,
                                                child: Checkbox(
                                                  activeColor: Color(0xFFF48A1D),
                                                  checkColor: Colors.white,
                                                  value: data['content'][contentOrder[i]]['status'],
                                                  onChanged: null,
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  contentOrder[i],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink(),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CampaignSettings extends StatefulWidget {
  final campaignData;
  final campaignId;

  const CampaignSettings({Key key, this.campaignData, this.campaignId}) : super(key: key);

  _CampaignSettingsState createState() => _CampaignSettingsState(campaignData, campaignId);
}

class _CampaignSettingsState extends State<CampaignSettings> {
  final campaignId;
  CampaignData campaignData;

  _CampaignSettingsState(this.campaignData, this.campaignId);

  final _scorePenaltyController = new TextEditingController();
  FocusNode _scorePenaltyNode;

  var authLevel;
  var goalDecision;
  var usersRef;

  Future<void> showLoading() {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (c) {
        return LoadingOverlay();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    usersRef = FirebaseFirestore.instance.collection('UserData').where('currentEnrolledCampaign', isEqualTo: campaignData.invitationCode).get();
    _scorePenaltyNode = new FocusNode();
    _scorePenaltyNode.addListener(() {
      setState(() {});
    });
    var currentUid = FirebaseAuth.instance.currentUser.uid;
    if (campaignData.campaignAdmin == currentUid) {
      authLevel = AuthLevel.ADMIN;
    } else if (campaignData.campaignModerator.contains(currentUid)) {
      authLevel = AuthLevel.MOD;
    } else {
      authLevel = AuthLevel.NORMAL;
    }

    if (campaignData.goalDecision == "On Member") {
      goalDecision = true;
    } else {
      goalDecision = false;
    }

    if (campaignData.sevenThingsPenaltyDecision) {
      _scorePenaltyController.text = campaignData.sevenThingsPenalty;
    }
  }

  Future<void> leaveCampaign() {
    return showDialog<void>(
      context: context,
      builder: (c) {
        return PrimaryDialog(
          title: Text("Leaving the campaign"),
          content: Text("Are you sure you want to un-enroll from this campaign?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.doc("UserData/${FirebaseAuth.instance.currentUser.uid}").update({'currentEnrolledCampaign': ""});
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GetUserData(point: 1)));
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Color(0xFFFF0000),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      color: Color(0xFF6E6E6E),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    TextStyle categoryTitleStyle = TextStyle(
      fontSize: 12,
      color: Color(0xFF170E9A),
      fontWeight: FontWeight.w900,
    );

    List<int> monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    List<int> generateDay() {
      List<int> list = <int>[];
      for (var i = 1; i <= 31; i++) {
        list.add(i);
      }
      return list;
    }

    List<String> generateTimes() {
      List<String> list = <String>[];
      for (var i = 0; i < 24; i++) {
        list.add(i.toString() + ':00');
      }
      return list;
    }

    List<String> timeList = generateTimes();
    List<int> dayList = generateDay();

    return WillPopScope(
      onWillPop: () async {
        showLoading();
        if (campaignData.sevenThingsPenaltyDecision) {
          if (_scorePenaltyController.text.isNotEmpty) {
            if (int.parse(_scorePenaltyController.text) > 100) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("7 Things score penalty cannot be greater than 100%")));
              return false;
            } else {
              campaignData.sevenThingsPenalty = _scorePenaltyController.text;
            }
          } else {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("7 Things score penalty cannot be empty")));
            return false;
          }
        }
        await FirebaseFirestore.instance.collection("CampaignData").doc(campaignId).update({
          'name': campaignData.name,
          'duration': campaignData.duration,
          'startDate': Timestamp.now(),
          'goalDecision': campaignData.goalDecision,
          'sevenThingDeadline': campaignData.sevenThingsDeadline,
          'sevenThingsPenaltyDecision': campaignData.sevenThingsPenaltyDecision,
          'sevenThingsPenalties': campaignData.sevenThingsPenalty,
          'campaignAdmin': campaignData.campaignAdmin,
          'campaignModerator': campaignData.campaignModerator,
          'invitationCode': campaignData.invitationCode,
          'selectedGoalReview': campaignData.selectedGoalReview,
          'rules': campaignData.rules
        }).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop(campaignData);
        }).catchError((error) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error has occurred")));
        });
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PageHeadings(
                  text: "Campaign Settings",
                  popAvailable: true,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      authLevel == AuthLevel.ADMIN || authLevel == AuthLevel.MOD
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('CAMPAIGN DETAILS', style: categoryTitleStyle),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Duration of the campaign',
                                        style: titleStyle,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 35,
                                            width: 70,
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
                                                  value: campaignData.duration,
                                                  items: monthList.map<DropdownMenuItem<int>>((int value) {
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
                                                        campaignData.duration = newValue;
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
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Goal Setting Decision',
                                        style: titleStyle,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            campaignData.goalDecision,
                                            style: TextStyle(
                                              color: goalDecision ? Color(0xFF36C164) : Color(0xFF999999),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.all(2)),
                                          CupertinoSwitch(
                                            activeColor: Color(0xFF36C164),
                                            value: goalDecision,
                                            onChanged: (value) {
                                              setState(() {
                                                goalDecision = value;
                                                if (goalDecision) {
                                                  campaignData.goalDecision = "On Member";
                                                } else {
                                                  campaignData.goalDecision = "On Campaign";
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '7 Things Deadline',
                                        style: titleStyle,
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
                                              value: campaignData.sevenThingsDeadline,
                                              items: timeList.map<DropdownMenuItem<String>>((String value) {
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
                                                    campaignData.sevenThingsDeadline = newValue;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '7 Things Penalty (On/Off)',
                                        style: titleStyle,
                                      ),
                                      CupertinoSwitch(
                                        activeColor: Color(0xFF36C164),
                                        value: campaignData.sevenThingsPenaltyDecision,
                                        onChanged: (value) {
                                          setState(() {
                                            campaignData.sevenThingsPenaltyDecision = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '7 Things Score Penalty %',
                                        style: TextStyle(
                                          color: campaignData.sevenThingsPenaltyDecision ? Color(0xFF6E6E6E) : Color(0xFFAAAAAA),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 45,
                                        width: 90,
                                        child: InputBox(
                                          focusNode: _scorePenaltyNode,
                                          controller: _scorePenaltyController,
                                          textAlign: TextAlign.center,
                                          readOnly: !campaignData.sevenThingsPenaltyDecision,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Goal Settings Review Day',
                                        style: TextStyle(
                                          color: Color(0xFF6E6E6E),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 65,
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
                                                fontSize: 14,
                                              ),
                                              value: campaignData.selectedGoalReview,
                                              items: dayList.map<DropdownMenuItem<int>>((int value) {
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
                                                    campaignData.selectedGoalReview = newValue;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'of each month',
                                        style: TextStyle(
                                          color: Color(0xFF6E6E6E),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(20)),
                              ],
                            )
                          : SizedBox.shrink(),
                      Text(
                        'MEMBER LIST',
                        style: categoryTitleStyle,
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      FutureBuilder(
                        future: usersRef,
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Padding(padding: EdgeInsets.all(50), child: Text('Something went wrong'));
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            var users = snapshot.data.docs.asMap();
                            return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> userData = users[index].data();
                                  var uid = users[index].id;
                                  return Container(
                                    padding: authLevel != AuthLevel.NORMAL && uid != FirebaseAuth.instance.currentUser.uid && uid != campaignData.campaignAdmin
                                        ? EdgeInsets.symmetric(vertical: 0)
                                        : EdgeInsets.symmetric(vertical: 15),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: Color(0xFFEEEEEE),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(uid == FirebaseAuth.instance.currentUser.uid ? userData['name'] + " (You)" : userData['name'], style: titleStyle),
                                        Row(
                                          children: [
                                            Text(
                                                uid == campaignData.campaignAdmin
                                                    ? "Owner"
                                                    : campaignData.campaignModerator.contains(uid)
                                                        ? "Admin"
                                                        : "Member",
                                                style: titleStyle),
                                            authLevel != AuthLevel.NORMAL && uid != FirebaseAuth.instance.currentUser.uid && uid != campaignData.campaignAdmin
                                                ? DropdownButtonHideUnderline(
                                                    child: SizedBox(
                                                      width: 24,
                                                      child: PopupMenuButton(
                                                        onSelected: (value) async {
                                                          if (value == 1) {
                                                            showLoading();
                                                            setState(() {
                                                              campaignData.campaignModerator.remove(uid);
                                                            });
                                                            await FirebaseFirestore.instance.collection('CampaignData').doc(campaignId).update({
                                                              "campaignModerator": campaignData.campaignModerator,
                                                            }).then((value) {
                                                              Navigator.of(context).pop();
                                                              setState(() {
                                                                usersRef =
                                                                    FirebaseFirestore.instance.collection('UserData').where('currentEnrolledCampaign', isEqualTo: campaignData.invitationCode).get();
                                                              });
                                                            }).catchError((error) {
                                                              Navigator.of(context).pop();
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
                                                            });
                                                          } else if (value == 2) {
                                                            showLoading();
                                                            await FirebaseFirestore.instance.collection("UserData").doc(uid).update({
                                                              "currentEnrolledCampaign": "",
                                                            }).then((value) {
                                                              Navigator.of(context).pop();
                                                              setState(() {
                                                                usersRef =
                                                                    FirebaseFirestore.instance.collection('UserData').where('currentEnrolledCampaign', isEqualTo: campaignData.invitationCode).get();
                                                              });
                                                            }).catchError((error) {
                                                              Navigator.of(context).pop();
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
                                                            });
                                                          } else if (value == 3) {
                                                            showLoading();
                                                            setState(() {
                                                              campaignData.campaignModerator.add(uid);
                                                            });
                                                            await FirebaseFirestore.instance.collection('CampaignData').doc(campaignId).update({
                                                              "campaignModerator": campaignData.campaignModerator,
                                                            }).then((value) {
                                                              Navigator.of(context).pop();
                                                              setState(() {
                                                                usersRef =
                                                                    FirebaseFirestore.instance.collection('UserData').where('currentEnrolledCampaign', isEqualTo: campaignData.invitationCode).get();
                                                              });
                                                            }).catchError((error) {
                                                              Navigator.of(context).pop();
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
                                                            });
                                                          }
                                                        },
                                                        icon: SvgPicture.asset('assets/ellipsis-v.svg', color: Color(0xFF6E6E6E), height: 14, width: 14),
                                                        itemBuilder: (context) => [
                                                          campaignData.campaignModerator.contains(uid)
                                                              ? PopupMenuItem(
                                                                  height: 48,
                                                                  child: Text('Demote to Member'),
                                                                  value: 1,
                                                                )
                                                              : PopupMenuItem(
                                                                  height: 48,
                                                                  child: Text('Promote to Admin'),
                                                                  value: 3,
                                                                ),
                                                          PopupMenuItem(
                                                            height: 48,
                                                            child: Text('Kick'),
                                                            value: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(width: 24),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }

                          return Padding(
                            padding: EdgeInsets.all(50),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      PrimaryButton(
                          text: "Un-enroll",
                          textColor: Colors.white,
                          color: Color(0xFFFF3939),
                          onClickFunction: () {
                            leaveCampaign();
                          }),
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

enum AuthLevel {
  ADMIN,
  MOD,
  NORMAL,
}
