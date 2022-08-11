import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
          String reason = "";
          String leaveType = "";

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

          try {
            reason = doc["reason"];
          } catch (e) {
            reason = "";
          }

          if (doc['leaveType'] == "Normal" || doc['leaveType'] == "Full") {
            leaveType = "Full";
          } else {
            leaveType = "Half";
          }

          if (doc['userId'] == FirebaseAuth.instance.currentUser.uid) {
            invalidDateList.add(DateTime(doc['leaveDate'].toDate().year, doc['leaveDate'].toDate().month, doc['leaveDate'].toDate().day));
            bool allowAppeal = false;
            if (status == "rejected" && doc['leaveDate'].toDate().isAfter(DateTime.now())) {
              allowAppeal = true;
            }
            finalList.add({
              "leaveDate": doc['leaveDate'].toDate(),
              "approvedCount": doc['approvedUser'].length,
              "rejectedCount": doc['rejectedUser'].length,
              "name": "You",
              "type": leaveType,
              "reason": reason,
              "category": 1,
              "status": status,
              "allowAppeal": allowAppeal,
              "isPending": false,
              "leaveId": doc.id,
            });
          } else if (!doc['approvedUser'].contains(FirebaseAuth.instance.currentUser.uid) &&
              !doc['rejectedUser'].contains(FirebaseAuth.instance.currentUser.uid) &&
              DateTime.now().isBefore(doc['leaveDate'].toDate())) {
            finalList.add({
              "leaveDate": doc['leaveDate'].toDate(),
              "approvedCount": doc['approvedUser'].length,
              "rejectedCount": doc['rejectedUser'].length,
              "userId": doc['userId'],
              "name": nameList[doc['userId']],
              "type": leaveType,
              "reason": reason,
              "category": 2,
              "status": status,
              "allowAppeal": false,
              "isPending": true,
              "leaveId": doc.id,
            });
          } else if (doc['approvedUser'].contains(FirebaseAuth.instance.currentUser.uid) ||
              doc['rejectedUser'].contains(FirebaseAuth.instance.currentUser.uid) ||
              DateTime.now().isAfter(doc['leaveDate'].toDate())) {
            finalList.add({
              "leaveDate": doc['leaveDate'].toDate(),
              "approvedCount": doc['approvedUser'].length,
              "rejectedCount": doc['rejectedUser'].length,
              "name": nameList[doc['userId']],
              "type": leaveType,
              "reason": reason,
              "category": 3,
              "status": status,
              "allowAppeal": false,
              "isPending": false,
              "leaveId": doc.id,
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
      try {
        if (value) {
          showLoading(context);
          CollectionReference leaveRef = FirebaseFirestore.instance.collection("CampaignData/$campaignId/LeaveApplication");

          String toGetField = type == "approve" ? "approvedUser" : "rejectedUser";
          List newList = (await leaveRef.doc(leaveId).get()).get(toGetField);

          newList.add(FirebaseAuth.instance.currentUser.uid);

          await leaveRef.doc(leaveId).update({
            (type == "approve" ? "approvedUser" : "rejectedUser"): newList,
          });

          if (type != "approve") {
            Map leaveActionNotificationData = {"leaveId": leaveId, "campaignId": campaignId, "type": "reject"};
            await FirebaseFunctions.instanceFor(region: "asia-southeast1").httpsCallable('leaveActionNotification').call(leaveActionNotificationData);
          }

          DocumentSnapshot latestLeaveData = await leaveRef.doc(leaveId).get();
          DateTime toGetDate = latestLeaveData.get("leaveDate").toDate();
          toGetDate = DateTime(toGetDate.year, toGetDate.month, toGetDate.day);

          DocumentReference sevenThingsRef =
              FirebaseFirestore.instance.collection("UserData/${latestLeaveData.get("userId")}/SevenThings").doc(toGetDate.toString());

          if (latestLeaveData.get("approvedUser").length == maxUserCount) {
            DocumentSnapshot sevenThingsDoc = await sevenThingsRef.get();
            Map tempStatus;
            String leaveType = latestLeaveData.get("leaveType");
            if (sevenThingsDoc.exists) {
              try {
                tempStatus = sevenThingsDoc.get("status");
              } catch (e) {
                tempStatus = {};
              }
              tempStatus.putIfAbsent(leaveType == "Full" ? "leave" : "halfLeave", () => true);
              await sevenThingsRef.update({"status": tempStatus});
            } else {
              await sevenThingsRef.set({
                "content": {},
                "status": leaveType == "Full" ? {"leave": true} : {"halfLeave": true},
              });
            }

            Map leaveActionNotificationData = {"leaveId": leaveId, "campaignId": campaignId, "type": "approve"};
            await FirebaseFunctions.instanceFor(region: "asia-southeast1").httpsCallable('leaveActionNotification').call(leaveActionNotificationData);
          }

          Navigator.of(context).pop();
          setState(() {});
        }
      } catch (e, stackTrace) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error while confirming action: $stackTrace'),
        ));
      }
    });
  }

  void toDetails(DateTime leaveDate, String leaveType, bool allowAppeal, String reason, bool isPending, String status, int approvedCount, int maxUserCount,
      String name, String leaveId) async {
    await Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => LeaveDetails(
          leaveDate: leaveDate,
          leaveType: leaveType,
          allowAppeal: allowAppeal,
          reason: reason,
          isPending: isPending,
          status: status,
          approvedCount: approvedCount,
          maxUserCount: maxUserCount,
          campaignId: campaignId,
          name: name,
          leaveId: leaveId,
        ),
      ),
    )
        .then((value) {
      print(value);
      if (value != null && value) {
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
                                          Widget toReturn = GestureDetector(
                                            onTap: () => toDetails(
                                                leaveList[index]['leaveDate'],
                                                leaveList[index]['type'],
                                                leaveList[index]['allowAppeal'],
                                                leaveList[index]['reason'],
                                                leaveList[index]['isPending'],
                                                leaveList[index]['status'],
                                                leaveList[index]['approvedCount'],
                                                maxUserCount,
                                                leaveList[index]['name'],
                                                leaveList[index]['leaveId']),
                                            child: Container(
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
                                                    "${DateFormat("dd MMMM yyyy").format(leaveList[index]['leaveDate'])}",
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
                                                          : Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                                                  child: Text(
                                                                    "${leaveList[index]['approvedCount']}/$maxUserCount",
                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                                  ),
                                                                ),
                                                                Container(
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
                                                ],
                                              ),
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
                                          Widget toReturn = GestureDetector(
                                            onTap: () => toDetails(
                                                leaveList[index]['leaveDate'],
                                                leaveList[index]['type'],
                                                leaveList[index]['allowAppeal'],
                                                leaveList[index]['reason'],
                                                leaveList[index]['isPending'],
                                                leaveList[index]['status'],
                                                leaveList[index]['approvedCount'],
                                                maxUserCount,
                                                leaveList[index]['name'],
                                                leaveList[index]['leaveId']),
                                            child: Container(
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
                                                    "${DateFormat("dd MMMM yyyy").format(leaveList[index]['leaveDate'])}",
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
                                                  Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text(
                                                      "${leaveList[index]['approvedCount']}/$maxUserCount",
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                                          Widget toReturn = GestureDetector(
                                            onTap: () => toDetails(
                                                leaveList[index]['leaveDate'],
                                                leaveList[index]['type'],
                                                leaveList[index]['allowAppeal'],
                                                leaveList[index]['reason'],
                                                leaveList[index]['isPending'],
                                                leaveList[index]['status'],
                                                leaveList[index]['approvedCount'],
                                                maxUserCount,
                                                leaveList[index]['name'],
                                                leaveList[index]['leaveId']),
                                            child: Container(
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
                                                    "${DateFormat("dd MMMM yyyy").format(leaveList[index]['leaveDate'])}",
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
                            .push(
                          MaterialPageRoute(
                            builder: (context) => LeaveApplicationApply(
                              campaignId: campaignId,
                              invalidDateList: invalidDateList,
                              deadline: deadlineHour,
                            ),
                          ),
                        )
                            .then(
                          (value) {
                            if (value != null && value) {
                              setState(() {
                                getLeave();
                              });
                            }
                          },
                        );
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

  final reasonTextController = new TextEditingController();
  FocusNode reasonFocusNode;

  String leaveType = "Full";
  DateTime initialDate = DateTime.now();
  DateTime leaveDate = DateTime.now();

  List<String> leaveList = ["Full", "Half"];

  @override
  void initState() {
    super.initState();
    reasonFocusNode = FocusNode();
    reasonFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    while (invalidDateList.contains(DateTime(initialDate.year, initialDate.month, initialDate.day))) {
      initialDate = initialDate.add(Duration(days: 1));
      leaveDate = initialDate;
    }
    return GestureDetector(
      onTap: () => reasonFocusNode.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
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
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Text(
                          "Reason",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: InputBox(
                          focusNode: reasonFocusNode,
                          controller: reasonTextController,
                          minLines: 8,
                          maxLines: 8,
                          color: Colors.black12,
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
                          String reason = reasonTextController.text;

                          if (reason.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Do not leave Reason blank'),
                            ));
                            Navigator.of(context).pop();
                            return;
                          }

                          await leaveRef.add({
                            "userId": FirebaseAuth.instance.currentUser.uid,
                            "leaveType": leaveType,
                            "leaveDate": finalDate,
                            "approvedUser": [],
                            "rejectedUser": [],
                            "reason": reason,
                          });

                          Map leaveActionNotificationData = {
                            "campaignId": campaignId,
                            "userId": FirebaseAuth.instance.currentUser.uid,
                            "leaveDay": finalDate.day,
                            "leaveMonth": (finalDate.month - 1),
                            "leaveYear": finalDate.year
                          };
                          await FirebaseFunctions.instanceFor(region: "asia-southeast1")
                              .httpsCallable('campaignLeaveNotification')
                              .call(leaveActionNotificationData);

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
        ),
      ),
    );
  }
}

class LeaveDetails extends StatefulWidget {
  final DateTime leaveDate;
  final bool allowAppeal;
  final String reason;
  final String leaveType;
  final bool isPending;
  final String status;
  final int approvedCount;
  final int maxUserCount;
  final String campaignId;
  final String name;
  final String leaveId;

  const LeaveDetails({
    Key key,
    this.leaveDate,
    this.allowAppeal,
    this.reason,
    this.leaveType,
    this.isPending,
    this.status,
    this.approvedCount,
    this.maxUserCount,
    this.campaignId,
    this.name,
    this.leaveId,
  }) : super(key: key);

  @override
  State<LeaveDetails> createState() => _LeaveDetailsState();
}

class _LeaveDetailsState extends State<LeaveDetails> {
  get leaveDate => widget.leaveDate;

  get allowAppeal => widget.allowAppeal;

  get reason => widget.reason;

  get leaveType => widget.leaveType;

  get isPending => widget.isPending;

  get status => widget.status;

  get approvedCount => widget.approvedCount;

  get maxUserCount => widget.maxUserCount;

  get campaignId => widget.campaignId;

  get name => widget.name;

  get leaveId => widget.leaveId;

  String _status = "";
  int _approvedCount = -1;
  bool _isPending;
  bool reload = false;

  void confirmAction(String type, String name, String leaveId) {
    showDialog<bool>(
      context: context,
      builder: (c) {
        return PrimaryDialog(
          title: Text("Confirm Action"),
          content: Text(type == "appeal" ? "Are you sure you want to appeal?" : "Are you sure you want to $type this leave for $name?"),
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
      try {
        if (value) {
          CollectionReference leaveRef = FirebaseFirestore.instance.collection("CampaignData/$campaignId/LeaveApplication");
          showLoading(context);
          if (type == "appeal") {
            DocumentSnapshot leaveData = await leaveRef.doc(leaveId).get();
            Map leaveMap = leaveData.data();
            leaveMap['approvedUser'] = [];
            leaveMap['rejectedUser'] = [];
            await leaveRef.add(leaveMap);
            await leaveRef.doc(leaveId).delete();
            Navigator.of(context).pop();
            Navigator.of(context).pop(true);
          } else {
            _isPending = false;
            reload = true;

            String toGetField = type == "approve" ? "approvedUser" : "rejectedUser";
            List newList = (await leaveRef.doc(leaveId).get()).get(toGetField);

            newList.add(FirebaseAuth.instance.currentUser.uid);

            await leaveRef.doc(leaveId).update({
              (type == "approve" ? "approvedUser" : "rejectedUser"): newList,
            });

            if (type != "approve") {
              _status = "rejected";

              Map leaveActionNotificationData = {"leaveId": leaveId, "campaignId": campaignId, "type": "reject"};
              await FirebaseFunctions.instanceFor(region: "asia-southeast1").httpsCallable('leaveActionNotification').call(leaveActionNotificationData);
            } else {
              _approvedCount++;
            }

            DocumentSnapshot latestLeaveData = await leaveRef.doc(leaveId).get();
            DateTime toGetDate = latestLeaveData.get("leaveDate").toDate();
            toGetDate = DateTime(toGetDate.year, toGetDate.month, toGetDate.day);

            DocumentReference sevenThingsRef =
                FirebaseFirestore.instance.collection("UserData/${latestLeaveData.get("userId")}/SevenThings").doc(toGetDate.toString());

            if (latestLeaveData.get("approvedUser").length == maxUserCount) {
              DocumentSnapshot sevenThingsDoc = await sevenThingsRef.get();
              Map tempStatus;
              if (sevenThingsDoc.exists) {
                try {
                  tempStatus = sevenThingsDoc.get("status");
                } catch (e) {
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

              _status = "approved";

              Map leaveActionNotificationData = {"leaveId": leaveId, "campaignId": campaignId, "type": "approve"};
              await FirebaseFunctions.instanceFor(region: "asia-southeast1").httpsCallable('leaveActionNotification').call(leaveActionNotificationData);
            }

            Navigator.of(context).pop();
            setState(() {});
          }
        }
      } catch (e) {
        print('Error while confirming action: $e');
        Navigator.of(context).pop();
      }
    });
  }

  Widget build(BuildContext context) {
    String viewStatus = "";

    if (_isPending == null) {
      _isPending = isPending;
    }

    if (_status.isEmpty) {
      _status = status;
    }
    if (_approvedCount == -1) {
      _approvedCount = approvedCount;
    }

    if (_status == "approved") viewStatus = "Approved";
    if (_status == "ongoing") viewStatus = "On-going";
    if (_status == "rejected") viewStatus = "Rejected";

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(reload);
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PageHeadings(
                  text: "Leave Details",
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          "${DateFormat.d().format(widget.leaveDate)} ${DateFormat.MMMM().format(widget.leaveDate)} ${widget.leaveDate.year}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "Leave Type",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          widget.leaveType,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Text(
                          "Reason",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          widget.reason,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Text(
                          "Status",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      _status == "ongoing"
                          ? Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      viewStatus,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: Text(
                                      "${_approvedCount.toString()}/${maxUserCount.toString()} approved",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Text(
                                viewStatus,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                      allowAppeal || _isPending ? Spacer() : SizedBox.shrink(),
                      allowAppeal
                          ? PrimaryButton(
                              color: Color(0xFF170E9A),
                              textColor: Colors.white,
                              text: "Appeal",
                              onClickFunction: () => confirmAction("appeal", name, leaveId),
                            )
                          : SizedBox.shrink(),
                      _isPending
                          ? Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 4),
                                    child: PrimaryButton(
                                      color: Color(0xFF170E9A),
                                      textColor: Colors.white,
                                      text: "Approve",
                                      onClickFunction: () => confirmAction("approve", name, leaveId),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: PrimaryButton(
                                      color: Color(0xFF170E9A),
                                      textColor: Colors.white,
                                      text: "Reject",
                                      onClickFunction: () => confirmAction("reject", name, leaveId),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
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
