class SevenThingsStatus {
  String lockFlag = "NORMAL";
  bool penalty = false;

  void toObject(Map<String, dynamic> map) {
    if (map.containsKey('lockFlag')) this.lockFlag = map['lockFlag'];
    if (map.containsKey('penalty')) this.penalty = map['penalty'];
  }

  Map<String, dynamic> toMap() {
    return {
      "lockFlag": this.lockFlag,
      "penalty": this.penalty,
    };
  }
}
