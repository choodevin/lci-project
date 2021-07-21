import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'custom-components.dart';

class GroupChat extends StatefulWidget {
  final campaignId;

  const GroupChat({Key key, this.campaignId}) : super(key: key);

  @override
  _GroupChatState createState() => _GroupChatState(campaignId);
}

class _GroupChatState extends State<GroupChat> {
  final campaignId;

  _GroupChatState(this.campaignId);

  TextEditingController _messageController = new TextEditingController();
  FocusNode _messageFocusNode;
  Stream chatStream;
  Map<String, String> nameList = {};

  void sendMessage(String message) {
    FirebaseFirestore.instance.collection('ChatData').doc('content').collection(campaignId).doc().set({
      "content": message,
      "sender": FirebaseAuth.instance.currentUser.uid,
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
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        children: snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          Timestamp timestamp = data['timestamp'];
                          String content = data['content'];
                          String sender = data['sender'];
                          String senderName = nameList[sender] != null ? nameList[sender] : "";
                          String time = timestamp != null ? "${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}" : "Sending...";
                          if (data['sender'] == FirebaseAuth.instance.currentUser.uid) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: ChatBubble(
                                content: content,
                                owner: true,
                                timeStamp: time,
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
                                    targetName: senderName,
                                    owner: false,
                                    timeStamp: time,
                                  ),
                                ],
                              ),
                            );
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
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    InkWell(
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
