/// Acting as a frame for the creation of article instances
class ArticleModel{
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  /// A class that represents the article and what this class holds
  ArticleModel({this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});

}