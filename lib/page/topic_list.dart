import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import '../data/api.dart';
import '../data/topic_model.dart';
import 'topic_page.dart';

class TopicList extends StatefulWidget {
  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  List<TopicModel> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshTopic();
  }

  Future<bool> refreshTopic() async {
    List topicList = await getHomeList();
    setState(() {
      this.list = topicList;
    });
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void enterTopic(TopicModel topic) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ArticlePage(topic)),
    );
  }

  Widget buildImageList(List<String> list) {
    double fullWidth = MediaQuery.of(context).size.width - 20;
    double width = (fullWidth - 20) / 3;
    if (list.length >= 3) {
      List<String> finalList = list.sublist(0, 3);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: finalList.map((url) {
          return CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: 125,
            fit: BoxFit.cover,
          );
        }).toList(),
      );
    } else if (list.length > 0) {
      return CachedNetworkImage(
        imageUrl: list[0],
        width: fullWidth,
        height: 125,
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Text("empty"),
      );
    }
  }

  Widget buildCellWithModel(TopicModel model) {
    return Container(
//      height: 150,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      color: Color(0xffeeeeee),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model.title,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            model.summary,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.grey, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            height: 125,
            child: buildImageList(model.imageList),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                margin: EdgeInsets.only(right: 10),
                child: Image.network(model.userAvatar),
              ),
              Text(model.userName)
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    final controller =
//        SectionTableController(sectionTableViewScrollTo: (section, row, isScrollDown) {
//      print('received scroll to $section $row scrollDown:$isScrollDown');
//    });
    final refreshController = RefreshController();
    return SectionTableView(
//      controller: controller,
      refreshController: refreshController,
      sectionCount: 1,
      numOfRowInSection: (section) {
        return list.length;
      },
//      cellHeightAtIndexPath: (section, row) {
//        return 200;
//      },
      cellAtIndexPath: (section, row) {
        TopicModel model = list[row];
        return GestureDetector(
          child: buildCellWithModel(model),
          onTap: () {
            enterTopic(model);
          },
        );
      },
      enablePullDown: true,
      onRefresh: (up) {
        if (up) {
          this.refreshTopic().then((complete) {
            refreshController.sendBack(up, RefreshStatus.completed);
          });
        }
      },
    );
  }
}
