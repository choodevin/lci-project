import 'package:LCI/Model/SevenThings/SevenThingsModel.dart';

import '../DAO/FirebaseService.dart';

class SevenThingsRepository extends FirebaseService<SevenThingsModel> {
  SevenThingsRepository() {
    super.model = SevenThingsModel();
  }
}
