import 'package:LCI/Model/MonthlyRankingsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  String? name;
  int? duration;
  Timestamp? startDate;
  String? goalDecision;
  String? sevenThingsDeadline;
  bool? sevenThingsPenaltyDecision;
  String? sevenThingsPenalty;
  String? invitationCode;
  String? campaignAdmin;
  List<dynamic>? campaignModerator;
  int? selectedGoalReview;
  String? rules;

  MonthlyRankingsModel? monthlyRankings;

  CampaignModel.emptyConstructor();

  CampaignModel(this.name, this.duration, this.startDate, this.goalDecision, this.sevenThingsDeadline, this.sevenThingsPenaltyDecision, this.sevenThingsPenalty,
      this.invitationCode, this.campaignAdmin, this.campaignModerator, this.selectedGoalReview, this.rules, this.monthlyRankings);

  CampaignModel.fromMap(Map<String, dynamic> data) {
    campaignAdmin = data['campaignAdmin'];
    campaignModerator = data['campaignModerator'];
    duration = data['duration'];
    goalDecision = data['goalDecision'];
    invitationCode = data['invitationCode'];
    name = data['name'];
    rules = data['rules'];
    selectedGoalReview = data['selectedGoalReview'];
    sevenThingsDeadline = data['sevenThingDeadline'];
    sevenThingsPenalty = data['sevenThingsPenalty'];
    sevenThingsPenaltyDecision = data['sevenThingsPenaltyDecision'];
    startDate = data['startDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      "campaignAdmin": campaignAdmin,
      "campaignModerator": campaignModerator,
      "duration": duration,
      "goalDecision": goalDecision,
      "invitationCode": invitationCode,
      "name": name,
      "rules": rules,
      "selectedGoalReview": selectedGoalReview,
      "sevenThingDeadline": sevenThingsDeadline,
      "sevenThingsPenalty": sevenThingsPenalty,
      "sevenThingsPenaltyDecision": sevenThingsPenaltyDecision,
      "startDate": startDate,
    };
  }
}