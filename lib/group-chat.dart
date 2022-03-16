import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';

import 'custom-components.dart';

class GroupChat extends StatefulWidget {
  final campaignId;

  const GroupChat({Key? key, this.campaignId}) : super(key: key);

  @override
  _GroupChatState createState() => _GroupChatState(campaignId);
}

class _GroupChatState extends State<GroupChat> {
  final campaignId;

  _GroupChatState(this.campaignId);

  late TextEditingController _messageController = new TextEditingController();
  late FocusNode _messageFocusNode;
  late Stream chatStream;
  late Map<String, String> nameList = {};
  late bool showPoll = true;

  void sendMessage(String message) {
    FirebaseFirestore.instance.collection('ChatData').doc('content').collection(campaignId).doc().set({
      "content": message,
      "sender": FirebaseAuth.instance.currentUser?.uid,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  @override
  void initState() {
    super.initState();
    _messageFocusNode = new FocusNode();
    chatStream = FirebaseFirestore.instance.collection("ChatData").doc('content').collection(campaignId).orderBy("timestamp", descending: true).snapshots();
    FirebaseFirestore.instance.collection("CampaignData").doc(campaignId).get().then((value) {
      var invitationCode = value.get("invitationCode");
      FirebaseFirestore.instance.collection("UserData").where("currentEnrolledCampaign", isEqualTo: invitationCode).get().then((value) {
        value.docs.forEach((element) {
          setState(() {
            nameList[element.id] = element.get("name");
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _messageFocusNode.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              PageHeadings(
                text: "Chat Room",
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                popAvailable: true,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              ),
              StreamBuilder(
                stream: chatStream,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: ListView(
                        key: UniqueKey(),
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        children: snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          Timestamp timestamp = data['timestamp'];
                          String contentId = document.id;
                          String sender = data['sender'];
                          String? senderName = nameList[sender] != null ? nameList[sender] : "";
                          String time = timestamp != null ? "${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}" : "Sending...";
                          var content = data['content'];
                          if (content is String) {
                            //When content is message
                            if (data['sender'] == FirebaseAuth.instance.currentUser?.uid) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: ChatBubble(
                                  content: content,
                                  owner: true,
                                  timeStamp: time,
                                  targetName: '',
                                ),
                              );
                            } else {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                      height: 52,
                                      width: 52,
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
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: SvgPicture.asset(
                                          'assets/user.svg',
                                          color: Colors.black,
                                          height: 14,
                                          width: 14,
                                        ),
                                      ),
                                    ),
                                    ChatBubble(
                                      content: content,
                                      targetName: senderName!,
                                      owner: false,
                                      timeStamp: time,
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else if (content is Map) {
                            //When content is poll
                            DateTime expireTime = content['pollEndDate'].toDate();
                            String? uid = FirebaseAuth.instance.currentUser?.uid;
                            String votedOn = "";
                            String sevenThingsDate = "${expireTime.year}-${expireTime.month.toString().padLeft(2, '0')}-${expireTime.day} 00:00:00.000";
                            print(sevenThingsDate);
                            String senderId = data['sender'];
                            List<dynamic> yesList = content['yesList'];
                            List<dynamic> noList = content['noList'];
                            int totalVotes = yesList.length + noList.length;
                            double yesValue = totalVotes == 0 ? 0.0 : yesList.length / totalVotes;
                            double noValue = totalVotes == 0 ? 0.0 : noList.length / totalVotes;
                            DocumentReference chatContentRef =
                                FirebaseFirestore.instance.collection('ChatData').doc('content').collection(campaignId).doc(contentId);
                            DocumentReference userSevenThingsRef =
                                FirebaseFirestore.instance.collection('UserData').doc(senderId).collection('SevenThings').doc(sevenThingsDate);
                            Map<dynamic, dynamic> tempSevenThingsStatus = {};
                            Function yesCallback = () async {
                              if (noList.contains(uid)) {
                                noList.remove(uid);
                                content['noList'] = noList;
                              }
                              yesList.add(uid);
                              content['yesList'] = yesList;
                              await chatContentRef.update({"content": content});
                              await userSevenThingsRef.get().then((sevenThingsData) {
                                try {
                                  tempSevenThingsStatus = sevenThingsData.get("status");
                                } catch (e) {
                                  tempSevenThingsStatus = {};
                                }
                              });
                              tempSevenThingsStatus['leave'] = true;
                              await userSevenThingsRef.set({"status": tempSevenThingsStatus});
                            };
                            Function noCallback = () async {
                              if (yesList.contains(uid)) {
                                yesList.remove(uid);
                                content['yesList'] = yesList;
                              }
                              noList.add(uid);
                              content['noList'] = noList;
                              await chatContentRef.update({"content": content});
                            };
                            if (yesList.contains(uid)) {
                              votedOn = "Yes";
                            }
                            if (noList.contains(uid)) {
                              votedOn = "No";
                            }
                            if (data['sender'] == FirebaseAuth.instance.currentUser?.uid) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: ChatPoll(
                                  yesValue: yesValue,
                                  noValue: noValue,
                                  yesCallback: yesCallback,
                                  noCallback: noCallback,
                                  votedOn: votedOn,
                                  owner: true,
                                  expireTime: expireTime,
                                ),
                              );
                            } else {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                      height: 52,
                                      width: 52,
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
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: SvgPicture.asset(
                                          'assets/user.svg',
                                          color: Colors.black,
                                          height: 14,
                                          width: 14,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ChatPoll(
                                        yesValue: yesValue,
                                        noValue: noValue,
                                        yesCallback: yesCallback,
                                        noCallback: noCallback,
                                        votedOn: votedOn,
                                        owner: true,
                                        expireTime: expireTime,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 92,
                      child: InputBox(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        hint: "Type your message here",
                        focusNode: _messageFocusNode,
                        color: Color(0xFF170E9A),
                        controller: _messageController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: (value) {
                          if (_messageController.text.isNotEmpty) {
                            setState(() {
                              showPoll = false;
                            });
                          } else {
                            setState(() {
                              showPoll = true;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    showPoll
                        ? GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance.collection("CampaignData").doc(campaignId).get().then((campaignData) async {
                                String sevenThingsDeadline = campaignData.get('sevenThingDeadline');
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => CreatePoll(campaignId: campaignId, sevenThingsDeadline: sevenThingsDeadline)));
                              }).catchError((e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(e),
                                ));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(18, 16, 16, 16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF170E9A),
                              ),
                              child: SvgPicture.asset(
                                'assets/poll.svg',
                                height: 18,
                                width: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (_messageController.text.isNotEmpty) {
                                String message = restructureStringFromNewLine(_messageController.text);
                                sendMessage(message);
                                _messageController.text = "";
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 18, 16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF170E9A),
                              ),
                              child: SvgPicture.asset(
                                'assets/paper-plane.svg',
                                height: 18,
                                width: 18,
                                color: Colors.white,
                              ),
                            ),
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

class CreatePoll extends StatefulWidget {
  final campaignId;
  final sevenThingsDeadline;

  const CreatePoll({Key? key, this.campaignId, this.sevenThingsDeadline}) : super(key: key);

  @override
  _CreatePollState createState() => _CreatePollState(campaignId, sevenThingsDeadline);
}

class _CreatePollState extends State<CreatePoll> {
  final campaignId;
  final sevenThingsDeadline;

  late DateTime selectedDate;
  late DateTime minTime;

  _CreatePollState(this.campaignId, this.sevenThingsDeadline);

  var getCampaignRef;

  @override
  void initState() {
    super.initState();
    int hour = int.parse(sevenThingsDeadline.split(":")[0]);
    DateTime currentTime = DateTime.now();
    DateTime tempTime = DateTime(currentTime.year, currentTime.month, currentTime.day, hour);
    setState(() {
      minTime = tempTime.isAfter(currentTime) ? currentTime : currentTime.add(Duration(days: 1));
      selectedDate = minTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: PageHeadings(
                popAvailable: true,
                text: "Create Poll",
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 86,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        "Creating a leave poll for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: TextStyle(fontSize: 17),
                      ),
                      Padding(padding: EdgeInsets.all(12)),
                      Text("What is a leave poll?"),
                      Text("description"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        onClickFunction: () {
                          DatePicker.showDatePicker(
                            context,
                            onChanged: (value) {
                              setState(() {
                                selectedDate = value;
                              });
                            },
                            minTime: minTime,
                          );
                        },
                        color: Color(0xFF170E9A),
                        text: "Change Date",
                        textColor: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      PrimaryButton(
                        onClickFunction: () async {
                          showLoading(context);
                          Map<String, dynamic> pollContent = {};
                          List<String> splitTime = "8:00".split(':');
                          DateTime currentDate = selectedDate;

                          DateTime pollEndDate =
                              DateTime(currentDate.year, currentDate.month, currentDate.day, int.parse(splitTime[0]), int.parse(splitTime[1]));
                          pollContent['pollEndDate'] = pollEndDate;
                          pollContent['yesList'] = [];
                          pollContent['noList'] = [];

                          FirebaseFirestore.instance.collection('ChatData').doc('content').collection(campaignId).doc().set({
                            "content": pollContent,
                            "sender": FirebaseAuth.instance.currentUser?.uid,
                            "timestamp": FieldValue.serverTimestamp(),
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF299E45),
                        text: "Confirm",
                        textColor: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
