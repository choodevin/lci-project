import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class InputBox extends StatelessWidget {
  final FocusNode focusNode;
  final FocusNode focusNodeNext;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;

  const InputBox({
    this.focusNode,
    this.focusNodeNext,
    this.controller,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 10,
  });

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(90 / minLines)),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(color: (focusNode.hasFocus ? Color(0xFFB9B9B9) : Colors.transparent), blurRadius: (focusNode.hasFocus ? 3 : 0)),
        ],
      ),
      child: TextField(
        minLines: minLines,
        maxLines: maxLines,
        obscureText: false,
        focusNode: focusNode,
        controller: controller,
        onEditingComplete: () => (focusNodeNext != null ? FocusScope.of(context).requestFocus(focusNodeNext) : FocusScope.of(context).unfocus()),
        style: TextStyle(
          fontSize: 18,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          fillColor: Color(0xFFF2F2F2),
          filled: true,
          hintStyle: TextStyle(
            color: Color(0xFFB4B4B4),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90 / minLines)),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90 / minLines)),
            borderSide: BorderSide(
              color: Color(0xFFF7DABFB),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordBox extends StatefulWidget {
  final FocusNode focusNode;
  final FocusNode focusNodeNext;
  final TextEditingController controller;

  const PasswordBox({
    this.focusNode,
    this.focusNodeNext,
    this.controller,
  });

  @override
  _PasswordBoxState createState() => _PasswordBoxState(focusNode, focusNodeNext, controller);
}

class _PasswordBoxState extends State<PasswordBox> {
  final FocusNode focusNode;
  final FocusNode focusNodeNext;
  final TextEditingController controller;
  bool passwordVisible = true;

  _PasswordBoxState(this.focusNode, this.focusNodeNext, this.controller);

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(90)),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(color: (focusNode.hasFocus ? Color(0xFFB9B9B9) : Colors.transparent), blurRadius: (focusNode.hasFocus ? 3 : 0)),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(
          fontSize: 18,
        ),
        obscureText: passwordVisible,
        onEditingComplete: () => (focusNodeNext != null ? FocusScope.of(context).requestFocus(focusNodeNext) : FocusScope.of(context).unfocus()),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
          fillColor: Color(0xFFF2F2F2),
          filled: true,
          hintStyle: TextStyle(
            color: Color(0xFFB4B4B4),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90)),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90)),
            borderSide: BorderSide(
              color: Color(0xFFF7DABFB),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              this.setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      return '$user';
    }

    return null;
  }

  Widget build(BuildContext build) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      elevation: 1,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        elevation: 3,
        padding: EdgeInsets.only(top: 11.0, bottom: 11.0),
        onPressed: () async {
          await signInWithGoogle().then((result) => {
                if (result != null) {Navigator.pushReplacement(build, MaterialPageRoute(builder: (build) => Home()))}
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Image(
                image: AssetImage('assets/google_sign_in.png'),
                height: 26,
              ),
            ),
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(0, 0, 0, 0.54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacebookSignInButton extends StatelessWidget {
  Widget build(BuildContext build) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      elevation: 1,
      color: Color(0xFF1877f2),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        elevation: 3,
        padding: EdgeInsets.only(top: 11.0, bottom: 11.0),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image(
                image: AssetImage('assets/facebook_sign_in.png'),
                height: 26,
              ),
            ),
            Text(
              'Continue with Facebook',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function onClickFunction;

  PrimaryButton({this.onClickFunction, this.text = "Sample Text", this.color = Colors.white, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      elevation: 1,
      color: color,
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        onPressed: onClickFunction,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class PrimaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderSide borderSide;

  PrimaryCard({
    this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 15, 20, 15),
    this.color = const Color(0xFFFFFFFF),
    this.borderSide = BorderSide.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class ClickablePrimaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderSide borderSide;
  final Function onClickFunction;

  ClickablePrimaryCard({
    this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 15, 20, 15),
    this.color = const Color(0xFFFFFFFF),
    this.borderSide = BorderSide.none,
    this.onClickFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onClickFunction,
        child: PrimaryCard(padding: padding, child: child),
      ),
    );
  }
}

class PageHeadings extends StatelessWidget {
  final String text;
  final String metaText;

  PageHeadings({this.text = "", this.metaText = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        ),
        Padding(
          padding: EdgeInsets.all(3),
        ),
        Text(
          metaText,
          style: TextStyle(
            color: Color(0xFF878787),
          ),
        ),
      ],
    );
  }
}

class TextWithIcon extends StatelessWidget {
  final String assetPath;
  final double assetHeight;
  final String text;
  final TextStyle textStyle;
  final Color assetColor;

  TextWithIcon(
      {this.assetPath,
      this.text,
      this.textStyle = const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
      this.assetHeight = 22,
      this.assetColor = const Color(0xFF000000)});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          assetPath,
          height: assetHeight,
          color: assetColor,
        ),
        Padding(padding: EdgeInsets.all(4)),
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}

class RoundedLinearProgress extends StatelessWidget {
  final double value;
  final Color color;

  RoundedLinearProgress({this.value = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.12),
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: LinearProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: Color(0xFFCDCDCD),
        ),
      ),
    );
  }
}

class MultiColorProgressBar extends StatelessWidget {
  final double valueOne;
  final double valueTwo;
  final Color colorOne;
  final Color colorTwo;

  MultiColorProgressBar(this.valueOne, this.valueTwo, this.colorOne, this.colorTwo);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.12),
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: 12,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: SizedBox(
              height: 12,
              child: LinearProgressIndicator(
                value: valueTwo,
                valueColor: AlwaysStoppedAnimation<Color>(colorTwo),
                backgroundColor: Color(0xFFCDCDCD),
              ),
            ),
          ),
          SizedBox(
            height: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: valueOne,
                valueColor: AlwaysStoppedAnimation<Color>(colorOne),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnlockPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white),
                bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.white),
              ),
              gradient: LinearGradient(
                begin: Alignment(0.91, -1.29),
                end: Alignment(-0.6, 1.41),
                colors: [const Color(0xffe8da62), const Color(0xff9b705f)],
                stops: [0.0, 1.0],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/crown.svg',
                  height: 24,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  'UNLOCK PREMIUM',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GoalSelection extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final bool value;
  final String assetPath;
  final Function(bool) callBack;

  const GoalSelection({this.title, this.description, this.color, this.value, this.assetPath, this.callBack});

  _GoalSelectionState createState() => _GoalSelectionState(title, description, color, value, assetPath, callBack);
}

class _GoalSelectionState extends State<GoalSelection> {
  final String title;
  final String description;
  final Color color;
  final String assetPath;
  Function(bool) callBack;
  bool value;

  _GoalSelectionState(this.title, this.description, this.color, this.value, this.assetPath, this.callBack);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            value = !value;
          });
          callBack(value);
        },
        child: Column(
          children: [
            Row(
              children: [
                Theme(
                  child: Checkbox(
                    checkColor: Colors.white,
                    activeColor: color,
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value;
                      });
                      callBack(value);
                    },
                  ),
                  data: ThemeData(
                    unselectedWidgetColor: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                SvgPicture.asset(
                  assetPath,
                  color: color,
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                description,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomStatusBar extends StatelessWidget {
  final String text;

  const CustomStatusBar({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65,
      padding: EdgeInsets.only(left: 15, right: 20),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA), width: 1))),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/back.svg',
                    height: 22,
                    width: 22,
                  )),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Text(
              text,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
