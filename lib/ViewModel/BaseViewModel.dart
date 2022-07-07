import 'package:LCI/Service/UserService.dart';
import 'package:flutter/material.dart';

import '../Screen/_Utility/BaseTheme.dart';

class BaseViewModel with ChangeNotifier {
  ScreenState currentState = ScreenState.NORMAL;
  String errorMessage = "";

  setStateNormal() {
    this.currentState = ScreenState.NORMAL;
    notifyListeners();
  }

  setStateLoading() {
    this.currentState = ScreenState.LOADING;
    notifyListeners();
  }

  bool isStateLoading() {
    return this.currentState == ScreenState.LOADING;
  }

  bool isStateNormal() {
    return this.currentState == ScreenState.NORMAL;
  }

  showStatusMessage(MessageStatus statusCode, String statusMessage, BuildContext context) {
    Color baseColor = BaseTheme.PRIMARY_COLOR;
    Widget icon = SizedBox();

    if (statusCode == MessageStatus.ERROR) {
      baseColor = BaseTheme.DEFAULT_ERROR_COLOR;
      icon = Icon(Icons.warning, color: Colors.white);
    }
    if (statusCode == MessageStatus.INFO) {
      baseColor = BaseTheme.DEFAULT_INFO_COLOR;
      icon = Icon(Icons.error, color: Colors.white);
    }
    if (statusCode == MessageStatus.SUCCESS) {
      baseColor = BaseTheme.DEFAULT_SUCCESS_COLOR;
      icon = Icon(Icons.done, color: Colors.white);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: BaseTheme.LIGHT_OUTLINE_COLOR),
            gradient: LinearGradient(stops: [0.14, 0.02], colors: [baseColor, Colors.white]),
          ),
          child: Row(
            children: [
              icon,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(statusMessage, style: BaseTheme.defaultTextStyle),
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: 42, vertical: 90),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future showBottomModal(BuildContext context, Widget child) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: BaseTheme.BACKGROUND_COLOR,
            borderRadius: BaseTheme.MODAL_BORDER_RADIUS,
          ),
          margin: EdgeInsets.fromLTRB(16,24,16, MediaQuery.of(context).viewInsets.bottom + 24),
          child: child,
        );
      },
    );
  }

  List<DropdownMenuItem<dynamic>> getDropdownItems(List<String> items) {
    return items.map((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(UserService.getGenderDescription(value)),
      );
    }).toList();
  }
}

enum ScreenState { NORMAL, LOADING }

enum MessageStatus { ERROR, INFO, SUCCESS }
