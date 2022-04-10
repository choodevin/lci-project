import 'package:flutter/cupertino.dart';

import '../Model/CampaignModel.dart';

class CampaignNotifier with ChangeNotifier {
  CampaignModel campaign = new CampaignModel.emptyConstructor();

  setCampaign(CampaignModel campaign) {
    this.campaign = campaign;
    notifyListeners();
  }
}
