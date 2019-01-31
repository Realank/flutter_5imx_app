import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/api.dart';
import '../data/article_model.dart';
import '../data/topic_model.dart';
import '../view/avatar_view.dart';

class ArticlePage extends StatefulWidget {
  final TopicModel topicModel;
  ArticlePage(this.topicModel);
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Article article;
  @override
  void initState() {
    super.initState();
    refreshTopic();
  }

  Future<bool> refreshTopic() async {
    Article article = await getTopic(widget.topicModel);
    setState(() {
      this.article = article;
    });
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget buildRowCellWithModel(RowInfo model) {
    if (model.isImage) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          imageUrl: model.content,
          placeholder: Image.asset("resource/imageholder.png"),
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          model.content,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }

  Widget buildReplyCellWithModel(ReplyInfo replyInfo) {
    List<Widget> widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(right: 10),
            child: Image.network(replyInfo.userAvatar),
          ),
          Text(replyInfo.userName)
        ],
      ),
      Container(
        height: 10,
      )
    ];
    widgets.addAll(replyInfo.replyContent.map((rowInfo) {
      return buildRowCellWithModel(rowInfo);
    }).toList());
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
      padding: EdgeInsets.only(top: 10, bottom: 15, left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final refreshController = RefreshController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article != null ? article.title : '',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SectionTableView(
        refreshController: refreshController,
        sectionCount: article == null ? 0 : (article.reply.length == 0 ? 1 : 2),
        numOfRowInSection: (section) {
          if (section == 0) {
            return article.articleContent.length;
          } else {
            return article.reply.length;
          }
        },
        cellAtIndexPath: (section, row) {
          if (section == 0) {
            RowInfo rowInfo = article.articleContent[row];
            return buildRowCellWithModel(rowInfo);
          } else {
            ReplyInfo replyInfo = article.reply[row];
            return buildReplyCellWithModel(replyInfo);
          }
        },
        headerInSection: (section) {
          if (section == 0) {
            return Container(
                padding: EdgeInsets.all(10),
                child: AvatarView(
                  avatarUrl: article.userAvatar,
                  userName: article.userName,
                ));
          } else if (section == 1) {
            return Container(
              width: double.infinity,
              height: 30,
              padding: EdgeInsets.all(5),
              color: Color(0xffeeeeee),
              child: Text('评论'),
            );
          }
        },
        enablePullDown: true,
        onRefresh: (up) {
          if (up) {
            this.refreshTopic().then((complete) {
              refreshController.sendBack(up, RefreshStatus.completed);
            });
          }
        },
      ),
    );
  }
}
