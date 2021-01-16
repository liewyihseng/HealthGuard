import 'package:HealthGuard/view/article_view.dart';
import 'package:HealthGuard/view/category_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'helper/data.dart';
import 'helper/news.dart';
import 'model/article_model.dart';
import 'model/category_model.dart';


class MedicalFeed extends StatefulWidget{
  static const String id = "MedicalFeedPage";
  const MedicalFeed({Key key}) : super(key: key);
  @override
  _MedicalFeedState createState() => _MedicalFeedState();

}

class _MedicalFeedState extends State<MedicalFeed>{

  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

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
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryView(
            category: categoryName.toLowerCase(),
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

class BlogTile extends StatelessWidget {

  final String imageUrl, title, description, url;
  BlogTile({@required this.imageUrl, @required this.title, @required this.description, @required this.url});

  @override
  Widget build(BuildContext context){
    ///Anywhblogser tap (Article image, title and description) will redirect to web view
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