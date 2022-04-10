import 'package:LCI/Notifier/UserNotifier.dart';
import 'package:LCI/Screen/Utility/BaseScreen.dart';
import 'package:LCI/Screen/Utility/BaseTheme.dart';
import 'package:LCI/Screen/Utility/Labels.dart';
import 'package:LCI/Screen/Utility/PrimaryButton.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Notifier/StateNotifier.dart';
import '../ViewModel/RegisterViewModel.dart';
import 'Utility/PrimaryInput.dart';
import 'Utility/Regex.dart';
import 'Utility/StatusMessage.dart';

class Register extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StateNotifier()),
        ChangeNotifierProvider(create: (context) => UserNotifier()),
      ],
      child: _Register(),
    );
  }
}

class _Register extends StatefulWidget {
  StateRegister createState() => StateRegister();
}

class StateRegister extends State<_Register> {
  final PageController registerPageController = PageController();
  final GlobalKey<FormState> registerFormKey = GlobalKey();

  Widget build(BuildContext context) {
    StateNotifier stateNotifier = Provider.of<StateNotifier>(context);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    RegisterViewModel registerViewModel = new RegisterViewModel();

    return BaseScreen(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Form(
        key: registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageTitle(text: 'Register', margin: EdgeInsets.symmetric(vertical: 12, horizontal: 18), backButton: true),
            MetaText(text: 'Register a new LCI Life Compass account', margin: EdgeInsets.only(top: 8, bottom: 22, left: 18, right: 18)),
            ExpandablePageView(
              //physics: NeverScrollableScrollPhysics(),
              controller: registerPageController,
              children: [
                RegisterEmail(userNotifier: userNotifier),
                RegisterPassword(),
                RegisterPersonalInfo(),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: StatusMessage(stateNotifier: stateNotifier),
            ),
            Spacer(),
            PrimaryButton(
              text: 'Next',
              margin: EdgeInsets.only(left: 12, right: 12, top: 8),
              onPressed: () async {
                bool cont = false;
                if (registerFormKey.currentState!.validate()) {
                  registerFormKey.currentState!.save();

                  if (registerPageController.page == 0) {
                    // Email page
                    bool emailExist = await registerViewModel.checkRegisteredEmail(stateNotifier, userNotifier.user!.email!);
                    if (!emailExist) {
                      cont = true;
                    } else {
                      stateNotifier.setStateError("This email exists, please proceed to login");
                    }
                  }

                  if (cont) registerPageController.nextPage(curve: Curves.easeIn, duration: Duration(milliseconds: 500));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterEmail extends StatefulWidget {
  final UserNotifier userNotifier;

  const RegisterEmail({required this.userNotifier});

  StateRegisterEmail createState() => StateRegisterEmail();
}

class StateRegisterEmail extends State<RegisterEmail> {
  get userNotifier => widget.userNotifier;

  Widget build(BuildContext context) {
    return Container(
      margin: BaseTheme.DEFAULT_MARGIN,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          PrimaryInput(
            labelText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) return "Please enter your email";
              if (!Regex.EMAIL_REGEX.hasMatch(value)) return "Invalid email format";
              return null;
            },
            onSaved: (value) {
              userNotifier.updateEmail(value);
            },
          )
        ],
      ),
    );
  }
}

class RegisterPassword extends StatefulWidget {
  StateRegisterPassword createState() => StateRegisterPassword();
}

class StateRegisterPassword extends State<RegisterPassword> {
  Widget build(BuildContext context) {
    return Container(
      margin: BaseTheme.DEFAULT_MARGIN,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          PasswordInput(
            margin: EdgeInsets.only(bottom: 8),
            labelText: 'Password',
          ),
          PasswordInput(
            labelText: 'Confirm Password',
          )
        ],
      ),
    );
  }
}

class RegisterPersonalInfo extends StatefulWidget {
  StateRegisterPersonalInfo createState() => StateRegisterPersonalInfo();
}

class StateRegisterPersonalInfo extends State<RegisterPersonalInfo> {
  Widget build(BuildContext context) {
    return Container(
      margin: BaseTheme.DEFAULT_MARGIN,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          PrimaryInput(
            labelText: 'Name',
          ),
        ],
      ),
    );
  }
}
