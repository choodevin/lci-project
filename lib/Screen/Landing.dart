import 'package:LCI/Screen/_Utility/PrimaryButton.dart';
import 'package:LCI/Screen/_Utility/Labels.dart';
import 'package:LCI/Screen/_Utility/PrimaryInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/LandingViewModel.dart';
import '_Utility/BaseScreen.dart';
import '_Utility/BaseTheme.dart';
import '_Utility/Regex.dart';

class Landing extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LandingViewModel()),
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

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    LandingViewModel landingViewModel = Provider.of<LandingViewModel>(context);

    TextEditingController emailController = new TextEditingController(text: email);
    TextEditingController passwordController = new TextEditingController(text: password);

    return BaseScreen(
      resizeToAvoidBottomInset: false,
      child: Form(
        key: loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PageTitle(text: "Login"),
            MetaText(text: 'Welcome to LCI Life Compass'),
            PrimaryInput(
              enabled: landingViewModel.isStateLoading() ? false : true,
              labelText: "Email",
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textEditingController: emailController,
              onSaved: (value) {
                landingViewModel.user.email = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) return "Please enter your email";
                if (!Regex.EMAIL_REGEX.hasMatch(value)) return "Invalid email format";
                return null;
              },
            ),
            PasswordInput(
              enabled: landingViewModel.isStateLoading() ? false : true,
              labelText: "Password",
              textInputAction: TextInputAction.done,
              textEditingController: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) return "Please enter your password";
                return null;
              },
              onSaved: (value) {
                landingViewModel.user.password = value;
              },
            ),
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
              isLoading: landingViewModel.isStateLoading() ? true : false,
              onPressed: () => landingViewModel.login(loginFormKey, context),
              text: "LOGIN",
            ),
          ],
        ),
      ),
    );
  }
}
