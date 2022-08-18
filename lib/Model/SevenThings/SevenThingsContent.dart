class SevenThingsContent {
  String content = "";
  bool status = false;

  late int order;

  void toObject(MapEntry entry) {
    this.content = entry.key;
    this.status = entry.value['status'];
    this.order = entry.value['order'];
  }

  static Map<String, dynamic> toMap(List<SevenThingsContent> contentList) {
    Map<String, dynamic> contentMap = {};
    for (SevenThingsContent content in contentList) {
      if (content.content.isNotEmpty) {
        contentMap.putIfAbsent(
          content.content,
          () => {"status": content.status, "order": content.order},
        );
      }
    }
    return contentMap;
  }
}
