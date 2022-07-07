import 'package:LCI/ViewModel/BaseViewModel.dart';
import 'package:flutter/material.dart';

class HomeContainerViewModel extends BaseViewModel {
  int currentPage = 2;

  void updateCurrentPage(int currentPage, PageController pageController) {
    this.currentPage = currentPage;
    pageController.jumpToPage(this.currentPage);
    notifyListeners();
  }
}
