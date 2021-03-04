
import 'dart:async';
import 'package:HealthGuard/view/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:google_maps_webservice/places.dart' as webGoogle;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

/// Passing the Google CLoud api key into google map function
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Constants.GoogleApiKey);


class HospitalSuggestions extends StatefulWidget{
  static const String id = "HospitalSuggestionsPage";
  const HospitalSuggestions({Key key}) : super(key: key);
  @override
  _HospitalSuggestionsState createState() => _HospitalSuggestionsState();
}

class _HospitalSuggestionsState extends State<HospitalSuggestions>{
  Future<Position> _currentLocation;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  Set<Marker> markers = {};


  /// Retrieving the user's current position in Latitude and Longitude
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

  @override
  void initState() {
    super.initState();
    /// Retrieving the user's most current position
    _currentLocation = Geolocator.getCurrentPosition();
  }

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

            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: SizedBox(
                  height: 400.0,
                  width: 400.0,
                  child: Container(
                    /// Displays the google map widget
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(markers),
                      /// Sets the initial position of the user
                      initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: expandedChild,)
        ],
      ),

    );
  }

  /// Button on the upper right to allow users to recenter themselves
  void refresh() async{
    final center = await getUserLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: center == null ? LatLng(0,0) : center, zoom: 15.0)));
    getNearbyHospital(center);
  }

  void _onMapCreated(GoogleMapController controller) async{
    mapController = controller;
    refresh();
  }

  /// To handle the search of nearby hospital
  void getNearbyHospital(LatLng center) async{
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
      markers.clear();
    });

    /// The keyword of the search is here, e.g. to search for pharmacy, change the word hospital to pharmacy
    final result = await _places.searchNearbyWithRadius(new webGoogle.Location(center.latitude, center.longitude), 10000, type: "hospital");
    setState(() {
      this.isLoading = false;
      if(result.status == "OK"){
        this.places = result.results;
        Set<Marker> _hospitalMarkers = result.results
            .map((r) => Marker(
            markerId: MarkerId(r.name),
            /// Use an icon with different colors to differentiate between current location and the hospital
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
                title: r.name,
                snippet: "Ratings: " + (r.rating?.toString() ?? "Not Rated")),
            position: LatLng(
                r.geometry.location.lat, r.geometry.location.lng)))
            .toSet();

        setState(() {
          markers.addAll(_hospitalMarkers);
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

  /// Redirecting user to another page if they pressed onto the cards below the map
  Future<void> _handlePressButton() async{
    try{
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false: true,
          apiKey: Constants.GoogleApiKey,
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

  /// Handles the redirecting of users to the PlaceDetailScreen
  Future<Null> showDetailPlace(String placeId) async{
    if(placeId != null){
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlaceDetailScreen(placeId)),
      );
    }
  }

  /// Handles the output of the place detail in the card below the map
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