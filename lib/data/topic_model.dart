class TopicModel {
  int boardId;
  int sourceId;
  String sourceType;
  String title;
  String userName;
  String summary;
  String userAvatar;
  List<String> imageList;
  TopicModel.fromJSON(Map<String, dynamic> map)
      : boardId = map['board_id'],
        sourceId = map['source_id'],
        sourceType = map['source_type'],
        title = map['title'],
        userName = map['user_nick_name'],
        summary = map['summary'],
        userAvatar = map['userAvatar'] {
    List imgListRaw = map['imageList'];
    imageList = imgListRaw.map((item) {
      return item.toString();
    }).toList();
  }
}
