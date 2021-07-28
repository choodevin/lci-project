import 'dart:convert';

import 'package:LCI/custom-components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'entity/Video.dart';

class SevenThingsMain extends StatefulWidget {
  final date;

  const SevenThingsMain({Key key, this.date}) : super(key: key);

  _SevenThingsMainState createState() => _SevenThingsMainState(date);
}

class _SevenThingsMainState extends State<SevenThingsMain> {
  final DateTime date;

  _SevenThingsMainState(this.date);

  DateTime selectedDate;
  DateTime startDate = FirebaseAuth.instance.currentUser.metadata.creationTime;
  DateTime initialDate;
  DateTime endingDate;
  int daysBetween;
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  GetSevenThingList sevenThingList;
  Function recallFunction;
  Function addCallBack;

  var isEdit = false;

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

  @override
  void initState() {
    super.initState();
    if (date == null) {
      getNetworkTime().then((value) {
        setState(() {
          selectedDate = DateTime(value.year, value.month, value.day);
          initialDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 7);
          endingDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 7);
          daysBetween = endingDate.difference(initialDate).inDays;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _itemScrollController.jumpTo(index: (daysBetween / 2).ceil(), alignment: 0.44);
            await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) async {
              if (!value.get('viewedSevenThings')) {
                infoVideo();
                await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({
                  "viewedSevenThings": true,
                });
              }
            });
          });
        });
      });
    } else {
      selectedDate = date;
      initialDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 7);
      endingDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 7);
      daysBetween = endingDate.difference(initialDate).inDays;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _itemScrollController.jumpTo(index: (daysBetween / 2).ceil(), alignment: 0.44);
        await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) async {
          if (!value.get('viewedSevenThings')) {
            infoVideo();
            await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).update({
              "viewedSevenThings": true,
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Function editingCallBack = (value, recall) {
      setState(() {
        isEdit = value;
        recallFunction = recall;
      });
    };

    Function addCallBack = (recall) {
      setState(() {
        recallFunction = recall;
      });
    };

    Future<bool> showSaveChanges() {
      return showDialog(
          context: context,
          builder: (builder) {
            return PrimaryDialog(
              title: Text("You have unsaved changes"),
              content: Text("Are you sure you want to leave without saving ?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Leave", style: TextStyle(color: Color(0xFFFF0000))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          });
    }

    return selectedDate != null
        ? WillPopScope(
            onWillPop: () async {
              if (isEdit) {
                showSaveChanges().then((value) {
                    if(value) {
                      Navigator.of(context).pop();
                    }
                });
              }
              return true;
            },
            child: Scaffold(
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    child: isEdit ? SvgPicture.asset('assets/check.svg', color: Colors.white, height: 16, width: 16) : SvgPicture.asset('assets/plus.svg', color: Colors.white, height: 16, width: 16),
                    backgroundColor: isEdit ? Color(0xFF299E45) : Color(0xFF170E9A),
                    onPressed: isEdit
                        ? () {
                            recallFunction(0);
                          }
                        : () {
                            recallFunction();
                          },
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PageHeadings(
                        text: '7 Things',
                        popAvailable: true,
                        padding: EdgeInsets.fromLTRB(5, 20, 20, 0),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime(2050),
                                  confirmText: 'Confirm',
                                ).then((date) {
                                  if (date != null) {
                                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => SevenThingsMain(date: date),
                                      transitionDuration: Duration(seconds: 0),
                                    ));
                                    editingCallBack(false);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  "${DateFormat.MMMM().format(selectedDate)} ${selectedDate.year}".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                    color: Color(0xFF707070),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 66,
                              child: ScrollablePositionedList.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: daysBetween,
                                itemBuilder: (c, i) {
                                  var toGet = DateTime(initialDate.year, initialDate.month, initialDate.day + i);
                                  var selected = false;
                                  if (toGet.compareTo(selectedDate) == 0) {
                                    selected = true;
                                  }
                                  return GestureDetector(
                                    onTap: !selected
                                        ? () {
                                            setState(() {
                                              selectedDate = toGet;
                                            });
                                            editingCallBack(false, null);
                                          }
                                        : () {},
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                                      margin: EdgeInsets.fromLTRB(6, 0, 6, 15),
                                      decoration: selected
                                          ? BoxDecoration(
                                              color: Color(0xFF170E9A),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(0, 0, 0, 0.24),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            )
                                          : BoxDecoration(),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            toGet.day.toString(),
                                            style: TextStyle(
                                              color: selected ? Colors.white : Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('EEE').format(toGet).toString().toUpperCase(),
                                            style: TextStyle(
                                              color: selected ? Colors.white : Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemScrollController: _itemScrollController,
                                itemPositionsListener: _itemPositionsListener,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
                              child: Container(
                                child: GetSevenThingList(date: selectedDate, key: Key(selectedDate.toString()), editingCallBack: editingCallBack, addCallBack: addCallBack),
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
          )
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class GetSevenThingList extends StatefulWidget {
  final date;
  final editingCallBack;
  final addCallBack;

  const GetSevenThingList({Key key, this.date, this.editingCallBack, this.addCallBack}) : super(key: key);

  _GetSevenThingListState createState() => _GetSevenThingListState(date, editingCallBack, addCallBack);
}

class _GetSevenThingListState extends State<GetSevenThingList> {
  final date;
  final editingCallBack;
  final addCallBack;

  _GetSevenThingListState(this.date, this.editingCallBack, this.addCallBack);

  Map<String, dynamic> content;

  var ref;
  var gRef;

  @override
  void initState() {
    super.initState();
    ref = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('SevenThings').doc(date.toString()).get();
    gRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('Goals').doc(date.toString()).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text("Something went wrong, please try again"),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> sevenThings = snapshot.data.data();
          return SevenThingList(sevenThings: sevenThings, editingCallBack: editingCallBack, date: date, addCallBack: addCallBack);
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class SevenThingList extends StatefulWidget {
  final sevenThings;
  final editingCallBack;
  final addCallBack;
  final date;

  const SevenThingList({Key key, this.sevenThings, this.editingCallBack, this.date, this.addCallBack}) : super(key: key);

  _SevenThingListState createState() => _SevenThingListState(sevenThings, editingCallBack, date, addCallBack);
}

class _SevenThingListState extends State<SevenThingList> {
  Map<String, dynamic> sevenThings;
  final editingCallBack;
  final addCallBack;
  final date;

  _SevenThingListState(this.sevenThings, this.editingCallBack, this.date, this.addCallBack);

  var contentOrder = [];
  var state = Status.NORMAL;
  var gRef;

  TextEditingController _newSevenThings = new TextEditingController();

  getProgress() {
    if (sevenThings != null) {
      var progress = 0.0;
      contentOrder.forEach((element) {
        if (element.isNotEmpty) {
          if (sevenThings['content'][element]['status']) {
            if (contentOrder.indexOf(element) < 3) {
              progress += 2;
            } else {
              progress++;
            }
          }
        }
      });
      progress = progress / 10;
      return progress;
    } else {
      return 0.0;
    }
  }

  var progressPercent;

  @override
  void initState() {
    super.initState();
    gRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection("Goals").get();
    if (sevenThings == null || sevenThings['content'] == null || sevenThings['content'].length == 0) {
      progressPercent = 0.0;
      contentOrder = ["", "", "", "", "", "", ""];
      sevenThings = {
        "content": {},
        "status": {},
      };
    } else {
      if (sevenThings['status']['lockEdit'] != null) {
        if (sevenThings['status']['lockEdit']) {
          state = Status.LOCK_EDIT;
        }
      }

      if (sevenThings['status']['locked'] != null) {
        if (sevenThings['status']['locked']) {
          state = Status.LOCK;
        }
      }

      if (sevenThings['contentOrder'] != null) {
        contentOrder = sevenThings['contentOrder'];
      } else {
        var primaryCounter = 0;
        var secondaryCounter = 0;

        sevenThings['content'].forEach((k, v) {
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

        sevenThings['content'].forEach((k, v) {
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

      progressPercent = getProgress();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addCallBack(() async {
        if (state == Status.NORMAL) {
          if (contentOrder.contains("")) {
            showDialog<String>(
              context: context,
              builder: (c) {
                return PrimaryDialog(
                  title: Text('Add Seven Things'),
                  content: TextField(
                    controller: _newSevenThings,
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Enter something here',
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        if (_newSevenThings.text.isNotEmpty) {
                          Navigator.of(context).pop(_newSevenThings.text);
                        }
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                );
              },
            ).then((value) async {
              if (value != null) {
                showLoading(context);
                var type;
                if (contentOrder.contains(value)) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things consist of the same item")));
                } else {
                  sevenThings['contentOrder'] = contentOrder;
                  for (var i = 0; i < contentOrder.length; i++) {
                    var k = contentOrder[i];
                    if (i > 3) {
                      type = "Secondary";
                    } else {
                      type = "Primary";
                    }
                    if (k.isEmpty) {
                      setState(() {
                        contentOrder[i] = value;
                        if (sevenThings['content'] == null) {
                          sevenThings = {
                            "content": {},
                            "status": {},
                          };
                          sevenThings['content'][value] = {
                            "status": false,
                            "type": type,
                          };
                          sevenThings['content'] = sevenThings['content'];
                        } else {
                          sevenThings['content'][value] = {
                            "status": false,
                            "type": type,
                          };
                        }
                      });
                      break;
                    }
                  }
                  await FirebaseFirestore.instance.doc("UserData/" + FirebaseAuth.instance.currentUser.uid + "/SevenThings/" + date.toString() + "/").set(sevenThings).then((value) {
                    Navigator.of(context).pop();
                    _newSevenThings.text = "";
                    progressPercent = getProgress();
                  }).catchError((error) {
                    print(error);
                    Navigator.of(context).pop();
                    _newSevenThings.text = "";
                  });
                }
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things list is full")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things list is now locked")));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var addCallBackFunction = () async {
      if (state == Status.NORMAL) {
        if (contentOrder.contains("")) {
          showDialog<String>(
            context: context,
            builder: (c) {
              return PrimaryDialog(
                title: Text('Add Seven Things'),
                content: TextField(
                  controller: _newSevenThings,
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Enter something here',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (_newSevenThings.text.isNotEmpty) {
                        Navigator.of(context).pop(_newSevenThings.text);
                      }
                    },
                    child: Text('Confirm'),
                  ),
                ],
              );
            },
          ).then((value) async {
            if (value != null) {
              showLoading(context);
              var type;
              if (contentOrder.contains(value)) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things consist of the same item")));
              } else {
                sevenThings['contentOrder'] = contentOrder;
                for (var i = 0; i < contentOrder.length; i++) {
                  var k = contentOrder[i];
                  if (i > 3) {
                    type = "Secondary";
                  } else {
                    type = "Primary";
                  }
                  if (k.isEmpty) {
                    setState(() {
                      contentOrder[i] = value;
                      if (sevenThings['content'] == null) {
                        sevenThings = {
                          "content": {},
                          "status": {},
                        };
                        sevenThings['content'][value] = {
                          "status": false,
                          "type": type,
                        };
                        sevenThings['content'] = sevenThings['content'];
                      } else {
                        sevenThings['content'][value] = {
                          "status": false,
                          "type": type,
                        };
                      }
                    });
                    break;
                  }
                }
                await FirebaseFirestore.instance.doc("UserData/" + FirebaseAuth.instance.currentUser.uid + "/SevenThings/" + date.toString() + "/").set(sevenThings).then((value) {
                  Navigator.of(context).pop();
                  _newSevenThings.text = "";
                  progressPercent = getProgress();
                }).catchError((error) {
                  print(error);
                  Navigator.of(context).pop();
                  _newSevenThings.text = "";
                });
              }
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things list is full")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things list is now locked")));
      }
    };

    Function recallFunction = (type) async {
      if (type == 0) {
        showLoading(context);
        var newContent = new Map<String, dynamic>();
        sevenThings['contentOrder'] = contentOrder;
        for (var i = 0; i < contentOrder.length; i++) {
          var k = contentOrder[i];
          if (k.isNotEmpty) {
            newContent[k] = sevenThings['content'][k];
            if (i < 3) {
              newContent[k]['type'] = "Primary";
            } else {
              newContent[k]['type'] = "Secondary";
            }
          }
        }
        await FirebaseFirestore.instance.doc("UserData/" + FirebaseAuth.instance.currentUser.uid + "/SevenThings/" + date.toString() + "/").set(sevenThings).then((value) {
          Navigator.of(context).pop();
          progressPercent = getProgress();
        }).catchError((error) {
          print(error);
          Navigator.of(context).pop();
        });
        editingCallBack(false, () {});
        addCallBack(addCallBackFunction);
      }
    };

    popEdit() {
      editingCallBack(true, recallFunction);
    }

    Future<dynamic> showEditDelete(String key) {
      _newSevenThings.text = key;
      return showDialog<dynamic>(
        context: context,
        builder: (c) {
          return PrimaryDialog(
            title: Text("Edit Seven Things"),
            content: TextField(
              controller: _newSevenThings,
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Enter something here',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
                child: Text('Delete', style: TextStyle(color: Color(0xFFFF0000))),
              ),
              TextButton(
                onPressed: () {
                  if (_newSevenThings.text.isNotEmpty) {
                    Navigator.of(context).pop(_newSevenThings.text);
                  }
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    return Column(
      children: [
        sevenThings != null && sevenThings['content'] != null
            ? PrimaryCard(
                child: Column(
                  children: [
                    TextWithIcon(
                      assetPath: 'assets/tasks.svg',
                      text: 'Your 7 Things List',
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '7 Things Progress',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Text(
                          (progressPercent * 100).toStringAsFixed(2) + '%',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    RoundedLinearProgress(
                      value: progressPercent,
                      color: Color(0xFF170E9A),
                    ),
                    Padding(padding: EdgeInsets.all(7.5)),
                    ReorderableListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      buildDefaultDragHandles: false,
                      physics: PageScrollPhysics(),
                      children: [
                        for (int i = 0; i < contentOrder.length; i++)
                          Container(
                            key: Key(i.toString()),
                            child: contentOrder[i].isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(color: i < 3 ? Color(0xFFF2F2F2) : Colors.transparent),
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: contentOrder[i].isNotEmpty
                                                ? () {
                                                    if (state != Status.LOCK) {
                                                      setState(() {
                                                        sevenThings['content'][contentOrder[i]]['status'] = !sevenThings['content'][contentOrder[i]]['status'];
                                                      });
                                                      popEdit();
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things list is now locked")));
                                                    }
                                                  }
                                                : () {},
                                            onLongPress: contentOrder[i].isNotEmpty && state == Status.NORMAL
                                                ? () async {
                                                    await showEditDelete(contentOrder[i]).then((value) async {
                                                      if (value != null && value != contentOrder[i]) {
                                                        showLoading(context);
                                                        if (value != 0) {
                                                          var occurrence = 0;
                                                          for (var s in contentOrder) {
                                                            if (s == value) {
                                                              occurrence++;
                                                            }
                                                          }
                                                          if (occurrence > 1) {
                                                            Navigator.of(context).pop();
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things consist of the same item")));
                                                          } else {
                                                            setState(() {
                                                              var details = sevenThings['content'][contentOrder[i]];
                                                              sevenThings['content'].remove(contentOrder[i]);
                                                              sevenThings['content'][value] = details;
                                                              contentOrder[i] = value;
                                                              sevenThings['content'][value] = details;
                                                            });
                                                            await FirebaseFirestore.instance
                                                                .doc("UserData/" + FirebaseAuth.instance.currentUser.uid + "/SevenThings/" + date.toString() + "/")
                                                                .set(sevenThings)
                                                                .then((value) {
                                                              Navigator.of(context).pop();
                                                              _newSevenThings.text = "";
                                                            }).catchError((error) {
                                                              print(error);
                                                              Navigator.of(context).pop();
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            sevenThings['content'].remove(contentOrder[i]);
                                                            contentOrder[i] = "";
                                                            sevenThings['contentOrder'] = contentOrder;
                                                          });
                                                          _newSevenThings.text = "";
                                                          await FirebaseFirestore.instance
                                                              .doc("UserData/" + FirebaseAuth.instance.currentUser.uid + "/SevenThings/" + date.toString() + "/")
                                                              .set(sevenThings)
                                                              .then((value) {
                                                            Navigator.of(context).pop();
                                                            _newSevenThings.text = "";
                                                          }).catchError((error) {
                                                            print(error);
                                                            Navigator.of(context).pop();
                                                          });
                                                        }
                                                      }
                                                    });
                                                  }
                                                : () {},
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: Checkbox(
                                                    activeColor: Color(0xFFF48A1D),
                                                    checkColor: Colors.white,
                                                    value: sevenThings['content'][contentOrder[i]]['status'],
                                                    onChanged: (value) {
                                                      if (state != Status.LOCK) {
                                                        setState(() {
                                                          sevenThings['content'][contentOrder[i]]['status'] = !sevenThings['content'][contentOrder[i]]['status'];
                                                        });
                                                        popEdit();
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things list is now locked")));
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(7.5)),
                                                Flexible(
                                                  child: Text(
                                                    contentOrder[i],
                                                    style: TextStyle(fontSize: 17),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        state == Status.NORMAL
                                            ? Expanded(
                                                flex: 1,
                                                child: ReorderableDragStartListener(
                                                  index: i,
                                                  child: ClipOval(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        child: Padding(
                                                          padding: EdgeInsets.all(7.5),
                                                          child: SizedBox(
                                                            width: 16,
                                                            height: 16,
                                                            child: SvgPicture.asset('assets/grip-lines.svg', color: Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 32,
                                              ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(color: i < 3 ? Color(0xFFF2F2F2) : Colors.transparent),
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            value: null,
                                            activeColor: Color(0xFFB6B6B6),
                                            onChanged: (v) {},
                                            tristate: true,
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(7.5)),
                                        Text(
                                          "Empty",
                                          style: TextStyle(fontSize: 16, color: Color(0xFF929292)),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                      ],
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final String item = contentOrder.removeAt(oldIndex);
                          contentOrder.insert(newIndex, item);
                        });
                        popEdit();
                      },
                    ),
                  ],
                ),
              )
            : PrimaryCard(
                child: Column(
                  children: [
                    TextWithIcon(
                      assetPath: 'assets/tasks.svg',
                      text: 'Your 7 Things List',
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Text("No 7 things set"),
                    ),
                  ],
                ),
              ),
        Padding(padding: EdgeInsets.all(20)),
        state == Status.NORMAL
            ? PrimaryCard(
                child: Column(
                  children: [
                    TextWithIcon(
                      assetPath: 'assets/light-bulb.svg',
                      text: '7 Things Suggestions',
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    FutureBuilder(
                      future: gRef,
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding: EdgeInsets.all(30),
                            child: Text("No 7 things set"),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data != null && snapshot.data.docs.length > 0) {
                            Map<String, dynamic> goals = snapshot.data.docs.last.data();
                            var toShow = [];
                            goals.forEach((k, v) {
                              if (k != 'targetLCI') {
                                if (v['selected']) {
                                  toShow.add(v['q3']);
                                }
                              }
                            });
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: toShow.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        toShow[index],
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _newSevenThings.text = toShow[index];
                                        if (contentOrder.contains("")) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (c) {
                                              return PrimaryDialog(
                                                title: Text('Add Seven Things'),
                                                content: TextField(
                                                  controller: _newSevenThings,
                                                  style: TextStyle(fontSize: 16),
                                                  maxLines: 1,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  decoration: InputDecoration(
                                                    hintText: 'Enter something here',
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      if (_newSevenThings.text.isNotEmpty) {
                                                        Navigator.of(context).pop(_newSevenThings.text);
                                                      }
                                                    },
                                                    child: Text('Confirm'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).then((value) async {
                                            if (value != null) {
                                              showLoading(context);
                                              var type;
                                              if (contentOrder.contains(value)) {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things consist of the same item")));
                                              } else {
                                                for (var i = 0; i < contentOrder.length; i++) {
                                                  var k = contentOrder[i];
                                                  if (i > 3) {
                                                    type = "Secondary";
                                                  } else {
                                                    type = "Primary";
                                                  }
                                                  if (k.isEmpty) {
                                                    setState(() {
                                                      contentOrder[i] = value;
                                                      if (sevenThings == null || sevenThings['content'] == null) {
                                                        sevenThings = {
                                                          "content": {},
                                                          "status": {},
                                                        };
                                                        sevenThings['content'][value] = {
                                                          "status": false,
                                                          "type": type,
                                                        };
                                                        sevenThings['content'] = sevenThings['content'];
                                                      } else {
                                                        sevenThings['content'][value] = {
                                                          "status": false,
                                                          "type": type,
                                                        };
                                                      }
                                                    });
                                                    break;
                                                  }
                                                }
                                                await FirebaseFirestore.instance
                                                    .doc("UserData/" + FirebaseAuth.instance.currentUser.uid + "/SevenThings/" + date.toString() + "/")
                                                    .set(sevenThings)
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                  _newSevenThings.text = "";
                                                  progressPercent = getProgress();
                                                }).catchError((error) {
                                                  print(error);
                                                  Navigator.of(context).pop();
                                                  _newSevenThings.text = "";
                                                });
                                              }
                                            }
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your seven things list is full")));
                                        }
                                      },
                                      child: Text(
                                        'Add',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.all(30),
                              child: Text("No goals set"),
                            );
                          }
                        }

                        return Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
        Padding(padding: EdgeInsets.all(30)),
      ],
    );
  }
}

enum Status {
  LOCK_EDIT,
  LOCK,
  NORMAL,
}
