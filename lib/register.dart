import 'package:LCI/entity/UserData.dart';
import 'package:LCI/login.dart';
import 'package:LCI/route-animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'custom-components.dart';
import 'home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeadings(
                text: 'Create New Account',
                metaText: 'Hi, it\'s good to see you!',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 35),
                child: Container(
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
                        'Password must be at least 6 characters',
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all the credentials')));
                          } else {
                            if (_passwordController.text != _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password and confirm password does not match')));
                            } else {
                              if (_passwordController.text.length >= 6) {
                                final user = UserData();
                                user.email = _emailController.text;
                                user.password = _passwordController.text;
                                FirebaseAuth.instance.fetchSignInMethodsForEmail(_emailController.text).then((value) {
                                  if(value.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account exists, please login or reset your password.')));
                                  } else {
                                    Navigator.of(context).push(SlideLeftRoute(previousPage: Register(), builder: (context) => RegisterDetails(user: user)));
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password must be at least 6 characters')));
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterDetails extends StatefulWidget {
  final UserData user;
  final sso;

  RegisterDetails({this.user, this.sso});

  @override
  _RegisterDetailsState createState() => _RegisterDetailsState(user, sso);
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final UserData user;
  final sso;
  final _nameController = TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();

  String selectedGender = "Male";
  String selectedCountry = "Malaysia";
  String selectedYear = "1990";
  String selectedMonth = "January";
  String selectedDay = "1";

  _RegisterDetailsState(this.user, this.sso);

  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> generateYearList() {
      List<String> result = <String>[];
      var now = DateTime.now();
      for (var i = 1950; i <= now.year; i++) {
        result.add(i.toString());
      }
      return result;
    }

    List<String> yearList = generateYearList();
    List<String> countryList = ["Malaysia", "Singapore"];
    List<String> monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    List<String> generateDayList() {
      List<String> result = <String>[];
      var month = DateFormat('MMM')
          .parse(selectedMonth)
          .month;
      var totalDays = DateUtils.getDaysInMonth(int.parse(selectedYear), month);
      for (var i = 1; i <= totalDays; i++) {
        result.add(i.toString());
      }
      return result;
    }

    List<String> dayList = generateDayList();

    Widget content() {
      return Scaffold(
        key: globalKey,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                PageHeadings(
                  text: 'Create New Account',
                  metaText: 'Hi, it\s good to see you!',
                  popAvailable: true,
                ),
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery
                        .of(context)
                        .size
                        .height - MediaQuery
                        .of(context)
                        .padding
                        .top - MediaQuery
                        .of(context)
                        .padding
                        .bottom,
                  ),
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
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
                                      textCapitalization: TextCapitalization.words,
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
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.5,
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
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.3,
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
              ],
            ),
          ),
        ),
      );
    }

    if (sso != null && sso) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
          return true;
        },
        child: content(),
      );
    } else {
      return content();
    }
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

  var termsOfUse = "REVISION:14 JUNE 2021\n \n1. USE OF THE SERVICE\n \nIMPORTANT – PLEASE READ THESE TERMS CAREFULLY. BY USING THIS PLATFORM OR SERVICE , YOU AGREE THAT YOU HAVE READ, UNDERSTOOD, ACCEPTED AND AGREED WITH THESE TERMS OF USE. IN ORDER TO USE THE PLATFORM OR SERVICE YOU MUST AGREE TO THE TERMS OF USE THAT ARE SET OUT BELOW. YOU FURTHER AGREE TO THE REPRESENTATIONS MADE BY YOURSELF BELOW. IF YOU DO NOT AGREE TO THE TERMS OF USE, PLEASE DO NOT CONTINUE USING THIS SERVICE OR PLATFORM.\n \nThe Terms of Use stated herein (collectively, the “Terms of Use” or this “Agreement”) constitute a legally binding agreement between you and 4WARD Life Compass (“we”, “us” or the “Company”).\n \nThe Company operates the Platform /website and mobile applications called “4ward Life Compass” with links to these Terms of Use (collectively, the “Platform” or “4ward Life Compass”). The Company enables users to have guided digital coaching via audio and visual modules, and messaging with coaches with or without relative qualification in improving life quality (collectively, the “Service”). The Company also provides access to third party articles and videos (collectively, the “Service”) of which, all third-party trademarks, service marks, logos and domain names appearing on the Platform are the property of their respective owners. None of these companies or individuals endorse, sponsor, represent or are in any way affiliated with the Company.\n \nFor the avoidance of doubt, the Company does not provide personal physical coaching that guarantees beneficial outcomes. The Company is not a health services organization or forum. The Company does not practise medicine or any other licensed profession, and does not interfere with the practice of coaches or other licensed professions, and the use of the Services or Platform does not create a permanent relationship. The company does not hold responsibilities of your wellbeing and wellness before you choose to adopt any module program, coaching session and courses, whether offered on this platform  or otherwise. \n\nNone of the content on the Platform should be used outside of the platform and for other purposes that is not stated in the platform. The content of Service and Platform is solely applicable within the usage of the platform and recognized coaches. \n \nBy using the Platform, and downloading, installing or using any associated software or application supplied by the Company (collectively, the “Software”), you hereby expressly acknowledge and agree to be bound by the Terms of Use, and any future amendments and additions to these Terms of Use as published from time to time at /website.\n \nThe Company reserves the right to modify, vary and change the Terms of Use or its policies relating to the Platform or Service without prior notice at any time as it deems fit. Such modifications, variations and or changes to the Terms of Use or its policies relating to the Platform/Service shall be effective upon the posting of an updated version at /website as may be updated and revised by us from time to time.\n \nYou agree that it shall be your responsibility to review the Terms of Use regularly. The continued use of the Platform or Service after any such changes, whether or not reviewed by you, shall constitute your consent and acceptance to such changes.\n \n2. CONSENT\n \n4ward Life Compass is a digital coaching platform which provides modules and coaching services on individual life goals. The service is intended to pair with coaches guidance for full utilization. The Company also enables users to interact using messaging communication technology where the users and the coaches are at different physical locations.\n \n \n3. REPRESENTATIONS AND WARRANTIES\n \nBy using the Service and/or registering an account, you expressly represent and warrant that you are legally entitled to accept and agree to the Terms of Use and that you are at least eighteen (18) years old. If you are below eighteen (18) years old, you must seek express consent from your legal guardian such as your parent or legal guardian and they must consent to the use of the Platform and/or Service. \n \nBy using the Service, you further represent and warrant that you have the right, authority and capacity to use the Service and to abide by the Terms of Use (or to do so on behalf of a minor child of whom you are a parent or legal guardian). You further confirm that all the information which you provide shall be true, accurate and complete. Your use of the Service is for your own sole, personal use (or that of your minor child for whom you are a parent/legal guardian). You undertake not to authorize others to use your identity or account, and you may not assign or otherwise transfer your account to any other person or entity.\n \n4. ACCESS RIGHTS AND REGISTRATION OF ACCOUNT\n \nSubject to you complying with these Terms of Use and the registration requirements, we grant to you a limited, non-exclusive, non-transferable right to access the Platform and use the Services solely for your personal non-commercial use and only as permitted under these Terms of Use and any separate agreements you may have entered into with us (“Access Rights”). We reserve the right, in our sole discretion, to deny or suspend use of the Platform or Services to anyone for any reason.\n \nYou agree that you will not, and will not attempt to:\n \n-		\nimpersonate any person or entity, or otherwise misrepresent your affiliation with a person or entity;\n 	\n-		\nuse the Platform or Services to violate any applicable law, regulations or guidelines;\n 	\n-		\nreverse engineer, disassemble, decompile, or translate any software or other components of the Platform or Services;\n 	\n-		\ndistribute viruses or other harmful computer code through the Platform or\n 	\n-		\notherwise use the Services or Platform in any manner that exceeds the scope of use granted above. In addition, you agree to refrain from abusive language when communicating with coaches  through the Platform. 4ward Life Compass is not responsible for any interactions with coaches as the Company is unable to view the conversation between the users and coaches. \n 	\n \nIn order to access certain Services through this Platform you need to register an account. You agree to provide accurate and complete information when you register and to keep that information updated and accurate. When registering an account, you shall not use as an account name the name of another person with the intent to impersonate that person. We reserve the right to refuse registration of an account or cancel it at our discretion.\n \nYou are solely responsible for all activities occurring through your account and you agree to inform us of any actual or threatened breach of your account. We are not responsible for any loss or damage arising from any breach of these obligations.\n \n5. PAYMENT AND REFUNDS\n  \nIf you purchase any product or services on 4ward Life Compass, you agree to pay all fees and charges (including all applicable SST) in accordance with the applicable fees, charges and payment terms.\n \nYou may choose to pay for the Service by any of the payment methods available at the Platform, including without limitation through the specified payment gateways.\n \nBy providing the required payment or payment information, you agree that we may invoice all fees and charges due and the payment will be processed automatically at the end of the session or upon the provision of the Services.\n \nWe reserve the right to suspend the processing of any transaction where we reasonably believe that the transaction may be fraudulent, illegal or involve any criminal activity or where we reasonably believe you to be in breach of the Terms of Use.\n \nYou shall be responsible for any finance or other charges imposed by your payment provider (such as credit card provider or financial institution) and to resolve any disputes with your payment provider (such as your credit card company) on your own.\n \nWe reserve the right to make changes to the fees and charges from time to time without advance notice.\n \nNo refunds are available for any Services (or part of Services) which have been provided or when the request has been confirmed or accepted by the Company. Refunds are only available when the request is cancelled by you before it is confirmed or accepted by the Company, or it is cancelled by the Company. Instead of a refund, you may use your credit for other Services (such as a session or other Services offered by the Company), subject to the prevailing terms and conditions.\n \n6. INTELLECTUAL PROPERTY\n \nThe Company and its licensors and providers, where applicable, shall own all right, title and interest, including all related intellectual property rights, in and to the Platform and all its contents, including without limitation the Software, text, materials, compilation of information, images, videos, displays, audio and design and any suggestions, ideas, enhancement requests, feedback, recommendations or other information provided by you or any other party relating to the Service or Platform.\n \nThe Terms of Use do not constitute a sale agreement and do not convey to you any rights of ownership in or related to the Service or any intellectual property rights owned by the Company and/or its licensors. The Company name, the Company logo, and certain other material on the Platform constitute trade marks or other intellectual property rights of the Company or its licensors/providers or other parties and no right or license is granted to use them. \n \n7. TERMINATION\n \nYou may deactivate your account and end your registration at any time for any reason. The Company may suspend or terminate your use of the Platform, your account and/or registration for any reason at any time. Without prejudice to the generality of the foregoing, you hereby agree that the Company is entitled to terminate this Terms of Use immediately in the event that you are in breach of any of the terms. For the avoidance of doubt, the termination shall not require the Company to compensate, reimburse or cover any costs, fees or expenses incurred by you in connection with the use of the Platform and/or Services.\n \nFollowing termination or deactivation, you will not have further access to your account or the Services. In the case of termination/deactivation by us, you remain liable for all amounts due up to and including the date of termination/deactivation.\n \nUpon termination, the following Sections shall continue in force: Sections, 2, 3, 6, 9, 10, 11, 12 and any other provisions of these Terms of Use that are intended to continue in force after termination.\n \n8. DISCLAIMER OF WARRANTIES\n \nYou expressly agree that use of the Platform and/or Services is at your sole risk. Both the Platform and Services are provided on an “AS IS” and “AS AVAILABLE” basis. We do not warrant that access to this Platform will be uninterrupted or error-free or that defects in the Platform will be corrected. The Company and/or 4ward Life Compass expressly disclaims all warranties of any kind, whether express or implied, including, but not limited to any warranties or merchantability, fitness for a particular use or purpose, non-infringement, title, operability, condition, quiet enjoyment, value and accuracy of data.\n \nYou acknowledge and agree that the coaches using the Platform are solely responsible for and will have complete authority, responsibility, supervision, and control over the provision of all services, advice, and they provide the same in their sole discretion and as they deem appropriate.\n \nYou agree that you and your coach are solely responsible for all information and communication using the 4ward Life Compass messaging Platform or other communication and we do not guarantee that messaging is the appropriate course of advice or suggestion for your particular issue including but not limited to life goals. \nWe make no representation, warranty or endorsement as to the conduct, ability, efficacy, accuracy, timeliness or relevance of any information, service or treatment provided by any coach and you agree that your interactions with such coaches and professionals are at your own risk and you agree to take reasonable precautions in all such interactions.\n \nThere are potential risks associated with the use of 4ward Life Compass. These risks include, but may not be limited to:\n \n·       Information transmitted may not be sufficient (e.g. lack of disclosure by the user) to allow for appropriate decision making or advice given by the coach\n \n·       Delays in evaluation or treatment could occur due to failures of the electronic equipment or communication networks. If this happens, you agree that you may be contacted by phone or other means of communication.\n \n·       A lack of full access to all your personal information or health records may result in wrong advice or other judgment errors in rare cases.\n \n·       Security protocols could fail, causing a breach of privacy of personal information.\n \n We reserve the right at our discretion, to remove any coach or User from our Platform or the Platform at any time if any coach or User fails to maintain a certain code of conduct or rating that we impose to such coach from time to time\n \nBy using the Service, you further understand, agree and acknowledge that you have the following rights with respect to the use of our Platform and the limitations of our messaging services and other services as follows:\n \n·       4ward Life Compass may not be able to serve all your coaching needs. \n  \n·       You hereby give consent to engage in secure messaging on our 4ward Life Compass App with our coaches.\n \n·       You understand and acknowledge that messaging based services and care may not be as complete as face-to-face consultation. You also understand that if your coach believes you would be better served a face-to-face consultation, you would be advised as such.\n \n  \n9. LIMITATION OF LIABILITY\n \nYOU UNDERSTAND THAT TO THE EXTENT PERMITTED UNDER APPLICABLE LAW, IN NO EVENT WILL THE COMPANY OR 4WARD LIFE COMPASS OR ITS OFFICERS, EMPLOYEES, DIRECTORS, PARENTS, SUBSIDIARIES, AFFILIATES, AGENTS OR LICENSORS BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR EXEMPLARY DAMAGES, INCLUDING BUT NOT LIMITED TO, DAMAGES FOR LOSS OF REVENUES, PROFITS, GOODWILL, USE, DATA OR OTHER INTANGIBLE LOSSES ARISING OUT OF OR RELATED TO YOUR USE OF THE PLATFORM OR THE SERVICES, REGARDLESS OF WHETHER SUCH DAMAGES ARE BASED ON CONTRACT, TORT (INCLUDING NEGLIGENCE AND STRICT LIABILITY), WARRANTY, STATUTE OR OTHERWISE RELATING IN ANY WAY TO THE PLATFORM, SERVICES, ANY INFORMATION OR MATERIALS ON OR OBTAINED THROUGH THE PLATFORM. In no event shall our total liability to you (or for any minor for whom you are responsible for) for any and all damages, losses, costs, expenses and fees exceed the amount you have paid to us. To the extent that we may not, as a matter of applicable law, disclaim any implied warranty or limit our liabilities, the scope and duration of such warranty and the extent of our liability will be the minimum permitted under such applicable law.\n \n10. INDEMNITY\n \nYou agree to indemnify, defend and hold harmless the Company, its officers, directors, employees, agents, representatives, subsidiaries, affiliates, licensors, partners and suppliers, harmless from and against any claim, actions, demands, liabilities, costs, expenses and settlements, including without limitation reasonable legal and accounting fees (“Claims”), resulting from, or alleged to result from, any use of the Platform, Services and/or Software or any breach of these Terms of Use. In addition, you agree to indemnify, defend and hold harmless your coach(es) from and against any third party claims resulting from your lack of adherence with the advice or recommendation(s) of the coach(es) or any breach of these Terms of Use.\n \n11. PERSONAL DATA PROTECTION\n \nYou agree and consent to the Company using and processing your Personal Data for the Purposes and in the manner as set out in our Privacy Policy and outlined below.\n \nFor the purposes of this Agreement, “Personal Data” means information about you, from which you are identifiable, including but not limited to your email address and phone number which you have provided to the Company in registration forms, application forms or any other similar forms and/or any information about you that has been or may be collected, stored, used and processed by the Company from time to time and includes sensitive personal data such as data relating to health, religious or other similar beliefs.\n \nThe provision of your Personal Data is voluntary. However if you do not provide the Company your Personal Data, the Company may not be able to process your Personal Data for the Purposes outlined below and may cause the Company to be unable to allow you to use the Service or the Platform.\n \nThe Company may use and process your Personal Data for business and activities of the Company which shall include, without limitation the following (collectively referred to as the “Purpose”):\n \n·       To perform the Company’s obligations in respect of any contract entered into with you;\n·       To provide you with any services pursuant to the Terms of Use herein;\n·       Process, manage or verify your application/registration for the Service pursuant to the Terms of Use herein;\n·       To validate and/or process payments pursuant to the Terms of Use herein;\n·       To develop, enhance and provide what is required pursuant to the Terms of Use herein to meet your needs;\n·       To process any refunds, rebates and or charges pursuant to the Terms of Use herein;\n·       To facilitate or enable any checks as may be required pursuant to the Terms of Use herein;\n·       To respond to questions, comments and feedback from you;\n·       To communicate with you for any of the purposes listed herein;\n·       For internal administrative purposes, such as auditing, data analysis, database records;\n·       For purposes of detection, prevention and prosecution of crime;\n·       For the Company to comply with its obligations under law.\n \nAs the Company’s information technology storage facilities and servers may be located in other jurisdictions, your Personal Data may be transferred to, stored, used and processed in a jurisdiction other than Malaysia provided the location has an equivalent or similar data protection laws as Malaysia.\n \nThe Company may engage other companies, service providers or individuals to perform functions on the Company’s behalf, and consequently may provide access or disclose to your Personal Data to the third parties including but not limited to those listed below:\n \n·  Information technology (IT) service providers;\n·  Data entry service providers;\n·  Storage facility providers;\n·  Insurance providers;\n·  Any professional advisors and external auditors;\n·  Regulatory and governmental authorities in order to comply with statutory and government requirements.\n·  coaches and support personnel.\n \nSubject to any exceptions under applicable laws, you may at any time hereafter request for access to, or for correction or rectification of your Personal Data or limit the processing of your Personal Data, or seek further information from the Company by using the support contact details provided on the Platform.\n \nBy submitting your information you consent to the use of that information as set out in the form of submission/registration and in this Terms of Use.\n \n12. GENERAL\n \nThis Agreement shall be governed by Malaysian law, without regard to the choice or conflicts of law provisions of any jurisdiction, and any disputes, actions, claims or causes of action arising out of or in connection with the Terms of Use or the Service shall be subject to the exclusive jurisdiction of the courts of Malaysia to which you hereby agree to submit to.\n \nNo joint venture, partnership, employment, or agency relationship exists between you, the Company or any third party provider as a result of the Terms of Use or use of the Service.\n \nIf any provision of the Terms of Use is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall be enforced to the fullest extent under law.\n \nThe failure of the Company to enforce any right or provision in the Terms of Use shall not constitute a waiver of such right or provision unless acknowledged and agreed to by the Company in writing.\n \nThe Terms of Use comprises the entire agreement between you and the Company and supersedes all prior or contemporaneous negotiations or discussions, whether written or oral (if any) between the parties regarding the subject matter contained herein.\n \n\n";
  var privacyPolicy = "REVISION: 14 JUNE 2021\n\n  4Ward Life Compass ('4ward life compass,' or “Company”) respects your privacy and is committed to protecting it through this privacy policy (the 'Privacy Policy'). The Company operates the Platform and mobile applications called “4ward life compass - Support & Motivate” and “4ward life compass - coaches” with links to these Terms of Use (collectively, the “Platform” or “4ward life compass”).\n\n  As a user of this Platform or our services, this privacy policy (“Policy”) outlines what information we may collect about you, how we use and share that information, how you may access your information and your choices about the use and disclosure of your information.\n\n  Collection of Personal Information\n\n  We may collect personal information which relates to an individual and who is identifiable from that information, such as personal details (including your age, gender, phone number, email address) or any information which you have provided in registration/application forms or any other similar forms and/or any information about you that has been or may be collected, stored, used and processed by 4ward life compass from time to time. In addition, we may from time to time request certain other personal information which may be relevant for the purposes of providing our services to you. If you provide any personal information relating to a minor, you warrant that you are the parent or legal guardian of such minor and have the necessary authority to provide such information and the applicable consents.\n\n  While the provision of personal information is not obligatory, it is required in connection with the purposes as stated below, and if we do not have this information we may not be able to carry out the purposes or provide our services to you.\n\n  Cookies, analytics and automatic collection of information\n\n  The Company does not collect cookies through its Platform. Your preferences are obtained through information that you have disclosed. These information will be used for analysis purposes to help us improve the user experience. We may use and disclose aggregated and anonymised statistics about usage of this Platform or our services. If you enrol via an employer, general aggregated data and engagement information will be shared with your employer.\n\n  Use of Personal Information\n\n  We may use your personal information for any of the following reasons:\n\n  ·           To provide services or to perform any of the Company’s obligations towards you\n  ·           To process, manage or verify your request or application for any services\n  ·           To validate and/or process payments, rebates, refunds and charges\n  ·           To send you alerts, updates, mailers, promotional materials and the like from the Company, our partners, advertisers or sponsors and to communicate with you about services/products that may be of interest to you from us, partners or other third parties\n  ·           To facilitate or enable any checks as may be required\n  ·           To manage our business and for internal purposes (such as auditing, data analysis, database records, evaluating our services and effectiveness of our marketing efforts, research and risk management)\n  ·           To comply with legal and regulatory requirements\n  ·           To enforce our legal rights or obtain legal advice\n  ·           To perform functions described at the time of collection of the personal information\n  ·           To respond to questions, comments and feedback from you\n  ·           To communicate with you for any of the purposes listed in this Policy\n  ·           For any other purpose that is ancillary to or in furtherance of these above purposes or which is required by law or any regulatory authorities or where we have your permission to do so\n\n  In connection with the above use of your personal information, we may disclose such personal information to the following:\n  ·           Demographics for coaches to work with.\n  Third Party Platforms or providers\n\n  Through the Platform and/or the services, you may obtain access to certain third parties such as coaches, professionals or providers and other portals or applications. The privacy policies/personal data protection notices of such third parties are independent from that of 4ward life compass’s and you should review such policies/notices carefully as the use of information disclosed to such third parties is subject to such policies/notices.\n\n  Our Platform may contain links to and from the portals, apps or resources of our partners, advertisers and other third parties. If you follow a link to or access any of these webPlatforms or resources, please note that they have their own privacy policies/data protection notices and terms of use which you should review. We do not accept any responsibility or liability for these webPlatforms or resources and your access and use of them is at your own risk.\n\n  Chat policy\n\n  The Company provides a chat service where users are able to connect and chat with coaches. The Company has a 24-hour chat storage policy, however it does not process the conversations. After 24-hours, messages will not be available on the cloud storage but may be available on the device from where it was sent to or from.\n\n  Opting out\n\n  You have the option to opt-out of receiving marketing communications from us and selected third parties and limiting the distribution of your personal information. You can do so by contacting us via the contact details below or so far as applicable, by accessing your registration/account with us or by clicking on the 'unsubscribe' link in certain electronic communications we may send to you. When we receive your request to opt-out from receiving marketing communication, it may take up to fourteen (14) working days for your opt-out to be updated in our records and systems. Accordingly, you may still receive marketing communication during this short period of time. Kindly be reminded that even if you opt-out from receiving marketing communication, we may still contact you for other purposes in relation to the transactions between us or the services you have requested from us.\n\n  Protection of Personal Data\n\n  We take the necessary security and technical measures to protect the security and confidentiality of personal data in compliance with applicable law. The transmission of payment information (such as credit card and account numbers) is protected through the use of encryption such as SSL (Secure Socket Layer) protection.\n\n  Checking and Updating Your Details and Passwords\n\n  If you wish to access, verify or correct any of your personal information, you may do so by contacting us via the contact details below. Our security procedures mean that we may request proof of identity before we reveal information or carry out the requests. This proof of identity may take the form of your username/e-mail address and password submitted upon registration (so far as applicable). Therefore, you should keep this information safe as you will be responsible for any action which we take in response to a request from someone using your username/e-mail and password. If you have an account with us, you can also update your personal information by accessing your account. You undertake to keep safe and not disclose to third parties, your account information, including passwords. We are not responsible for any misuse or disclosure of access information or passwords. Please contact us if any of your personal data subsequently becomes outdated, inaccurate or incomplete to help ensure the accuracy of the data in our records.\n\n  Changes to the Policy\n\n  We reserve the right to modify and change this Policy from time to time, without prior notice. Any changes to this Policy will be published at this Platform and your continued use of the Platform or our services will constitute your acceptance of the modified Policy.\n\n  General\n\n  If there are any inconsistencies between this Policy and the terms and conditions of the services we provide to you, the latter shall prevail.\n\n  Contacting Us\n\n  If you wish to contact us, you have any questions about this Privacy Policy or if you would like us to stop or limit the use/processing of your personal information, please contact us via our website /website or email /email\n\n  ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: 'Terms & Conditions',
                metaText: 'Read through the terms and conditions and decide if you wan\'t to accept it.',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryCard(
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height - 350,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Terms of Use',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text(
                                    termsOfUse,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF707070),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text(
                                    privacyPolicy,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF707070),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
            ],
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
          child: Column(
            children: [
              PageHeadings(
                text: 'Welcome, ' + user.name + '!',
                metaText: 'Before starting, do allow us to get to know more about you.',
                popAvailable: true,
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery
                      .of(context)
                      .size
                      .height - MediaQuery
                      .of(context)
                      .padding
                      .top - MediaQuery
                      .of(context)
                      .padding
                      .bottom,
                ),
                padding: EdgeInsets.fromLTRB(25, 20, 25, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                            Navigator.of(context).push(SlideLeftRoute(previousPage: RegisterKnowMore(user: user), builder: (context) => RegisterPlan(user: user)));
                          }
                              : null),
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
          child: Column(
            children: [
              PageHeadings(
                text: 'Choose Your Plan',
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                          user.subscription = "Premium";
                        }

                        try {
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There was an error occurred. ' + e.code)));
                        } finally {
                          CollectionReference userData = FirebaseFirestore.instance.collection('UserData');
                          var uid = FirebaseAuth.instance.currentUser.uid;
                          await userData.doc(uid).set({
                            'name': user.name,
                            'gender': user.gender,
                            'country': user.country,
                            'dateOfBirth': user.dateOfBirth,
                            'subscription': user.subscription,
                            'viewedGoals' : false,
                            'viewedCampaign' : false,
                            'viewedHome' : false,
                            'viewedLCI' : false,
                            'viewedSevenThings' : false,
                            'viewedWheelOfLife' : false,
                          }).then((value) {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetUserData()));
                          }).catchError((error) =>
                              () async {
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
            ],
          ),
        ),
      ),
    );
  }
}
