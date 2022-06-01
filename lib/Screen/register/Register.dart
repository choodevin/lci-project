import 'package:LCI/Screen/_Utility/BaseScreen.dart';
import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/Screen/_Utility/CustomSvg.dart';
import 'package:LCI/Screen/_Utility/Labels.dart';
import 'package:LCI/Screen/_Utility/PrimaryButton.dart';
import 'package:LCI/Screen/_Utility/PrimaryDropdown.dart';
import 'package:LCI/Service/DateService.dart';
import 'package:LCI/Service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/register/RegisterViewModel.dart';
import '../_Utility/PrimaryIcon.dart';
import '../_Utility/PageViewWithIndicator.dart';
import '../_Utility/PrimaryCard.dart';
import '../_Utility/PrimaryInput.dart';
import '../_Utility/Regex.dart';

class Register extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
      ],
      child: _Register(),
    );
  }
}

class _Register extends StatefulWidget {
  StateRegister createState() => StateRegister();
}

class StateRegister extends State<_Register> {
  final PageController pageController = PageController();
  final PageController subscriptionPageController = PageController();
  final GlobalKey<FormState> registerFormKey = GlobalKey();

  Widget build(BuildContext context) {
    RegisterViewModel registerViewModel = Provider.of<RegisterViewModel>(context);

    DateTime tempDateTime = DateTime.now();
    String tempGender = UserService.GENDER_MALE;
    String tempCountry = UserService.COUNTRY_MALAYSIA;

    TextEditingController dobController = TextEditingController(text: DateService.formatDate(registerViewModel.user.dateOfBirth ?? DateTime.now()));
    TextEditingController nameController = TextEditingController(text: registerViewModel.user.name);
    TextEditingController emailController = TextEditingController(text: registerViewModel.user.email);
    TextEditingController passwordController = TextEditingController(text: registerViewModel.user.password);

    return WillPopScope(
      onWillPop: () async {
        if (pageController.page == 1) {
          pageController
              .previousPage(duration: Duration(milliseconds: 200), curve: Curves.ease)
              .whenComplete(() => registerViewModel.updateCurrentPage(pageController.page!));
          return false;
        } else {
          return true;
        }
      },
      child: BaseScreen(
        scrollable: true,
        child: Form(
          key: registerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageTitle(text: 'Register', backButton: true),
              MetaText(text: 'Register a new LCI Life Compass account'),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // Page 1 - User info
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => registerViewModel.selectPhoto(context),
                            child: Container(
                              margin: BaseTheme.DEFAULT_CONTENT_MARGIN,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: BaseTheme.LIGHT_OUTLINE_COLOR,
                                  width: 1,
                                ),
                              ),
                              height: 150,
                              width: 150,
                              child: ClipOval(
                                child: registerViewModel.user.profilePicture != null
                                    ? Image.file(
                                        registerViewModel.user.profilePicture!,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.add, color: BaseTheme.DEFAULT_OUTLINE_COLOR, size: 28),
                              ),
                            ),
                          ),
                          PrimaryInput(
                            enabled: registerViewModel.isStateLoading() ? false : true,
                            labelText: 'Name',
                            textInputAction: TextInputAction.next,
                            textEditingController: nameController,
                            textInputType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter your name";
                              return null;
                            },
                            onSaved: registerViewModel.updateName,
                            onChanged: (value) {
                              registerViewModel.user.name = value;
                            },
                          ),
                          PrimaryInput(
                            enabled: registerViewModel.isStateLoading() ? false : true,
                            labelText: 'Email',
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            textEditingController: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter your email";
                              if (!Regex.EMAIL_REGEX.hasMatch(value)) return "Invalid email format";
                              return null;
                            },
                            onSaved: registerViewModel.updateEmail,
                            onChanged: (value) {
                              registerViewModel.user.email = value;
                            },
                          ),
                          PasswordInput(
                            enabled: registerViewModel.isStateLoading() ? false : true,
                            labelText: 'Password',
                            textInputAction: TextInputAction.next,
                            textEditingController: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter your password";
                              if (value.length < 6) return "Password must be minimum 6 characters";
                              return null;
                            },
                            onChanged: (value) {
                              registerViewModel.user.password = value;
                            },
                          ),
                          PasswordInput(
                            enabled: registerViewModel.isStateLoading() ? false : true,
                            labelText: 'Confirm Password',
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter the confirm password";
                              if (value != passwordController.text) return "Password and confirm password does not match";
                              return null;
                            },
                            onSaved: registerViewModel.updatePassword,
                          ),
                          PrimaryDropdown(
                            enabled: registerViewModel.isStateLoading() ? false : true,
                            items: registerViewModel.getGenderDropdownItems(),
                            onChanged: (value) {
                              tempGender = value;
                            },
                            onSaved: registerViewModel.updateGender,
                            value: tempGender,
                          ),
                          PrimaryInput(
                            labelText: 'Date of Birth',
                            readOnly: true,
                            textEditingController: dobController,
                            validator: (_) {
                              if (registerViewModel.user.dateOfBirth == null) return "Please select your date of birth";
                              return null;
                            },
                            onTap: !registerViewModel.isStateLoading() ? () => registerViewModel.showDatePicker(context, tempDateTime) : null,
                          ),
                          PrimaryDropdown(
                            enabled: registerViewModel.isStateLoading() ? false : true,
                            items: registerViewModel.getCountryDropdownItems(),
                            onChanged: (value) {
                              tempCountry = value;
                            },
                            onSaved: registerViewModel.updateCountry,
                            value: tempCountry,
                          ),
                        ],
                      ),
                    ),
                    // Page 2 - Subscription Type
                    PageViewWithIndicator(
                      margin: EdgeInsets.only(bottom: 22),
                      onPageChanged: registerViewModel.updateSelectedSubscriptionPage,
                      selectedPage: registerViewModel.selectedSubscriptionPage,
                      children: [
                        PrimaryCard(
                          child: Column(
                            children: [
                              PrimaryIcon(iconSource: CustomSvg.compass, color: BaseTheme.PRIMARY_COLOR, size: 32),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    CardTitle(text: "Standard Plan"),
                                    CardText(
                                      text: BaseTheme.SAMPLE_PARAGRAPH,
                                      margin: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ],
                                ),
                              ),
                              PriceLabel(currency: PriceLabel.CURRENCY_MYR, price: 0, recurringType: PriceLabel.RECURRING_MONTH),
                            ],
                          ),
                        ),
                        PrimaryCard(
                          child: Column(
                            children: [
                              PrimaryIcon(iconSource: CustomSvg.crown, color: BaseTheme.PREMIUM_COLOR, size: 32),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    CardTitle(text: "Premium Plan"),
                                    CardText(
                                      text: BaseTheme.SAMPLE_PARAGRAPH,
                                      margin: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ],
                                ),
                              ),
                              PriceLabel(currency: PriceLabel.CURRENCY_MYR, price: 99, recurringType: PriceLabel.RECURRING_MONTH),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                margin: BaseTheme.DEFAULT_BUTTON_MARGIN,
                isLoading: registerViewModel.isStateLoading() ? true : false,
                onPressed: () => registerViewModel.next(pageController, registerFormKey, context),
                text: registerViewModel.currentPage == 0 ? 'Next' : 'Choose this Plan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
