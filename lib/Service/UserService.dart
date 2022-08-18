import 'package:LCI/Repository/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/UserModel.dart';

class UserService {
  static const GENDER_MALE = 'M';
  static const GENDER_FEMALE = 'F';
  static const GENDER_OTHERS = 'O';

  static const COUNTRY_MALAYSIA = 'MY';
  static const COUNTRY_SINGAPORE = 'SG';

  static const SUBSCRIPTION_TYPE_STANDARD = "STANDARD";
  static const SUBSCRIPTION_TYPE_PREMIUM = "PREMIUM";

  static const List<String> GENDER_LIST = [GENDER_MALE, GENDER_FEMALE, GENDER_OTHERS];
  static const List<String> COUNTRY_LIST = [COUNTRY_MALAYSIA, COUNTRY_SINGAPORE];

  UserRepository userRepository = UserRepository();

  Future<String> getName(String id) async {
    String result = "";
    UserModel? user = await userRepository.getDocumentById(id);

    if(user != null) {
      result = user.name!;
    }

    return result;
  }

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error occurred while logging in : $e");
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("Error occurred while logging out : $e");
    }
    return false;
  }

  Future<bool> checkRegisteredEmail(String email) async {
    bool result = false;

    FirebaseAuth auth = FirebaseAuth.instance;

    List existingEmailList = await auth.fetchSignInMethodsForEmail(email);

    if (!existingEmailList.isEmpty) result = true;

    return result;
  }

  String getGenderDescription(String value) {
    if (value == GENDER_MALE) return 'Male';
    if (value == GENDER_FEMALE) return 'Female';
    if (value == GENDER_OTHERS) return 'Others';
    return '-- Gender --';
  }

  String getCountryDescription(String value) {
    if (value == COUNTRY_MALAYSIA) return 'Malaysia';
    if (value == COUNTRY_SINGAPORE) return 'Singapore';
    return '-- Country --';
  }

  Future<bool> createUser(UserModel user) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email!, password: user.password!); // Create firebase auth

      if (await userRepository.create(user)) return true; // Create profile pic storage data and user data

      return false;
    } catch (e) {
      print("Error occurred while creating user : $e");
      return false;
    }
  }

  Future<UserModel> getUserById(String id, bool loadProfilePicture) async {
    UserModel? user = await userRepository.getDocumentById(id);
    if (loadProfilePicture && user != null) await this.loadProfilePicture(user);
    return user!;
  }

  loadProfilePicture(UserModel user) async {
    user.profilePictureBits = await userRepository.downloadFile(filePath: "${user.id}/profilePicture");
  }
}
