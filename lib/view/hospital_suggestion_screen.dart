
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
final places =
GoogleMapsPlaces(apiKey: "AIzaSyCwIvvIxm9yn4JXoEHoaAx7wn2WySONi7M");

/// Hospital Suggestion screen page widget class
class HospitalSuggestion extends StatefulWidget{
  static const String id = "HospitalSuggestionPage";


  const HospitalSuggestion({Key key}) : super(key: key);
  @override
  _HospitalSuggestionState createState() => _HospitalSuggestionState();
}

/// Hospital Suggestion screen page state class
class _HospitalSuggestionState extends State<HospitalSuggestion> {
  Future<Position> _currentLocation;

  /// Set of markers to be drawn on the map
  Set<Marker> _markers = {};

  @override
  void initState(){
    super.initState();
    _currentLocation = Geolocator.getCurrentPosition();
  }


  Future<void> _retrieveNearbyHospitals(LatLng _userLocation) async{
    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(_userLocation.latitude, _userLocation.longitude), 10000, type: "hospital"
    );

    Set<Marker> _hospitalMarkers = _response.results.map((result) => Marker(
        markerId: MarkerId(result.name),
        /// Use an icon with different colors to differentiate between current location and the restaurants
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
            title: result.name,
            snippet: "Ratings: " + (result.rating?.toString() ?? "Not Rated")
        ),
        position: LatLng(
            result.geometry.location.lat, result.geometry.location.lng))).toSet();

    setState(() {
      _markers.addAll(_hospitalMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Constants.BACKGROUND_COLOUR,
          appBar: AppBar(
            title: Text(
              'Hospital Suggestion',
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
          body: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: _currentLocation,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                        /// The user location returned from the snapshot
                        Position snapshotData = snapshot.data;
                        LatLng _userLocation = LatLng(snapshotData.latitude, snapshotData.longitude);
                        if(_markers.isEmpty){
                          _retrieveNearbyHospitals(_userLocation);
                        }
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _userLocation,
                            zoom: 16.0,
                          ),
                          zoomGesturesEnabled: true,
                          markers: _markers..add(Marker(
                              markerId: MarkerId("User Location"),
                              infoWindow: InfoWindow(title: "My Current Location"),
                              position: _userLocation
                          )),
                        );
                      }else{
                        return Center(child: Text("Failed to get user location."));
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
    );
  }


}
