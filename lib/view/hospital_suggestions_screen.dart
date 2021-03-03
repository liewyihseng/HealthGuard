
import 'dart:async';
import 'package:HealthGuard/widgets/place_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:google_maps_webservice/places.dart' as webGoogle;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:location/location.dart';

const GoogleApiKey = "AIzaSyCwIvvIxm9yn4JXoEHoaAx7wn2WySONi7M";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GoogleApiKey);


class HospitalSuggestions extends StatefulWidget{
  static const String id = "HospitalSuggestionsPage";
  const HospitalSuggestions({Key key}) : super(key: key);
  @override
  _HospitalSuggestionsState createState() => _HospitalSuggestionsState();
}

class _HospitalSuggestionsState extends State<HospitalSuggestions>{
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;


  @override
  Widget build(BuildContext context) {

    Widget expandedChild;
    if (isLoading) {
      expandedChild = Center(child: CircularProgressIndicator(value: null));
    } else if (errorMessage != null) {
      expandedChild = Center(
        child: Text(errorMessage),
      );
    } else {
      expandedChild = buildPlacesList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hospital Suggestions',
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
          ),
        ),
        actions: <Widget>[
          isLoading ? IconButton(icon: Icon(Icons.timer), onPressed: (){},): IconButton(icon: Icon(Icons.refresh),onPressed: (){refresh();},),
          IconButton(icon: Icon(Icons.search),onPressed: (){
            _handlePressButton();
          },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body:Column(
        children: <Widget>[
          Container(
            child: SizedBox(
              height: 200.0,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0)),
              ),
            ),
          ),
          Expanded(child: expandedChild,)
        ],
      ),
    );
  }

  void refresh() async{
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: center == null ? LatLng(0,0) : center, zoom: 15.0)));
    getNearbyPlaces(center);
  }

  void _onMapCreated(GoogleMapController controller) async{
    mapController = controller;
    refresh();
  }

  Future<LatLng> getUserLocation() async {
    LocationData currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void getNearbyPlaces(LatLng center) async{
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final result = await _places.searchNearbyWithRadius(new webGoogle.Location(center.latitude, center.longitude), 2500);
    setState(() {
      this.isLoading = false;
      if(result.status == "OK"){
        this.places = result.results;
        result.results.forEach((f){
          final markerOptions = Marker(
            position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
            infoWindow: InfoWindow(title: "${f.name}", snippet:  "${f.types?.first}"));
        });
      }else{
        this.errorMessage = result.errorMessage;
      }
    });
  }

  void onError(PlacesAutocompleteResponse response){
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content : Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async{
    try{
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        strictbounds: center == null ? false: true,
        apiKey: GoogleApiKey,
        onError: onError,
        mode: Mode.fullscreen,
        language: "en",
        location: center == null ? null : webGoogle.Location(center.latitude, center.longitude),
        radius: center == null ? null : 10000
      );
      showDetailPlace(p.placeId);
    }catch(e){
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async{
    if(placeId != null){
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
      );
    }
  }

  ListView buildPlacesList(){
    final placesWidget = places.map((f){
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.FONTSTYLE,
              fontWeight: Constants.APPBAR_TEXT_WEIGHT,
            ),
          ),
        ),
      ];
      if(f.formattedAddress != null){
        list.add(
          Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text(
              f.formattedAddress,
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.FONTSTYLE,
                fontWeight: Constants.APPBAR_TEXT_WEIGHT,
              ),
            ),
          ),
        );
      }

      if(f.vicinity != null){
        list.add(
          Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text(
              f.vicinity,
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.FONTSTYLE,
                fontWeight: Constants.APPBAR_TEXT_WEIGHT,
              ),
            ),
          ),
        );
      }

      if(f.types?.first != null){
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.types.first,
            style: TextStyle(
              color: Colors.black,
              fontFamily: Constants.FONTSTYLE,
              fontWeight: Constants.APPBAR_TEXT_WEIGHT,
            ),
          ),
        ));
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: (){
              showDetailPlace(f.placeId);
            },
            highlightColor: Colors.lightBlueAccent,
            splashColor: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList();
    return ListView(shrinkWrap: true, children: placesWidget);
  }

}