import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom-components.dart';

class LeaveApplicationMain extends StatefulWidget {
  final campaignId;

  const LeaveApplicationMain({Key key, this.campaignId}) : super(key: key);

  @override
  _LeaveApplicationMainState createState() => _LeaveApplicationMainState(campaignId);
}

class _LeaveApplicationMainState extends State<LeaveApplicationMain> {
  final campaignId;

  _LeaveApplicationMainState(this.campaignId);

  int maxUserCount = 0;

  List<DateTime> invalidDateList = [];

  String deadlineHour = "";

  Future<List<dynamic>> getLeave() async {
    try {
      DocumentReference campaignRef = FirebaseFirestore.instance.collection("CampaignData").doc(campaignId);
      CollectionReference leaveRef = FirebaseFirestore.instance.collection("CampaignData/$campaignId/LeaveApplication");
      CollectionReference userRef = FirebaseFirestore.instance.collection("UserData");

      DocumentSnapshot campaignSnapshot = await campaignRef.get();
      QuerySnapshot leaveSnapshot = await leaveRef.orderBy("leaveDate", descending: true).get();

      String campaignInvitationCode = await campaignSnapshot.get("invitationCode");

      QuerySnapshot userSnapshot = await userRef.where("currentEnrolledCampaign", isEqualTo: campaignInvitationCode).get();

      maxUserCount = userSnapshot.size - 1;

      List finalList = [];
      Map<String, String> nameList = {};

      String sevenThingsDeadline = campaignSnapshot.get("sevenThingDeadline");
      deadlineHour = sevenThingsDeadline.split(":")[0];

      DateTime deadlineDate = DateTime.now();
      deadlineDate = DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day, int.tryParse(deadlineHour));

      if (DateTime.now().isAfter(deadlineDate)) {
        invalidDateList.add(DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day));
      }

      if (userSnapshot.size > 0) {
        Iterator it = userSnapshot.docs.iterator;

        while (it.moveNext()) {
          DocumentSnapshot doc = it.current;

          nameList.putIfAbsent(doc.id, () => doc.get("name"));
        }
      }

      if (leaveSnapshot.size > 0) {
        Iterator it = leaveSnapshot.docs.iterator;
        while (it.moveNext()) {
          DocumentSnapshot doc = it.current;
          String status;

          if (maxUserCount == doc['approvedUser'].length) {
            status = "approved";
          } else {
            if (doc['leaveDate'].toDate().isAfter(DateTime.now())) {
              status = "ongoing";
            } else {
              status = "rejected";
            }
          }
          if (doc['rejectedUser'].length > 0) {
            status = "rejected";
          }

          if (doc['userId'] == FirebaseAuth.instance.currentUser.uid) {
            invalidDateList.add(DateTime(doc['leaveDate'].toDate().year, doc['leaveDate'].toDate().month, doc['leaveDate'].toDate().day));
            finalList.add({
              "leaveDate": doc['leaveDate'].toDate(),
              "approvedCount": doc['approvedUser'].length,
              "rejectedCount": doc['rejectedUser'].length,
              "name": "You",
              "type": doc['leaveType'],
              "category": 1,
              "status": status,
            });
          } else if (!doc['approvedUser'].contains(FirebaseAuth.instance.currentUser.uid) &&
              !doc['rejectedUser'].contains(FirebaseAuth.instance.currentUser.uid) &&
              DateTime.now().isBefore(doc['leaveDate'].toDate())) {
            finalList.add({
              "leaveDate": doc['leaveDate'].toDate(),
              "approvedCount": doc['approvedUser'].length,
              "rejectedCount": doc['rejectedUser'].length,
              "userId": doc['userId'],
              "leaveId": doc.id,
              "name": nameList[doc['userId']],
              "type": doc['leaveType'],
              "category": 2,
              "status": status,
            });
          } else if (doc['approvedUser'].contains(FirebaseAuth.instance.currentUser.uid) ||
              doc['rejectedUser'].contains(FirebaseAuth.instance.currentUser.uid) ||
              DateTime.now().isAfter(doc['leaveDate'].toDate())) {
            finalList.add({
              "leaveDate": doc['leaveDate'].toDate(),
              "approvedCount": doc['approvedUser'].length,
              "rejectedCount": doc['rejectedUser'].length,
              "name": nameList[doc['userId']],
              "type": doc['leaveType'],
              "category": 3,
              "status": status,
            });
          }
        }
      }

      return finalList;
    } catch (e) {
      throw Exception(e);
    }
  }

  void confirmAction(String type, String name, String leaveId) {
    showDialog<bool>(
      context: context,
      builder: (c) {
        return PrimaryDialog(
          title: Text("Confirm Action"),
          content: Text("Are you sure you want to $type this leave for $name?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Yes',
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: Color(0xFFFF0000),
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) async {
      if (value) {
        showLoading(context);
        CollectionReference leaveRef = FirebaseFirestore.instance.collection("CampaignData/$campaignId/LeaveApplication");
        await leaveRef.doc(leaveId).update({
          (type == "approve" ? "approvedUser" : "rejectedUser"): FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid]),
        });

        DocumentSnapshot latestLeaveData = await leaveRef.doc(leaveId).get();
        DateTime toGetDate = latestLeaveData.get("leaveDate").toDate();
        toGetDate = DateTime(toGetDate.year, toGetDate.month, toGetDate.day);

        DocumentReference sevenThingsRef =
            FirebaseFirestore.instance.collection("UserData/${latestLeaveData.get("userId")}/SevenThings").doc(toGetDate.toString());

        if (latestLeaveData.get("approvedUser").length == maxUserCount) {
          DocumentSnapshot sevenThingsDoc = await sevenThingsRef.get();
          Map<String, dynamic> tempStatus;
          if (sevenThingsDoc.exists) {
            tempStatus = sevenThingsDoc.get("status");
            if (tempStatus == null) {
              tempStatus = {};
            }
            tempStatus.putIfAbsent("leave", () => true);
            await sevenThingsRef.update(tempStatus);
          } else {
            await sevenThingsRef.set({
              "content": {},
              "status": {"leave": true},
            });
          }
        }

        Navigator.of(context).pop();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool cat1Show = false, cat2Show = false, cat3Show = false;
    bool cat1FirstShow = false, cat2FirstShow = false, cat3FirstShow = false;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeadings(
              text: "Leave Application",
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
              popAvailable: true,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 113 - 20,
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: getLeave(),
                      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something wen\'t wrong: ${snapshot.error}");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          List<dynamic> leaveList = snapshot.data;
                          if (leaveList.length > 0) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: Text("You", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 24),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: leaveList.length,
                                      itemBuilder: (context, index) {
                                        if (leaveList[index]['category'] == 1) {
                                          Widget toReturn = Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: !cat1FirstShow ? BorderSide(width: 1, color: Colors.black12) : BorderSide.none,
                                                bottom: BorderSide(width: 1, color: Colors.black12),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "(${leaveList[index]['type']}) ${DateFormat("dd MMMM yyyy").format(leaveList[index]['leaveDate'])}",
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                ),
                                                leaveList[index]['status'] == "approved"
                                                    ? Container(
                                                        padding: EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                                          color: Color(0xFF28A745),
                                                        ),
                                                        child: Text(
                                                          "Approved",
                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                                        ),
                                                      )
                                                    : leaveList[index]['status'] == "rejected"
                                                        ? Container(
                                                            padding: EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                                              color: Color(0xFFEF5350),
                                                            ),
                                                            child: Text(
                                                              "Rejected",
                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                                            ),
                                                          )
                                                        : Container(
                                                            padding: EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Color(0xFF262626), width: 2),
                                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                                              color: Color(0xFF414141),
                                                            ),
                                                            child: Text(
                                                              "On-going",
                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                                            ),
                                                          ),
                                              ],
                                            ),
                                          );
                                          cat1FirstShow = true;
                                          return toReturn;
                                        }
                                        if (leaveList.every((element) => element['category'] != 1) && !cat1Show) {
                                          cat1Show = true;
                                          return Text("You do not have any leave applied");
                                        }
                                        return SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 8), child: Text("Pending", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 24),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: leaveList.length,
                                      itemBuilder: (context, index) {
                                        if (leaveList[index]['category'] == 2) {
                                          Widget toReturn = Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: !cat2FirstShow ? BorderSide(width: 1, color: Colors.black12) : BorderSide.none,
                                                bottom: BorderSide(width: 1, color: Colors.black12),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "(${leaveList[index]['type']}) ${DateFormat("dd MMMM yyyy").format(leaveList[index]['leaveDate'])}",
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text(
                                                      leaveList[index]['name'],
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        margin: EdgeInsets.only(right: 4),
                                                        padding: EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Color(0xFF16722C), width: 2),
                                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                                          color: Color(0xFF28A745),
                                                        ),
                                                        child: Icon(Icons.done, color: Colors.white, size: 20),
                                                      ),
                                                      onTap: () => confirmAction("approve", leaveList[index]['name'], leaveList[index]['leaveId']),
                                                    ),
                                                    GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Color(0xFFC12A2A), width: 2),
                                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                                          color: Color(0xFFEF5350),
                                                        ),
                                                        child: Icon(Icons.close, color: Colors.white, size: 20),
                                                      ),
                                                      onTap: () => confirmAction("reject", leaveList[index]['name'], leaveList[index]['leaveId']),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                          cat2FirstShow = true;
                                          return toReturn;
                                        }

                                        if (leaveList.every((element) => element['category'] != 2) && !cat2Show) {
                                          cat2Show = true;
                                          return Text("You do not have any pending leave to take action");
                                        }
                                        return SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: Text("Confirmed", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
                                  Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: leaveList.length,
                                      itemBuilder: (context, index) {
                                        if (leaveList[index]['category'] == 3) {
                                          Widget toReturn = Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: !cat3FirstShow ? BorderSide(width: 1, color: Colors.black12) : BorderSide.none,
                                                bottom: BorderSide(width: 1, color: Colors.black12),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "(${leaveList[index]['type']}) ${DateFormat("dd MMMM yyyy").format(leaveList[index]['leaveDate'])}",
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                                    child: Text(
                                                      leaveList[index]['name'],
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                leaveList[index]['status'] == "approved"
                                                    ? Container(
                                                        padding: EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                                          color: Color(0xFF28A745),
                                                        ),
                                                        child: Text(
                                                          "Approved",
                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                                        ),
                                                      )
                                                    : leaveList[index]['status'] == "rejected"
                                                        ? Container(
                                                            padding: EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                                              color: Color(0xFFEF5350),
                                                            ),
                                                            child: Text(
                                                              "Rejected",
                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                                            ),
                                                          )
                                                        : Container(
                                                            padding: EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Color(0xFF262626), width: 2),
                                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                                              color: Color(0xFF414141),
                                                            ),
                                                            child: Text(
                                                              "On-going",
                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                                            ),
                                                          ),
                                              ],
                                            ),
                                          );
                                          cat3FirstShow = true;
                                          return toReturn;
                                        }

                                        if (leaveList.every((element) => element['category'] != 3) && !cat3Show) {
                                          cat3Show = true;
                                          return Text("No one has applied leave before");
                                        }
                                        return SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Text("Leave application list is empty, try applying some leave!");
                          }
                        }

                        return Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: PrimaryButton(
                      color: Color(0xFF170E9A),
                      textColor: Colors.white,
                      text: "Apply Leave",
                      onClickFunction: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => LeaveApplicationApply(
                                      campaignId: campaignId,
                                      invalidDateList: invalidDateList,
                                      deadline: deadlineHour,
                                    )))
                            .then((value) {
                          if (value != null && value) {
                            setState(() {
                              getLeave();
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveApplicationApply extends StatefulWidget {
  final campaignId;
  final invalidDateList;
  final deadline;

  const LeaveApplicationApply({this.campaignId, this.invalidDateList, this.deadline});

  @override
  State<LeaveApplicationApply> createState() => _LeaveApplicationApplyState();
}

class _LeaveApplicationApplyState extends State<LeaveApplicationApply> {
  get campaignId => widget.campaignId;

  get invalidDateList => widget.invalidDateList;

  get deadline => widget.deadline;

  String leaveType = "Normal";
  DateTime initialDate = DateTime.now();
  DateTime leaveDate = DateTime.now();

  List<String> leaveList = ["Normal", "Half"];

  @override
  Widget build(BuildContext context) {
    while (invalidDateList.contains(DateTime(initialDate.year, initialDate.month, initialDate.day))) {
      initialDate = initialDate.add(Duration(days: 1));
      leaveDate = initialDate;
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeadings(
              text: "Applying Leave",
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
              popAvailable: true,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 113 - 20,
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Text(
                      "Date",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "${DateFormat.d().format(leaveDate)} ${DateFormat.MMMM().format(leaveDate)} ${leaveDate.year}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today_rounded),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2999),
                              confirmText: 'Confirm',
                              selectableDayPredicate: (DateTime val) {
                                return !invalidDateList.contains(val);
                              }).then((date) {
                            if (date != null) {
                              setState(() {
                                leaveDate = date;
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      "Leave Type",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: 45,
                    margin: EdgeInsets.only(top: 15),
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
                          isExpanded: true,
                          style: TextStyle(
                            color: Color(0xFF6E6E6E),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          value: leaveType,
                          items: leaveList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              leaveType = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  PrimaryButton(
                    color: Color(0xFF170E9A),
                    textColor: Colors.white,
                    text: "Confirm",
                    onClickFunction: () async {
                      showLoading(context);
                      CollectionReference leaveRef = FirebaseFirestore.instance.collection("CampaignData/$campaignId/LeaveApplication");

                      DateTime finalDate = DateTime(leaveDate.year, leaveDate.month, leaveDate.day, int.tryParse(deadline));

                      await leaveRef.add({
                        "userId": FirebaseAuth.instance.currentUser.uid,
                        "leaveType": leaveType,
                        "leaveDate": finalDate,
                        "approvedUser": [],
                        "rejectedUser": [],
                      });

                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
