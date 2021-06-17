import 'dart:math';

import 'package:LCI/custom-components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'entity/CampaignData.dart';

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
          campaign.sevenThingsDeadline = snapshot.data.docs.last.get('sevenThingDeadline');
          campaign.sevenThingsPenaltyDecision = snapshot.data.docs.last.get('sevenThingsPenaltyDecision');
          campaign.sevenThingsPenalty = snapshot.data.docs.last.get('sevenThingsPenalties');
          campaign.startDate = snapshot.data.docs.last.get('startDate');
          return CampaignMain(campaign: campaign);
        }

        return Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}

class CampaignNew extends StatelessWidget {
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
              ),
              Padding(padding: EdgeInsets.all(25)),
              PrimaryButton(
                text: 'Create New Campaign',
                color: Color(0xFF299E45),
                textColor: Colors.white,
                onClickFunction: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaign()));
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
  final _scorePenaltyController = new TextEditingController();
  final _campaignNameController = new TextEditingController();
  String selectedDeadline = "0:00";
  String goalSettingLabel = "On Member";
  bool goalSettingDecision = true;
  bool penaltyDecision = false;
  int selectedMonth = 1;
  int selectedGoalReview = 1;
  FocusNode _scorePenaltyNode;
  FocusNode _campaignNameNode;

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
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Setting up New Campaign',
                ),
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaignRules(campaignData: campaignData)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('7 Things penalty entered must be within 0-100')));
                          return;
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid 7 things penalty input')));
                        return;
                      }
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaignRules(campaignData: campaignData)));
                    }
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

  _SetupCampaignRulesState createState() => _SetupCampaignRulesState(campaignData);
}

class _SetupCampaignRulesState extends State<SetupCampaignRules> {
  final CampaignData campaignData;
  final _rulesController = new TextEditingController();

  _SetupCampaignRulesState(this.campaignData);

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
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
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
                      'rules': campaignData.rules
                    });
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaignFinal(campaignData: campaignData)));
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampaignMain()));
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
  final CampaignData campaign;

  const CampaignMain({Key key, this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Campaign',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
