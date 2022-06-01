import 'package:flutter/material.dart';

import '../Screen/_Utility/BaseTheme.dart';

class BaseViewModel with ChangeNotifier {
  static const int STATE_NORMAL = 0;
  static const int STATE_LOADING = 1;

  static const int MESSAGE_STATUS_ERROR = 2;
  static const int MESSAGE_STATUS_INFO = 3;
  static const int MESSAGE_STATUS_SUCCESS = 4;

  int currentState = STATE_NORMAL;
  String errorMessage = "";

  setStateNormal() {
    this.currentState = STATE_NORMAL;
    notifyListeners();
  }

  setStateLoading() {
    this.currentState = STATE_LOADING;
    notifyListeners();
  }

  bool isStateLoading() {
    return this.currentState == STATE_LOADING;
  }

  bool isStateNormal() {
    return this.currentState == STATE_NORMAL;
  }

  showStatusMessage(int statusCode, String statusMessage, BuildContext context) {
    Color baseColor = BaseTheme.PRIMARY_COLOR;
    Widget icon = SizedBox();

    if (statusCode == MESSAGE_STATUS_ERROR) {
      baseColor = BaseTheme.DEFAULT_ERROR_COLOR;
      icon = Icon(Icons.warning, color: Colors.white);
    }
    if (statusCode == MESSAGE_STATUS_INFO) {
      baseColor = BaseTheme.DEFAULT_INFO_COLOR;
      icon = Icon(Icons.error, color: Colors.white);
    }
    if (statusCode == MESSAGE_STATUS_SUCCESS) {
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
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: BaseTheme.BACKGROUND_COLOR,
            borderRadius: BaseTheme.MODAL_BORDER_RADIUS,
          ),
          margin: BaseTheme.DEFAULT_MODAL_MARGIN,
          child: child,
        );
      },
    );
  }
}
