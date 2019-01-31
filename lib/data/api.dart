import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'topic_model.dart';
import 'article_model.dart';

Future<List<TopicModel>> getHomeList() async {
  FormData formData = new FormData.from({
    "appName": "5iMX",
    "latitude": 40,
    "forumType": 7,
    "pageSize": 20,
    "forumKey": "vuXiNyyUWQ8TyNVIya",
    "sdkType": "",
    "imsi": "000010983610000",
    "isImageList": 1,
    "imei": "860758040010000",
    "apphash": "50f90bde",
    "sdkVersion": "2.5.0.0",
    "page": 1,
    "packageName": "com.appbyme.app50136",
    "moduleId": 1,
    "circle": "0",
    "platType": 1,
    "egnVersion": "v2103.5",
    "longitude": 110.4
  });
  try {
    print('request');
    Dio dio = new Dio();
//    dio.onHttpClientCreate = (HttpClient client) {
//      // config the http client
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY localhost:8888";
//      };
//    };
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    dio.options.responseType = ResponseType.JSON;
    Response response;
    response = await dio.post("http://bbs.5imx.com/mobcent/app/web/index.php?r=portal/newslist",
        data: formData);
    print("reveived data " + response.data.toString());
    Map<String, dynamic> data = jsonDecode(response.data);
    if (data != null && data['list'] != null) {
      List dataList = data['list'];
      List<TopicModel> topicList = dataList.map((map) {
        return TopicModel.fromJSON(map);
      }).toList();
      return topicList;
    }
    return [];
  } on DioError catch (e) {
    print('error ' + e.toString());
    return [];
  }
}

Future<Article> getArticle(TopicModel topicModel) async {
  FormData formData = new FormData.from({
    "appName": "5iMX",
    "forumType": 7,
    "pageSize": 20,
    "forumKey": "vuXiNyyUWQ8TyNVIya",
    "sdkType": "",
    "imsi": "000010983610000",
    "authorId": 0,
    "topicId": topicModel.sourceId,
    "boardId": topicModel.boardId,
    "imei": "860758040010000",
    "apphash": "50f90bde",
    "sdkVersion": "2.5.0.0",
    "page": 1,
    "packageName": "com.appbyme.app50136",
    "platType": 1,
    "egnVersion": "v2103.5",
  });
  try {
    print('request');
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    dio.options.responseType = ResponseType.JSON;
    Response response;
    response = await dio.post("http://bbs.5imx.com//mobcent/app/web/index.php?r=forum/postlist",
        data: formData);
    print("reveived data " + response.data.toString());
    Map<String, dynamic> data = jsonDecode(response.data);
    if (data != null && data['topic'] != null) {
      return Article.fromJSON(data);
    }
    return null;
  } on DioError catch (e) {
    print('error ' + e.toString());
    return null;
  }
}

Future<Article> getNews(TopicModel topicModel) async {
  FormData formData = new FormData.from({
    "appName": "5iMX",
    "forumType": 7,
    "json": "%7B%22aid%22%3A" + topicModel.sourceId.toString() + "%2C%22page%22%3A1%7D",
    "forumKey": "vuXiNyyUWQ8TyNVIya",
    "imei": "860758040010000",
    "apphash": "50f90bde",
    "sdkType": "",
    "sdkVersion": "2.5.0.0",
    "imsi": "000010983610000",
    "packageName": "com.appbyme.app50136",
    "platType": 1,
    "egnVersion": "v2103.5",
  });
  try {
    print('request');
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    dio.options.responseType = ResponseType.JSON;
    Response response;
    response = await dio.post("http://bbs.5imx.com//mobcent/app/web/index.php?r=portal/newsview",
        data: formData);
    print("reveived data " + response.data.toString());
    Map<String, dynamic> data = jsonDecode(response.data);
    if (data != null && data['body'] != null && data['body']['newsInfo'] != null) {
      Map news = data['body']['newsInfo'];
      return Article.fromNewsJSON(news);
    }
    return null;
  } on DioError catch (e) {
    print('error ' + e.toString());
    return null;
  }
}

Future<Article> getTopic(TopicModel topicModel) async {
  if (topicModel.sourceType == 'topic') {
    return await getArticle(topicModel);
  } else if (topicModel.sourceType == 'news') {
    return await getNews(topicModel);
  }
  return null;
}
