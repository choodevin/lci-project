class UserData {
  String email;
  String password;
  String name;
  String gender;
  String country;
  String dateOfBirth;
  String subscription;
  String currentEnrolledCampaign;
  bool isCoach;

  UserData({
    this.email = "",
    this.password = "",
    this.name = "",
    this.gender = "",
    this.country = "",
    this.dateOfBirth = "",
    this.subscription = "",
    this.currentEnrolledCampaign = "",
    isCoach = false,
  });
}
