import 'dart:async';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///Article view when being clicked
class ArticleView extends StatefulWidget {

  final String blogUrl;
  ArticleView({this.blogUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>{

  final Completer<WebViewController> _completer = Completer<WebViewController>();


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      ///Displaying appbar even in webView
      appBar: AppBar(
        title: Text(
          'HealthGuard',
          style: TextStyle(
              color: Colors.white,
              fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.blogUrl,
          onWebViewCreated: ((WebViewController webViewController){
            _completer.complete(webViewController);
          }),
        ),
      ),
    );
  }
}