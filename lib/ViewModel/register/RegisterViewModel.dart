import 'dart:async';
import 'dart:io';

import 'package:LCI/DAO/UserDAO.dart';
import 'package:LCI/Route/Routes.dart';
import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/ViewModel/BaseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/UserModel.dart';
import '../../Screen/_Utility/DatePicker.dart';
import '../../Service/UserService.dart';

class RegisterViewModel extends BaseViewModel {
  UserModel user = UserModel();

  int selectedSubscriptionPage = 0;

  double currentPage = 0;

  setUser(UserModel user) {
    this.user = user;
  }

  updateEmail(String? email) {
    this.user.email = email;
    notifyListeners();
  }

  updatePassword(String? password) {
    this.user.password = password;
    notifyListeners();
  }

  updateName(String? name) {
    this.user.name = name;
    notifyListeners();
  }

  updateGender(Object? gender) {
    if (gender is String?)
      this.user.gender = gender;
    else
      throw Exception("Invalid type for 'gender'");
    notifyListeners();
  }

  updateDob(DateTime dob) {
    this.user.dateOfBirth = dob;
    notifyListeners();
  }

  updateCountry(Object? country) {
    if (country is String?)
      this.user.country = country;
    else
      throw Exception("Invalid type for 'country'");
    notifyListeners();
  }

  updateProfilePictureData(XFile? file) {
    if (file != null) this.user.profilePicture = File(file.path);
    notifyListeners();
  }

  updateSelectedSubscriptionPage(int page) {
    this.selectedSubscriptionPage = page;
    notifyListeners();
  }

  updateCurrentPage(double page) {
    this.currentPage = page;
    notifyListeners();
  }

  Future<bool> checkRegisteredEmail(String email) async {
    this.setStateLoading();

    return await UserService.checkRegisteredEmail(email).whenComplete(() => this.setStateNormal());
  }

  List<DropdownMenuItem<dynamic>> getGenderDropdownItems() {
    List<String> genderList = [UserService.GENDER_MALE, UserService.GENDER_FEMALE, UserService.GENDER_OTHERS];

    return genderList.map((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(UserService.getGenderDescription(value)),
      );
    }).toList();
  }

  List<DropdownMenuItem<dynamic>> getCountryDropdownItems() {
    List<String> genderList = ['MY', 'SG'];

    return genderList.map((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(UserService.getCountryDescription(value)),
      );
    }).toList();
  }

  Future<UserModel?> getUser(String id) async {
    return await UserDAO.findUserById(id);
  }

  next(PageController pageController, GlobalKey<FormState> registerFormKey, BuildContext context) async {
    this.setStateLoading();

    if (pageController.page == 0) {
      if (registerFormKey.currentState!.validate()) {
        registerFormKey.currentState!.save();

        bool isEmailExist = await this.checkRegisteredEmail(this.user.email!);

        if (!isEmailExist) {
          pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.ease).whenComplete(() => this.updateCurrentPage(pageController.page!));
        } else {
          this.showStatusMessage(BaseViewModel.MESSAGE_STATUS_ERROR, "Email has been registered, please proceed to login", context);
        }
      }
    }

    if (pageController.page == 1) {
      this.user.subscriptionType = selectedSubscriptionPage == 0 ? UserService.SUBSCRIPTION_TYPE_STANDARD : UserService.SUBSCRIPTION_TYPE_PREMIUM;

      bool registerSuccess = await UserService.createUser(this.user);

      if (registerSuccess) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME, (_) => false);
      } else {
        this.showStatusMessage(BaseViewModel.MESSAGE_STATUS_ERROR, "Something wen\'t wrong", context);
      }
    }

    this.setStateNormal();
  }

  void showDatePicker(BuildContext context, DateTime tempDateTime) {
    Widget child = DatePicker(
      onDateTimeChanged: (value) {
        tempDateTime = value;
      },
      initialDateTime: this.user.dateOfBirth ?? DateTime.now(),
    );

    this.showBottomModal(context, child).whenComplete(() => this.updateDob(tempDateTime));
  }

  void selectPhoto(BuildContext context) {
    XFile? file = null;
    Widget child = Wrap(
      children: [
        ListTile(
          onTap: () async {
            file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 25);
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.photo, color: BaseTheme.DEFAULT_DISPLAY_COLOR),
          title: Text('Gallery', style: TextStyle(color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
        ),
        ListTile(
          onTap: () async {
            file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 25);
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.camera, color: BaseTheme.DEFAULT_DISPLAY_COLOR),
          title: Text('Camera', style: TextStyle(color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
        )
      ],
    );

    this.showBottomModal(context, child).whenComplete(() => this.updateProfilePictureData(file));
  }
}
