import 'dart:convert';

import 'package:HealthGuard/model/article_model.dart';
import 'package:http/http.dart' as http;

/// Displaying news from the default country (Malaysia)
class News{
  List<ArticleModel> news = [];

  Future<void> getNews() async{
    String url = "http://newsapi.org/v2/top-headlines?country=my"
        "&category=health&apiKey=ec2aa1a842a0487ba1bcd325ec417d87";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == "ok"){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"] != null && element['description'] != null){
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            author: element["author"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            publishedAt: DateTime.parse(element["publishedAt"]),
            content: element["content"],
          );
          news.add(articleModel);
        }
      });
    }
  }
}

/// Displaying news of the country user selected to read
class CategoryNews{
  List<ArticleModel> news = [];

  Future<void> getNews(String country, String countryName) async{
    String url = "http://newsapi.org/v2/top-headlines?country=$country&category=health&apiKey=ec2aa1a842a0487ba1bcd325ec417d87";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == "ok"){
      jsonData["articles"].forEach((element){

        if(element["urlToImage"] != null && element['description'] != null){
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            author: element["author"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            publishedAt: DateTime.parse(element["publishedAt"]),
            content: element["content"],
          );

          news.add(articleModel);
        }
      });
    }
  }
}