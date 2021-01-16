import 'package:HealthGuard/helper/news.dart';
import 'package:HealthGuard/model/article_model.dart';
import 'package:flutter/material.dart';

import 'article_view.dart';

class CategoryView extends StatefulWidget{

  final String category;
  CategoryView({this.category});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>{

  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState(){
    super.initState();

    getCategoryNews();
  }

  getCategoryNews() async{
    CategoryNews newsClass = CategoryNews();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Article"),
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
  BlogTile({@required this.imageUrl, @required this.title, @required this.description, @required this.url});

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
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
            SizedBox(height: 8),
            ///Setting style for Article description
            Text(description, style: TextStyle(color: Colors.black54),)
          ],
        ),
      ),
    );
  }
}