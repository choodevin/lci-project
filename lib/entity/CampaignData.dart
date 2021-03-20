import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignData {
  int duration;
  Timestamp startDate;
  String goalDecision;
  String sevenThingsDeadline;
  bool sevenThingsPenaltyDecision;
  String sevenThingsPenalty;
  String invitationCode;
  String campaignAdmin;

  CampaignData(
      {this.duration,
      this.startDate,
      this.goalDecision,
      this.sevenThingsDeadline,
      this.sevenThingsPenaltyDecision,
      this.sevenThingsPenalty,
      this.invitationCode,
      this.campaignAdmin});
}
