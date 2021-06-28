import 'package:LCI/custom-components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class SevenThingsMain extends StatefulWidget {
  _SevenThingsMainState createState() => _SevenThingsMainState();
}

class _SevenThingsMainState extends State<SevenThingsMain> {
  var ref;

  DateTime date;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Text('Something went wrong'),
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
    );
  }
}

class GetSevenThings extends StatefulWidget {
  final date;

  const GetSevenThings({this.date});

  _GetSevenThingsState createState() => _GetSevenThingsState(date: date);
}

class _GetSevenThingsState extends State<GetSevenThings> {
  final date;

  DateTime searchDate;
  DateTime toSearch;

  _GetSevenThingsState({this.date});

  Future<DateTime> getNetworkTime() async {
    DateTime _myTime;
    _myTime = await NTP.now();
    return _myTime;
  }

  @override
  void initState() {
    super.initState();
    if (date == null || date == "") {
      getNetworkTime().then((value) {
        setState(() {
          searchDate = value;
          toSearch = DateTime(searchDate.year, searchDate.month, searchDate.day);
        });
      });
    } else {
      searchDate = date;
      toSearch = DateTime(searchDate.year, searchDate.month, searchDate.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference sevenThingsRef = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('SevenThings');
    return FutureBuilder<DocumentSnapshot>(
      future: sevenThingsRef.doc(toSearch.toString()).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return SevenThings(date: searchDate);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return SevenThings(
            sevenThings: data,
            date: searchDate,
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class SevenThings extends StatefulWidget {
  final sevenThings;
  final date;

  const SevenThings({this.sevenThings, this.date});

  _SevenThingsState createState() => _SevenThingsState(sevenThings: sevenThings, date: date);
}

class _SevenThingsState extends State<SevenThings> {
  Map<String, dynamic> sevenThings;
  DateTime date;

  _SevenThingsState({this.sevenThings, this.date});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var tempSevenThingsType;
  var newSevenThings;

  List<String> suggestions = <String>[];

  var editable = true;
  var showEmpty = false;

  var _newSevenThingsController = TextEditingController();
  var _editSevenThingsController = TextEditingController();

  final _editForm = GlobalKey<FormState>();

  Future<List<String>> getSuggestions() async {
    return await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('Goals').get().then((value) {
      var goal = value.docs.last.data();
      var result = <String>[];
      goal.forEach((key, value) {
        if (key != 'targetLCI') {
          if (value['selected']) {
            if (sevenThings[value['q3']] == null) {
              result.add(value['q3']);
            }
          }
        }
      });
      return result;
    });
  }

  @override
  void initState() {
    super.initState();
    getSuggestions().then((value) {
      setState(() {
        suggestions = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser.uid).collection('SevenThings');

    Future<void> updateSevenThings() {
      var toChange = date;
      return user.doc(DateTime(toChange.year, toChange.month, toChange.day).toString()).set(sevenThings).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('There was an error inserting the item, please try again.'),
          )));
    }

    Future<void> sevenThingsTypeSelectionDialog() {
      return showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return PrimaryDialog(
            title: Text('Select a type'),
            content: Text('Which type do you wan\'t this item to be assigned to ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  tempSevenThingsType = "Primary";
                  Navigator.of(context).pop();
                },
                child: Text('Primary'),
              ),
              TextButton(
                onPressed: () {
                  tempSevenThingsType = "Secondary";
                  Navigator.of(context).pop();
                },
                child: Text('Secondary'),
              ),
            ],
          );
        },
      );
    }

    Future<void> addSevenThingsDialog() {
      return showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return PrimaryDialog(
            title: Text('Add Seven Things'),
            content: TextField(
              controller: _newSevenThingsController,
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              decoration: InputDecoration(
                errorText: showEmpty ? 'Do not leave it blank' : null,
                hintText: 'Enter something here',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (_newSevenThingsController.text != "") {
                    tempSevenThingsType = "Primary";
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      showEmpty = true;
                    });
                  }
                },
                child: Text('Primary'),
              ),
              TextButton(
                onPressed: () {
                  if (_newSevenThingsController.text != "") {
                    tempSevenThingsType = "Secondary";
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      showEmpty = true;
                    });
                  }
                },
                child: Text('Secondary'),
              ),
            ],
          );
        },
      );
    }

    Future<void> editSevenThing(String current) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return PrimaryDialog(
            title: Text('Edit Seven Things'),
            content: Form(
              key: _editForm,
              child: TextFormField(
                controller: _editSevenThingsController..text = current,
                style: TextStyle(fontSize: 16),
                maxLines: 1,
                decoration: InputDecoration(
                  errorText: showEmpty ? 'Do not leave it blank' : null,
                  hintText: 'Enter something here',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Do not leave it blank';
                  } else {
                    if (current != value) {
                      if (sevenThings[value] != null) {
                        return 'Duplicate seven things entered';
                      }
                    }
                  }
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (_editForm.currentState.validate()) {
                    var temp = sevenThings[current];
                    setState(() {
                      sevenThings.remove(current);
                      sevenThings[_editSevenThingsController.text] = temp;
                      updateSevenThings();
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Confirm'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    arrangeSevenThings() {
      Map<String, dynamic> primary = {};
      Map<String, dynamic> secondary = {};
      sevenThings.forEach((key, value) {
        if (value['type'] == 'Primary') {
          primary[key] = sevenThings[key];
        } else {
          secondary[key] = sevenThings[key];
        }
      });
      primary.addAll(secondary);
      setState(() {
        sevenThings = primary;
      });
    }

    if (sevenThings != null) {
      arrangeSevenThings();
    }

    DateTime selectedDate = date;

    if (selectedDate == null) {
      selectedDate = DateTime.now();
    }

    Map<String, DateTime> getThisWeek() {
      DateTime firstDayOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      Map<String, DateTime> result = {
        'MON': firstDayOfWeek,
        'TUE': firstDayOfWeek.add(Duration(days: 1)),
        'WED': firstDayOfWeek.add(Duration(days: 2)),
        'THU': firstDayOfWeek.add(Duration(days: 3)),
        'FRI': firstDayOfWeek.add(Duration(days: 4)),
        'SAT': firstDayOfWeek.add(Duration(days: 5)),
        'SUN': firstDayOfWeek.add(Duration(days: 6)),
      };
      return result;
    }

    getProgress() {
      if (sevenThings != null) {
        var progress = 0.0;
        sevenThings.forEach((key, value) {
          if (value['status']) {
            progress++;
          }
        });
        progress = progress / 7;
        return progress;
      } else {
        return 0.0;
      }
    }

    var progressPercent = getProgress();

    final Map<String, DateTime> thisWeek = getThisWeek();
    var format = DateFormat('MMMM');
    String thisMonth = format.format(selectedDate);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Your 7 Things',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      selectedDate.year == DateTime.now().year && selectedDate.day == DateTime.now().day && selectedDate.month == DateTime.now().month
                          ? "TODAY"
                          : DateFormat('dd MMMM yyyy').format(selectedDate).toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF878787),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(7.5)),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2050),
                          confirmText: 'Confirm',
                        ).then((date) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetSevenThings(date: date))));
                      },
                      child: TextWithIcon(
                        assetPath: 'assets/calendar.svg',
                        text: thisMonth,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < thisWeek.length; i++)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, a1, a2) => GetSevenThings(date: thisWeek.entries.elementAt(i).value),
                                    transitionDuration: Duration(seconds: 0),
                                  ));
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: thisWeek.entries.elementAt(i).value.day == selectedDate.day
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                      color: Color(0xFF170E9A),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    thisWeek.entries.elementAt(i).key,
                                    style: TextStyle(
                                      color: thisWeek.entries.elementAt(i).value.day == selectedDate.day ? Colors.white : Color(0xFFAFAFAF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    thisWeek.entries.elementAt(i).value.day.toString(),
                                    style: TextStyle(
                                      color: thisWeek.entries.elementAt(i).value.day == selectedDate.day ? Colors.white : Color(0xFFAFAFAF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '7 Things Progress',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        Text(
                          (progressPercent * 100).toStringAsFixed(2) + '%',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    RoundedLinearProgress(
                      value: progressPercent,
                      color: Color(0xFF170E9A),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    PrimaryCard(
                      padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWithIcon(
                                assetPath: 'assets/tasks.svg',
                                text: 'Your 7 Things List',
                              ),
                              ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      await addSevenThingsDialog();
                                      var countPrimary = 0;
                                      var countSecondary = 0;
                                      if (sevenThings != null) {
                                        sevenThings.values.forEach((element) {
                                          if (element['type'] == "Primary") {
                                            countPrimary++;
                                          } else {
                                            countSecondary++;
                                          }
                                        });
                                      }
                                      if (countPrimary == 3 && tempSevenThingsType == "Primary") {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('You already have 3 Primary Things'),
                                          ),
                                        );
                                        return;
                                      } else if (countSecondary == 4 && tempSevenThingsType == "Secondary") {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('You already have 4 Secondary Things'),
                                          ),
                                        );
                                        return;
                                      }
                                      if (_newSevenThingsController.text != "" && tempSevenThingsType != null) {
                                        var addClientComplete = false;
                                        setState(
                                          () {
                                            if (sevenThings != null) {
                                              if (!sevenThings.containsKey(_newSevenThingsController.text) && sevenThings.length < 7) {
                                                if (sevenThings[suggestions] != null) {
                                                  sevenThings[_newSevenThingsController.text]['status'] = false;
                                                  sevenThings[_newSevenThingsController.text]['type'] = tempSevenThingsType;
                                                } else {
                                                  sevenThings[_newSevenThingsController.text] = {"status": false, "type": tempSevenThingsType};
                                                }
                                                addClientComplete = true;
                                                suggestions.remove(_newSevenThingsController.text);
                                              } else {
                                                var message = "";
                                                if (sevenThings.length == 7) {
                                                  message = "Your 7 things list is full, remove something and try again.";
                                                } else {
                                                  message = 'Your 7 things list contains the same item.';
                                                }
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(message),
                                                  ),
                                                );
                                              }
                                            } else {
                                              suggestions.remove(_newSevenThingsController.text);
                                              sevenThings = {
                                                _newSevenThingsController.text: {"status": false, "source": "Suggested", "type": tempSevenThingsType}
                                              };
                                              addClientComplete = true;
                                            }
                                            if (addClientComplete) {
                                              updateSevenThings();
                                              tempSevenThingsType = null;
                                              _newSevenThingsController.text = "";
                                            }
                                          },
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: SvgPicture.asset(
                                        'assets/plus.svg',
                                        height: 18,
                                        width: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          sevenThings != null && sevenThings.length > 0
                              ? Column(
                                  children: sevenThings.keys.map((key) {
                                    return GestureDetector(
                                      onLongPress: () {
                                        editSevenThing(key);
                                      },
                                      onTap: () {
                                        setState(() {
                                          sevenThings[key]['status'] = !sevenThings[key]['status'];
                                          updateSevenThings();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        decoration: sevenThings[key]['type'] == 'Primary'
                                            ? BoxDecoration(
                                                color: Color(0xFFF2F2F2),
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              )
                                            : BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: Checkbox(
                                                    activeColor: Color(0xFFF48A1D),
                                                    checkColor: Colors.white,
                                                    value: sevenThings[key]['status'],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        sevenThings[key]['status'] = value;
                                                        progressPercent = getProgress();
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(7.5)),
                                                Text(
                                                  key,
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                              ],
                                            ),
                                            ClipOval(
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(7.5),
                                                    child: SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: SvgPicture.asset(
                                                        'assets/close.svg',
                                                        color: Color(0xFF878787),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      if (sevenThings[key]['source'] == "Suggested") {
                                                        suggestions.add(key);
                                                      }
                                                      sevenThings.remove(key);
                                                      updateSevenThings();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Text(
                                  'You have ' + (sevenThings == null ? '0' : sevenThings.length.toString()) + '/7 items in the list.',
                                  style: TextStyle(color: Color(0xFF878787), fontSize: 14),
                                ),
                          Padding(padding: EdgeInsets.all(5)),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    PrimaryCard(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextWithIcon(
                            assetPath: 'assets/lightbulb.svg',
                            text: '7 Things Suggestions',
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          suggestions != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (var suggestion in suggestions)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            suggestion.toString(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          ClipOval(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: SvgPicture.asset(
                                                      'assets/plus.svg',
                                                      color: Color(0xFF878787),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  var addClientComplete = false;
                                                  await sevenThingsTypeSelectionDialog();
                                                  if (tempSevenThingsType != null) {
                                                    setState(
                                                      () {
                                                        if (sevenThings != null) {
                                                          if (!sevenThings.containsKey(suggestion) && sevenThings.length < 7) {
                                                            if (sevenThings[suggestions] != null) {
                                                              sevenThings[suggestion]['status'] = false;
                                                              sevenThings[suggestion]['type'] = tempSevenThingsType;
                                                            } else {
                                                              sevenThings[suggestion] = {"status": false, "source": "Suggested", "type": tempSevenThingsType};
                                                            }
                                                            addClientComplete = true;
                                                            suggestions.remove(suggestion);
                                                          } else {
                                                            var message = "";
                                                            if (sevenThings.length == 7) {
                                                              message = "Your 7 things list is full, remove something and try again.";
                                                            } else {
                                                              message = 'Your 7 things list contains the same item.';
                                                            }
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text(message),
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          suggestions.remove(suggestion);
                                                          sevenThings = {
                                                            suggestion: {"status": false, "source": "Suggested", "type": tempSevenThingsType}
                                                          };
                                                          addClientComplete = true;
                                                        }
                                                        if (addClientComplete) {
                                                          updateSevenThings();
                                                          tempSevenThingsType = null;
                                                        }
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
