import 'package:LCI/Notifier/StateNotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  void login(StateNotifier stateNotifier) async {
    stateNotifier.setStateLoading();
    stateNotifier.setStateNormal();
  }

  Future<bool> checkRegisteredEmail(StateNotifier stateNotifier, String email) async {
    stateNotifier.setStateLoading();

    bool result = false;

    FirebaseAuth auth = FirebaseAuth.instance;

    List existingEmailList = await auth.fetchSignInMethodsForEmail(email);

    if (!existingEmailList.isEmpty) result = true;

    stateNotifier.setStateNormal();

    return result;
  }
}
