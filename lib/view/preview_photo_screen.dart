import 'package:HealthGuard/constants.dart' as Constants;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// Class to allow the preview of photo in the chat when the users clicked onto the image
class PreviewPhoto extends StatelessWidget{
  final String url;

  PreviewPhoto({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
      title: Text(
      'Preview',
      style: TextStyle(
        color: Colors.white,
        fontFamily: Constants.FONTSTYLE,
        fontWeight: Constants.APPBAR_TEXT_WEIGHT,
      ),
    ),
    centerTitle: true,
      ),
      body: PreviewPhotoScreen(url: url),
    );
  }
}

class PreviewPhotoScreen extends StatefulWidget {
  final String url;

  PreviewPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => PreviewPhotoScreenState(url: url);
}

class PreviewPhotoScreenState extends State<PreviewPhotoScreen>{
  final String url;

  PreviewPhotoScreenState({Key key, @required this.url});

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: PhotoView(imageProvider: CachedNetworkImageProvider(url))
    );
  }
}