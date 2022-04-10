import 'package:LCI/Notifier/StateNotifier.dart';
import 'package:LCI/Screen/Utility/PrimaryButton.dart';
import 'package:LCI/Screen/Utility/Labels.dart';
import 'package:LCI/Screen/Utility/PrimaryInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/LandingViewModel.dart';
import 'Utility/BaseScreen.dart';
import 'Utility/BaseTheme.dart';
import 'Utility/Regex.dart';

class Landing extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StateNotifier()),
      ],
      child: _Landing(),
    );
  }
}

class _Landing extends StatefulWidget {
  @override
  StateLanding createState() => StateLanding();
}

class StateLanding extends State<_Landing> {
  final GlobalKey<FormState> loginFormKey = GlobalKey();

  LandingViewModel landingViewModel = new LandingViewModel();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    StateNotifier stateNotifier = Provider.of<StateNotifier>(context, listen: false);

    return BaseScreen(
      resizeToAvoidBottomInset: false,
      child: Form(
        key: loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PageTitle(text: "Login", margin: BaseTheme.DEFAULT_HEADINGS_MARGIN),
            MetaText(text: 'Welcome to LCI Life Compass', margin: EdgeInsets.only(top: 8, bottom: 22)),
            PrimaryInput(
              labelText: "Email",
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              margin: BaseTheme.DEFAULT_MARGIN,
              onSaved: (value) {
                email = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) return "Please enter your email";
                if (!Regex.EMAIL_REGEX.hasMatch(value)) return "Invalid email format";
                return null;
              },
            ),
            PasswordInput(
                labelText: "Password",
                textInputAction: TextInputAction.done,
                margin: BaseTheme.DEFAULT_MARGIN,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please enter your password";
                  return null;
                },
                onSaved: (value) {
                  password = value;
                }),
            Spacer(),
            PrimaryButton(
              margin: EdgeInsets.only(bottom: 12),
              onPressed: () {
                Navigator.of(context).pushNamed('register');
              },
              text: "REGISTER",
              outlined: true,
              color: BaseTheme.DEFAULT_DISPLAY_COLOR,
            ),
            PrimaryButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                if (loginFormKey.currentState!.validate()) {
                  loginFormKey.currentState!.save();
                  bool validate = await landingViewModel.login(stateNotifier, email, password);

                  if (validate) {
                    Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
                  }
                }
              },
              text: "LOGIN",
            ),
          ],
        ),
      ),
    );
  }
}
