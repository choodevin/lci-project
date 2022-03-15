import 'package:cloud_firestore/cloud_firestore.dart';


class CampaignData{
  late String name;
  late int duration;
  late Timestamp startDate;
  late String goalDecision;
  late String sevenThingsDeadline;
  late bool sevenThingsPenaltyDecision;
  late String sevenThingsPenalty;
  late String invitationCode;
  late String campaignAdmin;
  late List<dynamic> campaignModerator;
  late int selectedGoalReview;
  late String rules;

  CampaignData();
}
