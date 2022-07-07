import 'package:LCI/Service/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/SevenThings/SevenThingsContent.dart';
import '../Model/SevenThings/SevenThingsModel.dart';
import '../Model/UserModel.dart';
import '../Service/SevenThingsService.dart';
import 'BaseViewModel.dart';

class HomeViewModel extends BaseViewModel {
  UserModel user = new UserModel();

  SevenThingsModel? sevenThings;

  void updateTempSevenThingsContent(int index) {
    this.sevenThings!.contentList.elementAt(index).status = !this.sevenThings!.contentList.elementAt(index).status;
    notifyListeners();
  }

  void loadCurrentUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    this.user = await UserService.getUserById(userId, true);
    notifyListeners();
  }

  void loadProfilePicture() async {
    this.user = await UserService.loadProfilePicture(this.user);
    notifyListeners();
  }

  void loadSevenThings() async {
    this.sevenThings = await SevenThingsService.loadSevenThings(this.user, DateTime.now());
    notifyListeners();
  }

  bool checkContentAvailable() {
    for (SevenThingsContent content in this.sevenThings!.contentList) if (content.content.isNotEmpty) return false;
    return true;
  }

  Future saveSevenThings() async {
    this.setStateLoading();
    await SevenThingsService.saveSevenThings(this.sevenThings!, this.user.id!);
    this.setStateNormal();
  }
}
