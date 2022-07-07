import 'package:LCI/Service/UserService.dart';
import 'package:LCI/ViewModel/BaseViewModel.dart';
import 'package:flutter/cupertino.dart';

import '../Model/UserModel.dart';
import '../Route/Routes.dart';

class LandingViewModel extends BaseViewModel {
  UserModel user = UserModel();

  Future login(GlobalKey<FormState> loginFormKey, BuildContext context) async {
    this.setStateLoading();

    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      bool validate = await UserService.login(this.user.email!, this.user.password!);

      if (validate) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME, (_) => false);
      } else {
        this.showStatusMessage(MessageStatus.ERROR, "Email or password is incorrect", context);
      }
    }

    this.setStateNormal();
  }
}
