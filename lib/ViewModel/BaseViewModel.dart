import 'package:LCI/Service/UserService.dart';
import 'package:flutter/material.dart';

import '../Screen/_Utility/BaseTheme.dart';

class BaseViewModel with ChangeNotifier {
  ScreenState currentState = ScreenState.NORMAL;
  String errorMessage = "";
  List<BaseViewModel> viewModelList = [];

  onWidgetBuilt(BuildContext context) {}

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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: BaseTheme.LIGHT_OUTLINE_COLOR),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                color: baseColor,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: icon,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(statusMessage, style: BaseTheme.defaultTextStyle),
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: 42, vertical: 46),
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
          margin: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.of(context).viewInsets.bottom + 24),
          child: child,
        );
      },
    );
  }

  List<DropdownMenuItem<dynamic>> getDropdownItems(List<String> items, Function(String) itemDescription) {
    return items.map((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(itemDescription(value)),
      );
    }).toList();
  }

  callNotifyChanges() {
    viewModelList.forEach((element) {
      element.notifyChanges();
    });
    notifyListeners();
  }

  notifyChanges() {
    throw UnimplementedError("Notify changes is not implement in your viewModel");
  }
}

enum ScreenState { NORMAL, LOADING }

enum MessageStatus { ERROR, INFO, SUCCESS }
