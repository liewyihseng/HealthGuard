import 'dart:ui';

import 'package:HealthGuard/view/article_view.dart';
import 'package:HealthGuard/view/category_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'helper/data.dart';
import 'helper/news.dart';
import 'model/article_model.dart';
import 'model/category_model.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Medical Feed screen page widget class
class MedicalFeed extends StatefulWidget{
  static const String id = "MedicalFeedPage";
  const MedicalFeed({Key key}) : super(key: key);
  @override
  _MedicalFeedState createState() => _MedicalFeedState();

}

/// Medical Feed screen page state class
class _MedicalFeedState extends State<MedicalFeed>{

  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  /// Overide init
  @override
  void initState(){
    super.initState();
    categories = getCategories();
    getNews();
  }

  /// Method to fetch news
  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }


  /// Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Article"),
        centerTitle: true,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
       ),
     ) : SingleChildScrollView(
       child: Container(
         padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // Categories
              Container(
                height: 70,
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return CategoryTile(
                      imageUrl: categories[index].imageUrl,
                      categoryCode: categories[index].categoryCode,
                      categoryName: categories[index].categoryName,
                    );
                  }),
              ),
              /// Blogs
              Container(
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemCount: articles.length,
                  shrinkWrap: true,
                  ///Making scroll smooth
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return BlogTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      description: articles[index].description,
                      url: articles[index].url,
                      publishedAt: articles[index].publishedAt,
                    );
                  }
                ),
              )
            ],
          ),
        ),
     ),
    );
  }
}

///The category above articles
class CategoryTile extends StatelessWidget{
  final imageUrl, categoryName, categoryCode;
  CategoryTile({this.imageUrl, this.categoryName, this.categoryCode});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryView(
            category: categoryCode.toLowerCase(),
            categoryName: categoryName,
          )
        ));
      },
      child: Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(imageUrl: imageUrl, width: 120, height: 60, fit: BoxFit.cover,)
          ),
          Container(
            alignment: Alignment.center,
            width: 120, height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black26,
            ),
            child: Text(categoryName, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),
          )
        ],
        ),
      ),
    );
  }
}

/// The box that holds each article in the medical feed page
class BlogTile extends StatelessWidget {

  final String imageUrl, title, description, url;
  final DateTime publishedAt;

  BlogTile({@required this.imageUrl, @required this.title, @required this.description, @required this.url, @required this.publishedAt});

  @override
  Widget build(BuildContext context){
    ///Any where user tap on the blog (Article image, title and description) will redirect to web view
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ArticleView(
            blogUrl: url,
          )
        ));
      },
      child: Card(
        elevation: 5,
        child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ///Frame for Article Image
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(imageUrl)
              ),
              ///Setting style for Article Title
              Text(title, style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600
              ),),
              new Padding(
                padding: new EdgeInsets.only(left: 1.0),
                child: new Text(timeago.format(publishedAt), style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),),
              ),
              SizedBox(height: 8),
              ///Setting style for Article description
              Text(description, style: TextStyle(color: Colors.black54),)
            ],
          ),
        ),
      ),
    );
  }

}