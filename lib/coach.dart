import 'package:LCI/custom-components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'campaign.dart';

class CoachMain extends StatefulWidget {
  @override
  _CoachMainState createState() => _CoachMainState();
}

class _CoachMainState extends State<CoachMain> {
  late Future<DocumentSnapshot> coachingListRef;
  late Future<QuerySnapshot> campaignNameRef;

  @override
  void initState() {
    super.initState();
    coachingListRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser?.uid).get();
    campaignNameRef = FirebaseFirestore.instance.collection('CampaignData').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: "Coach Screen",
                popAvailable: true,
              ),
              Container(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 110),
                padding: EdgeInsets.fromLTRB(32, 10, 32, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text('All available campaigns', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        ),
                        FutureBuilder<List<dynamic>>(
                          future: Future.wait([coachingListRef, campaignNameRef]),
                          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.hasError) {
                              return Padding(padding: EdgeInsets.all(50), child: Text('Something went wrong'));
                            }

                            if (snapshot.connectionState == ConnectionState.done) {
                              List<dynamic> coachingList;
                              Map<String, String> campaignNameList = {};
                              QuerySnapshot campaignSnapshot = snapshot.data![1];
                              campaignSnapshot.docs.forEach((element) {
                                campaignNameList[element.get('invitationCode')] = element.get('name');
                              });
                              try {
                                coachingList = snapshot.data?[0].get('coachingList');
                              } catch (e) {
                                return Text("There are no campaign joined as coach");
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: coachingList.length,
                                itemBuilder: (context, index) {
                                  var campaignName = campaignNameList[coachingList[index]];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadCampaign(toSearchCampaign: coachingList[index])));
                                      },
                                      child: PrimaryCard(
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          campaignName!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                    PrimaryButton(
                      text: "Join Campaign as Coach",
                      color: Color(0xFF170E9A),
                      textColor: Colors.white,
                      onClickFunction: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => JoinCampaignAsCoach())).then((changes) {
                          if (changes) {
                            setState(() {
                              coachingListRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser?.uid).get();
                            });
                          }
                        });
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

class JoinCampaignAsCoach extends StatefulWidget {
  _JoinCampaignAsCoachState createState() => _JoinCampaignAsCoachState();
}

class _JoinCampaignAsCoachState extends State<JoinCampaignAsCoach> {
  late FocusNode _campaignCodeNode;
  var _campaignCodeController = new TextEditingController();
  var changes = false;

  _JoinCampaignAsCoachState();

  @override
  void initState() {
    super.initState();
    _campaignCodeNode = new FocusNode();
    _campaignCodeNode.addListener(() {
      setState(() {});
    });
  }

  Future<String> joinCampaign() async {
    return await FirebaseFirestore.instance.collection('CampaignData').where('invitationCode', isEqualTo: _campaignCodeController.text).get().then((value) async {
      if (value.size == 0) {
        return 'No campaign found';
      } else {
        var userRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser?.uid);
        return await userRef.get().then((value) async {
          List<dynamic> coachingList;
          try {
            coachingList = value.get('coachingList');
            if (coachingList.contains(_campaignCodeController.text)) {}
          } catch (e) {
            coachingList = [];
          }
          if (coachingList.contains(_campaignCodeController.text)) {
            return "You are currently enrolled in this campaign.";
          } else {
            coachingList.add(_campaignCodeController.text);
            await userRef.update({'coachingList': coachingList});
            changes = true;
            return "Campaign found and enrolled";
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(changes);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
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
                      controller: _campaignCodeController, keyboardType: null,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    PrimaryButton(
                      color: Color(0xFF170E9A),
                      textColor: Colors.white,
                      text: 'Join',
                      onClickFunction: () async {
                        if (_campaignCodeController.text.isNotEmpty) {
                          showLoading(context);

                          var message = await joinCampaign().whenComplete(() => Navigator.of(context).pop());

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a campaign code.')));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
