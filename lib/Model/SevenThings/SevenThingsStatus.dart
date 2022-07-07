import 'dart:io';

class SevenThingsStatus {
  bool locked = false;
  bool penalty = false;
  bool lockEdit = false;

  void toObject(Map<String, dynamic> map) {
    if (map.containsKey('locked')) this.locked = map['locked'];
    if (map.containsKey('penalty')) this.penalty = map['penalty'];
    if (map.containsKey('lockEdit')) this.lockEdit = map['lockEdit'];
  }

  Map<String, dynamic> toMap() {
    return {
      "locked": this.locked,
      "penalty": this.penalty,
      "lockEdit": this.lockEdit,
    };
  }

  Map<String, File> getFileList() {
    return {};
  }
}
