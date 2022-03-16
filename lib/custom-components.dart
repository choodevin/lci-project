import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/services.dart';

import 'entity/Video.dart';
import 'home.dart';

class InputBox extends StatelessWidget {
  final FocusNode focusNode;
  final FocusNode? focusNodeNext;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int minLines;
  final int maxLines;
  final BorderRadiusGeometry? borderRadius;
  final TextAlign textAlign;
  final bool readOnly;
  final Color color;
  final String? hint;
  final Function(String)? onChanged;

  const InputBox({
    required this.focusNode,
    this.focusNodeNext,
    required this.controller,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
    this.borderRadius,
    this.textAlign = TextAlign.left,
    this.readOnly = false,
    this.color = Colors.transparent,
    this.hint,
    this.onChanged,
  });

  Widget build(BuildContext context) {
    var bRadius;

    if (borderRadius == null) {
      bRadius = BorderRadius.all(Radius.circular(90 / minLines));
    } else {
      bRadius = borderRadius;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: bRadius,
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(color: (focusNode.hasFocus ? Color(0xFFB9B9B9) : Colors.transparent), blurRadius: (focusNode.hasFocus ? 3 : 0)),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        minLines: minLines,
        maxLines: maxLines,
        obscureText: false,
        focusNode: focusNode,
        controller: controller,
        textAlign: textAlign,
        readOnly: readOnly,
        autofocus: false,
        enabled: !readOnly,
        enableInteractiveSelection: !readOnly,
        textCapitalization: TextCapitalization.sentences,
        onEditingComplete: () => (focusNodeNext != null ? FocusScope.of(context).requestFocus(focusNodeNext) : FocusScope.of(context).unfocus()),
        style: TextStyle(
          fontSize: 18,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          fillColor: color == Colors.transparent ? Color(0xFFF2F2F2) : Colors.white,
          filled: true,
          hintText: hint != null ? hint : "",
          hintStyle: TextStyle(
            color: color,
            fontSize: 14,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: bRadius,
              borderSide: BorderSide(
                color: color,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: bRadius,
            borderSide: BorderSide(
              color: color == Colors.transparent ? Color(0xFFF7DABFB) : color,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordBox extends StatefulWidget {
  final FocusNode? focusNode;
  final FocusNode? focusNodeNext;
  final TextEditingController? controller;

  const PasswordBox({
    this.focusNode,
    this.focusNodeNext,
    this.controller,
  });

  @override
  _PasswordBoxState createState() => _PasswordBoxState(focusNode, focusNodeNext, controller);
}

class _PasswordBoxState extends State<PasswordBox> {
  final FocusNode? focusNode;
  final FocusNode? focusNodeNext;
  final TextEditingController? controller;
  bool passwordVisible = true;

  _PasswordBoxState(this.focusNode, this.focusNodeNext, this.controller);

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(90)),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(color: (focusNode!.hasFocus ? Color(0xFFB9B9B9) : Colors.transparent), blurRadius: (focusNode!.hasFocus ? 3 : 0)),
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
            icon: passwordVisible
                ? SvgPicture.asset('assets/eye-slash.svg', color: Colors.grey, height: 16, width: 16)
                : SvgPicture.asset('assets/eye.svg', color: Colors.grey, height: 16, width: 16),
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
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    assert(!user!.isAnonymous);

    final User? currentUser = _auth.currentUser;
    assert(user?.uid == currentUser?.uid);

    return '$user';
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
          await signInWithGoogle().then((result) => Navigator.pushReplacement(build, MaterialPageRoute(builder: (build) => GetUserData())));
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

// class FacebookSignInButton extends StatefulWidget {
//   @override
//   _FacebookSignInButtonState createState() => _FacebookSignInButtonState();
// }
//
// class _FacebookSignInButtonState extends State<FacebookSignInButton> {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<Null> _login(BuildContext build) async {
//     var facebookSignIn;
//     if (kIsWeb) {
//       facebookSignIn = new FBWeb.FacebookLoginWeb();
//       final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
//
//       switch (result.status) {
//         case FacebookLoginStatus.loggedIn:
//           final FacebookAccessToken accessToken = result.accessToken;
//           print('''
//          Logged in!
//          Token: ${accessToken.token}
//          User id: ${accessToken.userId}
//          Expires: ${accessToken.expires}
//          Permissions: ${accessToken.permissions}
//          Declined permissions: ${accessToken.declinedPermissions}
//          ''');
//
//           try {
//             await loginWithFacebook(result, build);
//             Navigator.pushReplacement(build, MaterialPageRoute(builder: (context) => GetUserData()));
//           } catch (e) {
//             print(e);
//           }
//           break;
//         case FacebookLoginStatus.cancelledByUser:
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Login cancelled by the user.'),
//           ));
//           break;
//         case FacebookLoginStatus.error:
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Something went wrong with the login process.\n'
//                 'Here\'s the error Facebook gave us: ${result.errorMessage}'),
//           ));
//           break;
//       }
//     } else {
//       facebookSignIn = new FacebookLogin();
//       final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
//
//       switch (result.status) {
//         case FacebookLoginStatus.loggedIn:
//           final FacebookAccessToken accessToken = result.accessToken;
//           print('''
//          Logged in!
//          Token: ${accessToken.token}
//          User id: ${accessToken.userId}
//          Expires: ${accessToken.expires}
//          Permissions: ${accessToken.permissions}
//          Declined permissions: ${accessToken.declinedPermissions}
//          ''');
//
//           try {
//             await loginWithFacebook(result, build);
//             Navigator.pushReplacement(build, MaterialPageRoute(builder: (context) => GetUserData()));
//           } catch (e) {
//             print(e);
//           }
//           break;
//         case FacebookLoginStatus.cancelledByUser:
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Login cancelled by the user.'),
//           ));
//           break;
//         case FacebookLoginStatus.error:
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Something went wrong with the login process.\n'
//                 'Here\'s the error Facebook gave us: ${result.errorMessage}'),
//           ));
//           break;
//       }
//     }
//   }
//
//   Future loginWithFacebook(FacebookLoginResult result, context) async {
//     final FacebookAccessToken accessToken = result.accessToken;
//     AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
//     await _auth.signInWithCredential(credential);
//   }
//
//   Widget build(BuildContext build) {
//     return Material(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(90)),
//       ),
//       elevation: 1,
//       color: Color(0xFF1877f2),
//       clipBehavior: Clip.antiAlias,
//       child: MaterialButton(
//         elevation: 3,
//         padding: EdgeInsets.only(top: 11.0, bottom: 11.0),
//         onPressed: () async {
//           await _login(build);
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(right: 10),
//               child: Image(
//                 image: AssetImage('assets/facebook_sign_in.png'),
//                 height: 26,
//               ),
//             ),
//             Text(
//               'Sign in with Facebook',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function()? onClickFunction;
  final double borderRadius;
  final EdgeInsets padding;

  PrimaryButton({
    this.onClickFunction,
    this.text = "Sample Text",
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.borderRadius = 90,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      elevation: 1,
      color: color,
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        padding: padding,
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

class SecondaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function()? onClickFunction;
  final disabled;

  SecondaryButton({this.onClickFunction, this.text = "Sample Text", this.color = Colors.white, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(90)),
        side: BorderSide(
          width: 0.7,
          color: disabled ? Color(0xFF6E6E6E) : color,
        ),
      ),
      elevation: disabled ? 0 : 1,
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        onPressed: disabled ? null : onClickFunction,
        child: Text(
          text,
          style: TextStyle(
            color: disabled ? Color(0xFF6E6E6E) : color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class PrimaryCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderSide borderSide;
  final double minHeight;
  final double borderRadius;

  PrimaryCard({
    this.child,
    this.padding = const EdgeInsets.all(28),
    this.color = const Color(0xFFFFFFFF),
    this.borderSide = BorderSide.none,
    this.minHeight = 0.0,
    this.borderRadius = 25,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 6,
            offset: Offset(0, 6),
          ),
        ],
      ),
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class ClickablePrimaryCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderSide borderSide;
  final Function()? onClickFunction;

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
  final TextStyle textStyle;
  final bool popAvailable;
  final EdgeInsets padding;

  PageHeadings(
      {this.text = "",
      this.metaText = "",
      this.popAvailable = false,
      this.padding = const EdgeInsets.fromLTRB(5, 20, 20, 20),
      this.textStyle = const TextStyle(fontWeight: FontWeight.w900, fontSize: 28)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: metaText.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          popAvailable
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: SvgPicture.asset(
                      'assets/back.svg',
                      height: 26,
                      width: 26,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Container(
            width: MediaQuery.of(context).size.width - 66.5 - 38,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  text,
                  style: textStyle,
                ),
                metaText.isNotEmpty
                    ? Text(
                        metaText,
                        style: TextStyle(
                          color: Color(0xFF878787),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
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
      {required this.assetPath,
      required this.text,
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
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.12),
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: 32,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: SizedBox(
              height: 32,
              child: LinearProgressIndicator(
                value: valueTwo,
                valueColor: AlwaysStoppedAnimation<Color>(colorTwo),
                backgroundColor: Color(0xFFCDCDCD),
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
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
  final String? title;
  final String? description;
  final bool? value;
  final String assetPath;
  final Function(bool)? callBack;

  const GoalSelection({this.title, this.description, this.value, required this.assetPath, this.callBack});

  _GoalSelectionState createState() => _GoalSelectionState(title, description, value, assetPath, callBack);
}

class _GoalSelectionState extends State<GoalSelection> {
  final String? title;
  final String? description;
  final String assetPath;
  Function(bool)? callBack;
  bool? value;

  _GoalSelectionState(this.title, this.description, this.value, this.assetPath, this.callBack);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value!;
        });
        callBack!(value!);
      },
      child: PrimaryCard(
        color: value! ? Color(0xFF299E45) : Colors.white,
        borderSide: BorderSide(
          color: Colors.white,
          width: 10,
          style: BorderStyle.solid,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  assetPath,
                  height: 22,
                  width: 22,
                  color: value! ? Colors.white : Color(0xFF6E6E6E),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: value! ? Colors.white : Color(0xFF6E6E6E),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 10),
              child: Text(
                description!,
                style: TextStyle(
                  fontSize: 16,
                  color: value! ? Colors.white : Color(0xFF6E6E6E),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Information extends StatelessWidget {
  final label;
  final text;

  const Information({Key? key, this.label, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class PrimaryDialog extends StatelessWidget {
  final title;
  final content;
  final actions;

  const PrimaryDialog({Key? key, this.title, this.content, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      titlePadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      insetPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    );
  }
}

class PopupPlayer extends StatefulWidget {
  final url;

  const PopupPlayer({Key? key, this.url}) : super(key: key);

  _PopupPlayerState createState() => _PopupPlayerState(url);
}

class _PopupPlayerState extends State<PopupPlayer> {
  final url;

  _PopupPlayerState(this.url);

  var _controller;

  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: Video.VIDEO_1,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
  }

  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      content: YoutubePlayerControllerProvider(
        controller: _controller,
        child: YoutubePlayerIFrame(),
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  final url;

  const VideoPlayer({Key? key, this.url}) : super(key: key);

  _VideoPlayerState createState() => _VideoPlayerState(url);
}

class _VideoPlayerState extends State<VideoPlayer> {
  final url;

  _VideoPlayerState(this.url);

  var _controller;

  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: Video.VIDEO_1,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
  }

  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: YoutubePlayerControllerProvider(
        controller: _controller,
        child: YoutubePlayerIFrame(),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        content: Center(child: CircularProgressIndicator(backgroundColor: Colors.transparent)),
      ),
    );
  }
}

class AnswerSlider extends StatefulWidget {
  final callBack;
  final value;

  const AnswerSlider({Key? key, this.callBack, this.value}) : super(key: key);

  _AnswerSliderState createState() => _AnswerSliderState(callBack, value);
}

class _AnswerSliderState extends State<AnswerSlider> {
  final callBack;
  double value;

  _AnswerSliderState(this.callBack, this.value);

  TextStyle labelStyle = TextStyle(color: Color(0xFF2667FF));

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xFF1AD9AA),
              inactiveTrackColor: Color(0xFFFF9E9E),
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 8,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Color(0xFF453EAE),
            ),
            child: Slider(
              min: 1.0,
              max: 10.0,
              value: value,
              onChanged: (value) {
                setState(() {
                  this.value = value;
                  callBack(value);
                });
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(4)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Disagree', style: labelStyle),
                Text('Agree', style: labelStyle),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatPoll extends StatefulWidget {
  final yesValue;
  final noValue;
  final owner;
  final yesCallback;
  final noCallback;
  final votedOn;
  final expireTime;

  const ChatPoll({Key? key, this.yesValue, this.noValue, this.owner, this.yesCallback, this.noCallback, this.votedOn, this.expireTime}) : super(key: key);

  ChatPollState createState() => ChatPollState(yesValue, noValue, owner, yesCallback, noCallback, votedOn, expireTime);
}

class ChatPollState extends State<ChatPoll> {
  final yesValue;
  final noValue;
  final owner;
  final yesCallback;
  final noCallback;
  final votedOn;
  DateTime expireTime;

  ChatPollState(this.yesValue, this.noValue, this.owner, this.yesCallback, this.noCallback, this.votedOn, this.expireTime);

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    bool isExpire = currentTime.isBefore(expireTime) ? false : true;
    String? timeLeft = isExpire ? null : "${expireTime.difference(currentTime).inHours}hour(s)";
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 8),
      constraints: BoxConstraints(
        maxWidth: owner ? 280 : 250,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      duration: Duration(milliseconds: 200),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Leave Poll", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
            Padding(padding: EdgeInsets.all(5)),
            GestureDetector(
              onTap: votedOn == "Yes" || isExpire ? null : yesCallback,
              child: PollBar(
                color: Color(0xFFF5F5F5),
                value: yesValue,
                label: "Yes",
                voted: votedOn == "Yes",
              ),
            ),
            GestureDetector(
              onTap: votedOn == "No" || isExpire ? null : noCallback,
              child: PollBar(
                color: Color(0xFFF5F5F5),
                value: noValue,
                label: "No",
                voted: votedOn == "No",
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            isExpire
                ? Text(
                    "Poll has ended on ${expireTime.hour}:00 ${expireTime.day}/${expireTime.month}/${expireTime.year}",
                    style: TextStyle(fontSize: 12),
                  )
                : Text("Poll will be expiring in $timeLeft"),
          ],
        ),
      ),
    );
  }
}

class PollBar extends StatelessWidget {
  final color;
  final value;
  final label;
  final voted;

  const PollBar({Key? key, this.color, this.value, this.label, this.voted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                LinearProgressIndicator(
                  minHeight: 42,
                  value: 1,
                  color: color,
                ),
                LinearProgressIndicator(
                  minHeight: 42,
                  value: value,
                  color: Color(0xFFD2D2D2),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                "${(value * 100).toStringAsFixed(0)}%",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String content;
  final String timeStamp;
  final String targetName;
  final bool owner;

  ChatBubble({required this.content, required this.timeStamp, required this.owner, required this.targetName});

  @override
  Widget build(BuildContext context) {
    TextStyle contentStyle = TextStyle(
      color: owner ? Color(0xFF170E9A) : Colors.white,
      fontSize: 16,
    );
    TextStyle timeStampStyle = TextStyle(
      color: Color(0xFFC2C2C2),
      fontSize: 12,
    );
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 8),
      constraints: BoxConstraints(
        maxWidth: owner ? 280 : 250,
      ),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: owner ? Colors.white : Color(0xFF170E9A),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !owner
                ? Text(
                    targetName,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Text(
                content,
                style: contentStyle,
              ),
            ),
            Text(
              timeStamp,
              style: timeStampStyle,
            ),
          ],
        ),
      ),
    );
  }
}

//Custom Methods
DateTime getTime() {
  var date;
  date = DateTime.now();
  date = DateTime(date.year, date.month, date.day);
  return date;
}

Future<void> showLoading(BuildContext context) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (c) {
      return LoadingOverlay();
    },
  );
}

String restructureStringFromNewLine(String input) {
  String result = "";
  if (input.contains("\n")) {
    List<String> tempList = input.split("\n");
    int startIndex = -1;
    int endIndex = -1;
    for (var i = 0; i < tempList.length; i++) {
      if (tempList[i].isNotEmpty) {
        if (startIndex == -1) {
          startIndex = i;
        } else {
          endIndex = i;
        }
      }
    }
    if (endIndex == -1) {
      endIndex = startIndex;
    }
    for (var i = startIndex; i <= endIndex; i++) {
      result += tempList[i];
      if (i != endIndex) {
        result += "\n";
      }
    }
  } else {
    result = input;
  }
  return result;
}
