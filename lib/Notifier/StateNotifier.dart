import 'package:flutter/cupertino.dart';

class StateNotifier with ChangeNotifier {
  static const int STATE_NORMAL = 0;
  static const int STATE_LOADING = 1;
  static const int STATE_ERROR = 2;

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

  setStateError(String errorMessage) {
    this.errorMessage = errorMessage;
    this.currentState = STATE_ERROR;
    notifyListeners();
  }
}
