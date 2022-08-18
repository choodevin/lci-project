import 'package:LCI/Route/Routes.dart';
import 'package:LCI/Service/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/SevenThings/SevenThingsContent.dart';
import '../Model/SevenThings/SevenThingsModel.dart';
import '../Model/UserModel.dart';
import '../Screen/_Utility/BaseTheme.dart';
import '../Service/SevenThingsService.dart';
import 'BaseViewModel.dart';
import 'SevenThingsViewModel.dart';

class HomeViewModel extends BaseViewModel {
  UserModel user = new UserModel();

  SevenThingsModel? sevenThings;

  SevenThingsService sevenThingsService = SevenThingsService();

  UserService userService = UserService();

  @override
  onWidgetBuilt(BuildContext context) {
    this.viewModelList.add(Provider.of<SevenThingsViewModel>(context, listen: true));
    if (this.user.id == null) this.loadCurrentUser();
    if (this.user.id != null && this.sevenThings == null) this.loadSevenThings();
  }

  void loadCurrentUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    this.user = await userService.getUserById(userId, true);
    notifyListeners();
  }

  void loadProfilePicture() async {
    await userService.loadProfilePicture(this.user);
    notifyListeners();
  }

  void loadSevenThings() async {
    this.sevenThings = await sevenThingsService.loadSevenThingsByDate(this.user, DateTime.now());
    notifyListeners();
  }

  bool checkContentAvailable() {
    for (SevenThingsContent content in this.sevenThings!.contentList) if (content.content.isNotEmpty) return false;
    return true;
  }

  void showProfileMenu(BuildContext context) {
    Widget child = Wrap(
      children: [
        ListTile(
          onTap: () async {
            if (await userService.logout()) Navigator.of(context).pop(true);
          },
          leading: Icon(Icons.logout, color: BaseTheme.DEFAULT_ERROR_COLOR),
          title: Text('Sign Out', style: TextStyle(color: BaseTheme.DEFAULT_ERROR_COLOR)),
        ),
      ],
    );

    this.showBottomModal(context, child).then((value) {
      if (value != null) Navigator.of(context).pushReplacementNamed(Routes.LANDING);
    });
  }

  void updateSevenThingsContent(int index) {
    this.sevenThings!.contentList.elementAt(index).status = !this.sevenThings!.contentList.elementAt(index).status;
    sevenThingsService.saveSevenThings(this.sevenThings!);
    callNotifyChanges();
    notifyListeners();
  }

  @override
  notifyChanges() {
    loadSevenThings();
  }
}
