import 'package:LCI/entity/UserData.dart';
import 'package:LCI/login.dart';
import 'package:LCI/route-animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'custom-components.dart';
import 'home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final globalKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  FocusNode focusNodePassword;
  FocusNode focusNodeCfmPassword;
  FocusNode focusNodeEmail;
  bool passwordVisible = true;

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    focusNodePassword = FocusNode();
    focusNodeEmail = FocusNode();
    focusNodeCfmPassword = FocusNode();
    focusNodePassword.addListener(() {
      setState(() {});
    });
    focusNodeEmail.addListener(() {
      setState(() {});
    });
    focusNodeCfmPassword.addListener(() {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Create New Account',
                  metaText: 'Hi, it\'s good to see you!',
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Text(
                          'Email ID',
                          style: TextStyle(
                            color: Color(0xFF878787),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InputBox(
                        focusNode: focusNodeEmail,
                        focusNodeNext: focusNodePassword,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 5),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Color(0xFF878787),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      PasswordBox(
                        focusNode: focusNodePassword,
                        focusNodeNext: focusNodeCfmPassword,
                        controller: _passwordController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            color: Color(0xFF878787),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      PasswordBox(
                        focusNode: focusNodeCfmPassword,
                        controller: _confirmPasswordController,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Text(
                        'The password must comply with:\n1. 8 to 20 characters\n2. At least one uppercase letter\n3. At least one lower case letter\n4. At least a digit\n5. At least a special character (Eg: !,@,#,\$,_)',
                        style: TextStyle(
                          color: Color(0xFF929292),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(15)),
                      PrimaryButton(
                        text: 'NEXT',
                        textColor: Colors.white,
                        color: Color(0xFF299E45),
                        onClickFunction: () {
                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                            globalKey.currentState.showSnackBar(SnackBar(content: Text('Please fill in all the credentials')));
                          } else {
                            if (_passwordController.text != _confirmPasswordController.text) {
                              globalKey.currentState.showSnackBar(SnackBar(content: Text('Password and confirm password doesn\'t match')));
                            } else {
                              final user = UserData();
                              user.email = _emailController.text;
                              user.password = _passwordController.text;
                              Navigator.of(context).push(SlideLeftRoute(previousPage: Register(), builder: (context) => RegisterDetails(user: user)));
                            }
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
      ),
    );
  }
}

class RegisterDetails extends StatefulWidget {
  final UserData user;

  RegisterDetails({this.user});

  @override
  _RegisterDetailsState createState() => _RegisterDetailsState(user: user);
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final UserData user;
  final _nameController = TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();

  _RegisterDetailsState({this.user});

  List<String> countryList = ["Malaysia", "Singapore"];
  List<String> yearList = ["1990", "2000"];
  List<String> monthList = ["January", "April", "December"];
  List<String> dayList = ["1", "2", "31"];

  String selectedGender = "Male";
  String selectedCountry = "Malaysia";
  String selectedYear = "1990";
  String selectedMonth = "January";
  String selectedDay = "1";

  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Create New Account',
                  metaText: 'Hi, it\s good to see you!',
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      PrimaryCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Your Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 30,
                              child: TextField(
                                autofocus: false,
                                maxLines: 1,
                                controller: _nameController,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB4B4B4),
                                  ),
                                  hintText: 'John',
                                  contentPadding: EdgeInsets.only(bottom: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: PrimaryCard(
                                  child: Container(
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Gender',
                                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (selectedGender == "Male" ? Colors.grey.withOpacity(0.2) : Colors.transparent),
                                                      blurRadius: 5,
                                                      spreadRadius: 2,
                                                      offset: Offset(0, 5),
                                                    ),
                                                  ],
                                                ),
                                                child: MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                  ),
                                                  onPressed: () => setState(() => selectedGender = "Male"),
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 8, bottom: 8),
                                                    child: SvgPicture.asset(
                                                      'assets/male.svg',
                                                      color: (selectedGender == "Male" ? Color(0xFF457CFE) : Color(0xFF6E6E6E)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)), boxShadow: [
                                                  BoxShadow(
                                                    color: (selectedGender == "Female" ? Colors.grey.withOpacity(0.2) : Colors.transparent),
                                                    blurRadius: 5,
                                                    spreadRadius: 2,
                                                    offset: Offset(0, 5),
                                                  ),
                                                ]),
                                                child: MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                  ),
                                                  onPressed: () => setState(() => selectedGender = "Female"),
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 8, bottom: 8),
                                                    child: SvgPicture.asset(
                                                      'assets/female.svg',
                                                      color: (selectedGender == "Female" ? Color(0xFF457CFE) : Color(0xFF6E6E6E)),
                                                    ),
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
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: PrimaryCard(
                                  child: Container(
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Country',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
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
                                                value: selectedCountry,
                                                items: countryList.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Center(child: Text(value)),
                                                  );
                                                }).toList(),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    selectedCountry = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(7.5)),
                          PrimaryCard(
                            child: Container(
                              height: 220,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Date of Birth',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Year',
                                              style: TextStyle(
                                                color: Color(0xFF6E6E6E),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Container(
                                              height: 45,
                                              width: 130,
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
                                                    value: selectedYear,
                                                    items: yearList.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Center(child: Text(value)),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String newValue) {
                                                      setState(
                                                        () {
                                                          selectedYear = newValue;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Month',
                                              style: TextStyle(
                                                color: Color(0xFF6E6E6E),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Container(
                                              height: 45,
                                              width: 130,
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
                                                    items: monthList.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Center(child: Text(value)),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String newValue) {
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
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Day',
                                              style: TextStyle(
                                                color: Color(0xFF6E6E6E),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Container(
                                              height: 45,
                                              width: 130,
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
                                                    value: selectedDay,
                                                    items: dayList.map<DropdownMenuItem<String>>((String value) {
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
                                                          selectedDay = newValue;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
                PrimaryButton(
                  text: "NEXT",
                  color: Color(0xFF299E45),
                  textColor: Colors.white,
                  onClickFunction: () {
                    if (_nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill in your name'),
                      ));
                      return;
                    } else {
                      user.name = _nameController.text;
                      user.dateOfBirth = "$selectedDay $selectedMonth $selectedYear";
                      user.gender = selectedGender;
                      user.country = selectedCountry;
                      Navigator.of(context).push(SlideLeftRoute(previousPage: RegisterDetails(), builder: (context) => RegisterTC(user: user)));
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

class RegisterTC extends StatefulWidget {
  final UserData user;

  RegisterTC({this.user});

  @override
  _RegisterTCState createState() => _RegisterTCState(user);
}

class _RegisterTCState extends State<RegisterTC> {
  final UserData user;

  _RegisterTCState(this.user);

  bool isAccept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Terms & Conditions',
                  metaText: 'Read through the terms and conditions and decide if you wan\'t to accept it.',
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryCard(),
                    Padding(
                      padding: EdgeInsets.all(7.5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('I accept the above terms & conditions.'),
                        CupertinoSwitch(
                            value: isAccept,
                            onChanged: (value) {
                              setState(() {
                                isAccept = value;
                              });
                            }),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.5),
                    ),
                    PrimaryButton(
                      text: 'NEXT',
                      textColor: Colors.white,
                      color: (isAccept ? Color(0xFF299E45) : Color(0xFFAFAFAF)),
                      onClickFunction: (isAccept
                          ? () {
                              Navigator.of(context).push(SlideLeftRoute(previousPage: RegisterTC(), builder: (context) => RegisterKnowMore(user: user)));
                            }
                          : null),
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
}

class RegisterKnowMore extends StatefulWidget {
  final UserData user;

  RegisterKnowMore({this.user});

  @override
  _RegisterKnowMoreState createState() => _RegisterKnowMoreState(user);
}

class _RegisterKnowMoreState extends State<RegisterKnowMore> {
  final UserData user;
  final _othersController = TextEditingController();

  _RegisterKnowMoreState(this.user);

  List<bool> isChecked = [false, false, false, false, false];
  List<String> questions = ['Self Improvements', 'Build Healthy Habits', 'Build a Healthy Lifestyle', 'Form a Peer Support Group', 'Others'];

  void dispose() {
    _othersController.dispose();
    super.dispose();
  }

  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Welcome, ' + user.name + '!',
                  metaText: 'Before starting, do allow us to get to know more about you.',
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'What brings you here?',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked[0],
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked[0] = value;
                                          if (isChecked.contains(true)) {
                                            isComplete = true;
                                          } else {
                                            isComplete = false;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      questions[0],
                                      style: TextStyle(
                                        color: Color(0xFF878787),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked[1],
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked[1] = value;
                                          if (isChecked.contains(true)) {
                                            isComplete = true;
                                          } else {
                                            isComplete = false;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      questions[1],
                                      style: TextStyle(
                                        color: Color(0xFF878787),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked[2],
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked[2] = value;
                                          if (isChecked.contains(true)) {
                                            isComplete = true;
                                          } else {
                                            isComplete = false;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      questions[2],
                                      style: TextStyle(
                                        color: Color(0xFF878787),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked[3],
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked[3] = value;
                                          if (isChecked.contains(true)) {
                                            isComplete = true;
                                          } else {
                                            isComplete = false;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      questions[3],
                                      style: TextStyle(
                                        color: Color(0xFF878787),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked[4],
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked[4] = value;
                                          if (isChecked.contains(true)) {
                                            isComplete = true;
                                          } else {
                                            isComplete = false;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      questions[4],
                                      style: TextStyle(
                                        color: Color(0xFF878787),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 50, right: 10),
                                  child: Container(
                                    height: 30,
                                    child: TextField(
                                      enabled: isChecked[4],
                                      autofocus: false,
                                      maxLines: 1,
                                      controller: _othersController,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF878787),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(bottom: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.5),
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.5),
                    ),
                    PrimaryButton(
                      text: 'NEXT',
                      textColor: Colors.white,
                      color: (isComplete ? Color(0xFF299E45) : Color(0xFFAFAFAF)),
                      onClickFunction: (isComplete
                          ? () {
                              Navigator.of(context).push(SlideLeftRoute(previousPage: RegisterKnowMore(user: user), builder: (context) => RegisterGrouping(user: user)));
                            }
                          : null),
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
}

class RegisterGrouping extends StatefulWidget {
  final UserData user;

  RegisterGrouping({this.user});

  @override
  _RegisterGroupingState createState() => _RegisterGroupingState(user);
}

class _RegisterGroupingState extends State<RegisterGrouping> {
  final UserData user;

  _RegisterGroupingState(this.user);

  bool isActiveSolo = false;
  bool isActiveTeam = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Welcome, ' + user.name + '!',
                  metaText: 'Now choose your path. Are you going to improve alone or with your peers?',
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2.8,
                        width: MediaQuery.of(context).size.width / 2.35,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isActiveSolo = true;
                              isActiveTeam = false;
                              user.type = "Solo";
                              Navigator.of(context).push(SlideLeftRoute(previousPage: RegisterGrouping(user: user), builder: (context) => RegisterPlan(user: user)));
                            });
                          },
                          child: PrimaryCard(
                            color: (isActiveSolo ? Color(0xFF170E9A) : Colors.white),
                            padding: EdgeInsets.all(5),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  colors: [const Color(0xff1c62d9), const Color(0xff3d65dc), const Color(0xffe774eb)],
                                  stops: [0.0, 0.126, 1.0],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    child: SvgPicture.asset(
                                      'assets/user.svg',
                                      height: 75,
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'SOLO',
                                        style: TextStyle(
                                          shadows: [
                                            Shadow(
                                              offset: Offset(3, 3),
                                              blurRadius: 5.0,
                                              color: Color.fromRGBO(0, 0, 0, 0.15),
                                            ),
                                          ],
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 2.8,
                        width: MediaQuery.of(context).size.width / 2.35,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isActiveSolo = false;
                              isActiveTeam = true;
                              user.type = "Team";
                              Navigator.of(context).push(SlideLeftRoute(previousPage: RegisterGrouping(user: user), builder: (context) => RegisterPlan(user: user)));
                            });
                          },
                          child: PrimaryCard(
                            color: (isActiveTeam ? Color(0xFF170E9A) : Colors.white),
                            padding: EdgeInsets.all(5),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  colors: [const Color(0xffef4159), const Color(0xffFFD381)],
                                  stops: [0.0, 1.0],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    child: SvgPicture.asset(
                                      'assets/user-friends.svg',
                                      height: 75,
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'TEAM',
                                        style: TextStyle(
                                          shadows: [
                                            Shadow(
                                              offset: Offset(3, 3),
                                              blurRadius: 5.0,
                                              color: Color.fromRGBO(0, 0, 0, 0.15),
                                            ),
                                          ],
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}

class RegisterPlan extends StatefulWidget {
  final UserData user;

  RegisterPlan({this.user});

  @override
  _RegisterPlanState createState() => _RegisterPlanState(user);
}

class _RegisterPlanState extends State<RegisterPlan> {
  final globalKey = GlobalKey<ScaffoldState>();
  final UserData user;

  _RegisterPlanState(this.user);

  bool isStandard = false;
  bool isPremium = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Choose Your Plan',
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  'Go Premium',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff5d88ff),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(padding: EdgeInsets.all(7.5)),
                Text(
                  'Benefits of Premium',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(padding: EdgeInsets.all(7.5)),
                Text(
                  '\u2022 Campaign Feature Unlocked',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 5),
                  child: Text(
                    'You are able to join campaigns and improve with friends together.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff5d88ff),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(7.5)),
                Text(
                  '\u2022 7 Things Suggestions',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 5),
                  child: Text(
                    'Special features to automate your 7 Things according to your goals.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff5d88ff),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(7.5)),
                Text(
                  '\u2022 Life Compass Inventory Unlocked',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 5),
                  child: Text(
                    'You are able to have a detailed analysis of your current progress towards your goals, understand more about yourself and get suggestions from our coach.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff5d88ff),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(30)),
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isStandard = true;
                        isPremium = false;
                      });
                    },
                    child: PrimaryCard(
                      color: (isStandard ? Color(0xFF170E9A) : Colors.white),
                      padding: EdgeInsets.all(5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment(-0.95, 1.0),
                            end: Alignment(0.93, -0.96),
                            colors: [const Color(0xff17438e), const Color(0xffb747bb)],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/compass.svg',
                                height: 25,
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    'STANDARD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(3, 3),
                                          blurRadius: 5.0,
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'FREE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(3, 3),
                                      blurRadius: 5.0,
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(7.5)),
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPremium = true;
                        isStandard = false;
                      });
                    },
                    child: PrimaryCard(
                      color: (isPremium ? Color(0xFF170E9A) : Colors.white),
                      padding: EdgeInsets.all(5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment(0.91, -1.29),
                            end: Alignment(-0.6, 1.41),
                            colors: [const Color(0xffe8da62), const Color(0xff9b705f)],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/crown.svg',
                                height: 25,
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    'PREMIUM',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(3, 3),
                                          blurRadius: 5.0,
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'FROM',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(3, 3),
                                          blurRadius: 5.0,
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'RM99.99/year',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(3, 3),
                                          blurRadius: 5.0,
                                          color: Color.fromRGBO(0, 0, 0, 0.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                PrimaryButton(
                  onClickFunction: () async {
                    if (isPremium) {
                      user.subscription = "Premium";
                    } else if (isStandard) {
                      user.subscription = "Standard";
                    }

                    try {
                      UserCredential uc = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There was an error occurred. ' + e.code)));
                    } finally {
                      CollectionReference userData = FirebaseFirestore.instance.collection('UserData');
                      var uid = FirebaseAuth.instance.currentUser.uid;
                      await userData
                          .doc(uid)
                          .set({
                            'name': user.name,
                            'gender': user.gender,
                            'country': user.country,
                            'dateOfBirth': user.dateOfBirth,
                            'type': user.type,
                            'subscription': user.subscription,
                          })
                          .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home())))
                          .catchError((error) => () async {
                                await FirebaseAuth.instance.currentUser.delete().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login())));
                              });
                    }
                  },
                  color: Color(0xFF5D88FF),
                  textColor: Colors.white,
                  text: 'SELECT THIS PACKAGE',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
