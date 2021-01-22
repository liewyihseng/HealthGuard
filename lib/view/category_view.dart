import 'package:HealthGuard/helper/news.dart';
import 'package:HealthGuard/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'article_view.dart';

class CategoryView extends StatefulWidget{

  final String category;
  final String categoryName;
  CategoryView({this.category, this.categoryName});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>{

  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;
  var _categoryName;

  @override
  void initState(){
    super.initState();
    getCategoryNews();
    _categoryName = widget.categoryName;
  }

  getCategoryNews() async{
    CategoryNews newsClass = CategoryNews();
    await newsClass.getNews(widget.category, widget.categoryName);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " $_categoryName - Medical Article",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) :SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  final String imageUrl, title, description, url;
  final DateTime publishedAt;

  BlogTile({@required this.imageUrl, @required this.title, @required this.description, @required this.url, @required this.publishedAt});

  @override
  Widget build(BuildContext context){
    ///Anywhere user tap (Article image, title and description) will redirect to web view
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