import 'package:LCI/Model/UserModel.dart';
import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/Screen/_Utility/Labels.dart';
import 'package:LCI/Screen/_Utility/PrimaryButton.dart';
import 'package:LCI/Screen/_Utility/PrimaryInput.dart';
import 'package:LCI/Service/DateService.dart';
import 'package:LCI/Service/SevenThingsService.dart';
import 'package:LCI/ViewModel/BaseViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/SevenThings/SevenThingsModel.dart';
import 'HomeViewModel.dart';

class SevenThingsViewModel extends BaseViewModel {
  UserModel user = UserModel();

  SevenThingsModel currentSevenThings = SevenThingsModel();

  SevenThingsService sevenThingsService = SevenThingsService();

  DateTime selectedDate = DateTime.now();

  bool edited = false;

  ScreenState saveState = ScreenState.NORMAL;

  @override
  onWidgetBuilt(BuildContext context) {
    this.viewModelList.add(Provider.of<HomeViewModel>(context));
    if (this.user.id == null) this.user = (this.viewModelList.firstWhere((element) => element is HomeViewModel) as HomeViewModel).user;
    if (this.currentSevenThings.id == null) this.loadSevenThings();
  }

  bool isEdited() {
    return edited;
  }

  void setSaveStateNormal() {
    this.saveState = ScreenState.NORMAL;
    notifyListeners();
  }

  void setSaveStateLoading() {
    this.saveState = ScreenState.LOADING;
    notifyListeners();
  }

  bool isSaving() {
    return saveState == ScreenState.LOADING;
  }

  void loadSevenThings() async {
    this.currentSevenThings = await sevenThingsService.loadSevenThingsByDate(this.user, selectedDate);
    notifyListeners();
  }

  void updateSevenThingsContent(int index) {
    this.currentSevenThings!.contentList.elementAt(index).status = !this.currentSevenThings!.contentList.elementAt(index).status;
    edited = true;
    notifyListeners();
  }

  void reorderSevenThings(int oldIndex, int newIndex) {
    this.currentSevenThings!.contentList = sevenThingsService.reorderSevenThings(this.currentSevenThings!.contentList, oldIndex, newIndex);
    edited = true;
    notifyListeners();
  }

  Future addSevenThingsContent(BuildContext context) async {
    TextEditingController textEditingController = TextEditingController();
    GlobalKey<FormState> addFormKey = GlobalKey();

    Widget child = Padding(
      padding: BaseTheme.DEFAULT_CONTENT_MARGIN,
      child: Form(
        key: addFormKey,
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
                if (value.length <= 0) return "Please enter something";
                return null;
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: PrimaryButton(
                isLoading: this.isStateLoading(),
                text: "Confirm",
                onPressed: () => {if (addFormKey.currentState!.validate()) Navigator.of(context).pop(textEditingController.text)},
                color: BaseTheme.DEFAULT_SUCCESS_COLOR,
              ),
            ),
          ],
        ),
      ),
    );

    this.showBottomModal(context, child).then((value) async {
      this.setStateLoading();

      if (this.currentSevenThings != null && value != null) {
        if (this.currentSevenThings!.contentList.where((element) => element.content == value).isNotEmpty) {
          this.showStatusMessage(MessageStatus.ERROR, "Task already exists in 7 Things list", context);
        } else {
          this.currentSevenThings!.contentList.firstWhere((element) => element.content.isEmpty).content = value;

          if (this.currentSevenThings!.sevenThingsDate == null) {
            this.currentSevenThings = sevenThingsService.setSevenThingsId(this.currentSevenThings!);
            await sevenThingsService.createSevenThings(this.currentSevenThings!, FirebaseAuth.instance.currentUser!.uid);
          } else {
            await sevenThingsService.saveSevenThings(this.currentSevenThings!);
          }
        }
      }

      this.setStateNormal();

      callNotifyChanges();
    });
  }

  Future saveSevenThings(BuildContext context) async {
    setSaveStateLoading();
    await sevenThingsService.saveSevenThings(this.currentSevenThings!);
    edited = false;
    this.showStatusMessage(MessageStatus.SUCCESS, "Saved", context);
    callNotifyChanges();
    setSaveStateNormal();
  }

  void showSevenThingsContentMenu(BuildContext context, int index) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = this.currentSevenThings!.contentList.elementAt(index).content;
    GlobalKey<FormState> editFormKey = GlobalKey();

    Widget child = Padding(
      padding: BaseTheme.DEFAULT_CONTENT_MARGIN,
      child: Form(
        key: editFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalTitle(text: "Edit 7 Things", margin: EdgeInsets.only(bottom: 12)),
            PrimaryInput(
              labelText: "7 Things",
              margin: EdgeInsets.only(bottom: 12),
              textEditingController: textEditingController,
              validator: (value) {
                if (value.length <= 0) return "Please enter something";
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryButton(
                  isLoading: this.isStateLoading(),
                  text: "Delete",
                  onPressed: () => Navigator.of(context).pop(true),
                  color: BaseTheme.DEFAULT_ERROR_COLOR,
                  margin: EdgeInsets.only(right: 8),
                ),
                PrimaryButton(
                  isLoading: this.isStateLoading(),
                  text: "Confirm",
                  onPressed: () => {if (editFormKey.currentState!.validate()) Navigator.of(context).pop(textEditingController.text)},
                  color: BaseTheme.DEFAULT_SUCCESS_COLOR,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    this.showBottomModal(context, child).then((value) async {
      this.setStateLoading();

      if (this.currentSevenThings != null && value != null) {
        if (value is bool) {
          this.currentSevenThings!.contentList.removeAt(index);
          await sevenThingsService.saveSevenThings(this.currentSevenThings!);
        } else {
          this.currentSevenThings!.contentList.elementAt(index).content = value;

          if (this.currentSevenThings!.sevenThingsDate == null) {
            this.currentSevenThings = sevenThingsService.setSevenThingsId(this.currentSevenThings!);
            await sevenThingsService.createSevenThings(this.currentSevenThings!, FirebaseAuth.instance.currentUser!.uid);
          } else {
            await sevenThingsService.saveSevenThings(this.currentSevenThings!);
          }
        }
      }

      this.setStateNormal();

      callNotifyChanges();
    });
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

  resetSevenThings() {
    edited = false;
    loadSevenThings();
    notifyListeners();
  }

  @override
  notifyChanges() {
    loadSevenThings();
  }
}
