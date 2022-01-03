import 'package:LCI/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom-components.dart';
import 'home.dart';

class Login extends StatelessWidget {
  Widget build(BuildContext build) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(build).size.height -
                  MediaQuery.of(build).padding.top -
                  MediaQuery.of(build).padding.bottom,
            ),
            padding: EdgeInsets.fromLTRB(25, 35, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeadings(
                  text: 'Welcome Back!',
                  metaText: 'Sign in to your account',
                ),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode focusNodePassword;
  FocusNode focusNodeEmail;
  bool passwordVisible = true;

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    focusNodePassword = FocusNode();
    focusNodeEmail = FocusNode();
    focusNodePassword.addListener(() {
      setState(() {});
    });
    focusNodeEmail.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
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
            padding: EdgeInsets.only(top: 20, bottom: 5),
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
            controller: _passwordController,
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
                  },
                  child: Text(
                    'Forgot Password ?',
                    style: TextStyle(
                      color: Color(0xFF878787),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 20),
            child: PrimaryButton(
              text: 'SIGN IN',
              color: Color(0xFF170E9A),
              textColor: Colors.white,
              onClickFunction: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please fill in all the credentials.")));
                } else {
                  FocusScope.of(context).unfocus();
                  try {
                    UserCredential uc = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                    if (uc.user != null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => GetUserData()));
                    }
                  } on FirebaseAuthException {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid email or password")));
                  }
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'OR',
                  style: TextStyle(
                    color: Color(0xFF878787),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 30.0),
          //   child: Column(
          //     children: [
          //       GoogleSignInButton(),
          //       Padding(
          //         padding: EdgeInsets.only(top: 15),
          //       ),
          //       FacebookSignInButton(),
          //     ],
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Color(0xFF878787),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      'Create one',
                      style: TextStyle(
                        color: Color(0xFF170E9A),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  FocusNode focusNodeEmail;

  @override
  void initState(){
    super.initState();
    focusNodeEmail = new FocusNode();
    focusNodeEmail.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageHeadings(
                text: "Forgot Password ?",
                metaText: "Enter your email, we will send you an password reset link",
                popAvailable: true,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 20),
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    PrimaryButton(
                      text: "Confirm",
                      color: Color(0xFF170E9A),
                      textColor: Colors.white,
                      onClickFunction: () {
                        if(_emailController.text.isNotEmpty) {
                          FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A reset password link has been sent, please check your email.")));
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error has occured : $error")));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter your email")));
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
}
