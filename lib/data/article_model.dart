class Article {
  String title;
  String userName;
  String userAvatar;
  List<RowInfo> articleContent = [];
  List<ReplyInfo> reply = [];
  Article.fromJSON(Map<String, dynamic> map)
      : title = map['topic']['title'],
        userName = map['topic']['user_nick_name'],
        userAvatar = map['topic']['icon'] {
    List content = map['topic']['content'];
    articleContent = content.map((item) {
      return RowInfo.fromJSON(item);
    }).toList();
    List replyList = map['list'];
    reply = replyList.map((item) {
      return ReplyInfo.fromJSON(item);
    }).toList();
  }
  Article.fromNewsJSON(Map<String, dynamic> map)
      : title = map['title'],
        userName = map['author'],
        userAvatar = map['avatar'] {
    List content = map['content'];
    articleContent = content.map((item) {
      return RowInfo.fromNewsJSON(item);
    }).toList();
  }
}

class ReplyInfo {
  List<RowInfo> replyContent;
  String userName;
  String userAvatar;
  String quoteContent;
  ReplyInfo.fromJSON(Map<String, dynamic> map)
      : userName = map['reply_name'],
        userAvatar = map['icon'],
        quoteContent = map['quote_content'] {
    List replyList = map['reply_content'];
    replyContent = replyList.map((item) {
      return RowInfo.fromJSON(item);
    }).toList();
  }
}

class RowInfo {
  String content;
  bool isImage;
  RowInfo.fromJSON(Map<String, dynamic> map) {
    if (map['type'] == 1) {
      content = map['originalInfo'];
      isImage = true;
    } else {
      content = map['infor'];
      isImage = false;
    }
  }
  RowInfo.fromNewsJSON(Map<String, dynamic> map) {
    if (map['type'] == "image") {
      content = map['content'];
      isImage = true;
    } else {
      content = map['content'];
      isImage = false;
    }
  }
}
