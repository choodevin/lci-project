import 'package:LCI/Model/UserModel.dart';
import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/Screen/_Utility/Labels.dart';
import 'package:LCI/Screen/_Utility/PrimaryButton.dart';
import 'package:LCI/Screen/_Utility/PrimaryInput.dart';
import 'package:LCI/Service/DateService.dart';
import 'package:LCI/Service/SevenThingsService.dart';
import 'package:LCI/ViewModel/BaseViewModel.dart';
import 'package:LCI/ViewModel/HomeViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/SevenThings/SevenThingsModel.dart';

class SevenThingsViewModel extends BaseViewModel {
  UserModel user = UserModel();
  HomeViewModel? homeViewModel;

  SevenThingsModel? currentSevenThings;

  DateTime selectedDate = DateTime.now();

  void loadSevenThings() async {
    this.currentSevenThings = await SevenThingsService.loadSevenThings(this.user, selectedDate);
    notifyListeners();
  }

  void updateTempSevenThingsContent(int index) {
    this.currentSevenThings!.contentList.elementAt(index).status = !this.currentSevenThings!.contentList.elementAt(index).status;
    SevenThingsService.saveSevenThings(this.currentSevenThings!, user.id!);
    syncSevenThingsWithHome();
    notifyListeners();
  }

  void reorderSevenThings(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
  }

  Future addSevenThingsContent(BuildContext context) async {
    TextEditingController textEditingController = TextEditingController();

    Widget child = Padding(
      padding: BaseTheme.DEFAULT_CONTENT_MARGIN,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ModalTitle(text: "Add 7 Things", margin: EdgeInsets.only(bottom: 12)),
          PrimaryInput(
            labelText: "7 Things",
            margin: EdgeInsets.only(bottom: 12),
            textEditingController: textEditingController,
            validator: (value) {
              if (value.length < 0) return "Please enter something";
              return null;
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: PrimaryButton(
              isLoading: this.isStateLoading(),
              text: "Confirm",
              onPressed: () => Navigator.of(context).pop(textEditingController.text),
              color: BaseTheme.DEFAULT_SUCCESS_COLOR,
            ),
          ),
        ],
      ),
    );

    this.showBottomModal(context, child).then((value) async {
      this.setStateLoading();

      if (this.currentSevenThings != null && value != null) {
        this.currentSevenThings!.contentList.firstWhere((element) => element.content.isEmpty).content = value;

        if (this.currentSevenThings!.sevenThingsDate == null) {
          this.currentSevenThings = SevenThingsService.setSevenThingsId(this.currentSevenThings!);
          await SevenThingsService.createSevenThings(this.currentSevenThings!, FirebaseAuth.instance.currentUser!.uid);
        } else {
          await SevenThingsService.saveSevenThings(this.currentSevenThings!, FirebaseAuth.instance.currentUser!.uid);
        }
      }

      this.setStateNormal();

      syncSevenThingsWithHome();
    });
  }

  void showSevenThingsContentMenu(BuildContext context) {
    Widget child = Text("asd");
    this.showBottomModal(context, child);
  }

  String getSevenThingsDateDisplay() {
    return DateService.getDateStringWithSuffix(this.selectedDate);
  }

  void selectDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    ).then((value) {
      if (value != null) selectedDate = value;
      loadSevenThings();
    });
  }

  void syncSevenThingsWithHome() {
    if (currentSevenThings!.sevenThingsDate!.compareTo(homeViewModel!.sevenThings!.sevenThingsDate!) == 0) homeViewModel!.sevenThings = currentSevenThings;
    notifyListeners();
  }
}
