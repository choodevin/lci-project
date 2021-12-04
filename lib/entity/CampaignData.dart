import 'package:cloud_firestore/cloud_firestore.dart';


class CampaignData{
  String name;
  int duration;
  Timestamp startDate;
  String goalDecision;
  String sevenThingsDeadline;
  bool sevenThingsPenaltyDecision;
  String sevenThingsPenalty;
  String invitationCode;
  String campaignAdmin;
  List<dynamic> campaignModerator;
  int selectedGoalReview;
  String rules;

  CampaignData({this.name,
    this.duration,
    this.startDate,
    this.goalDecision,
    this.sevenThingsDeadline,
    this.sevenThingsPenaltyDecision,
    this.sevenThingsPenalty,
    this.invitationCode,
    this.campaignAdmin,
    this.campaignModerator,
    this.selectedGoalReview,
    this.rules});
}
