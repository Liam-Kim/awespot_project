import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:awespot_project/widget/change_hexcolor.dart';
import 'search_address.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as lo;
import "package:latlong/latlong.dart";

class MapLocation extends StatefulWidget {
  @override
  _MapLocationState createState() => _MapLocationState();
}

class _MapLocationState extends State<MapLocation> {
  GooglePlace googlePlace; //for get address name from coordinate
  DetailsResult _updatedInfo;
  bool isGetLocaton = false;
  UserLocation _currentLocation;
  var location = lo.Location();
  MapController _mapctl = MapController();

  bool isGetStarLocation = false;

  String addressName = "";

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
      setState(() {
        isGetLocaton = true;
      });
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }

  void updateInformation() {
    setState(() {
      addressName = _updatedInfo.name;
      print(_updatedInfo.geometry.location.lat);
      _mapctl.move(
          LatLng(_updatedInfo.geometry.location.lat,
              _updatedInfo.geometry.location.lng),
          10.0);
    });
  }

  Future getDetailAddress() async {
    _updatedInfo = await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => SearchAddress()),
    );
  }

  @override
  void initState() {
    googlePlace = GooglePlace('AIzaSyDVAWSg1M4az9jXbvZcaoC0XFOTyuIqvfI');
    getLocation();
    super.initState();
  }

//test
  @override
  Widget build(BuildContext context) {
    //final UserRepository providerUser = Provider.of<UserRepository>(context);
    return isGetLocaton
        ? Scaffold(
            body: Container(
                child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapctl,
                  options: new MapOptions(
                    minZoom: 1.5,
                    maxZoom: 12.0,
                    center: LatLng(
                        _currentLocation.latitude, _currentLocation.longitude),
                    zoom: 10.0,
                  ),
                  layers: [
                    new TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/liam29/ckeiay0a64ma319o3ey7tlczm/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGlhbTI5IiwiYSI6ImNrNTk4OXd2cDBpbjczb29hN2F6dzg4NmsifQ.RduJfm1zIHzWEfYusIgaGQ",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoibGlhbTI5IiwiYSI6ImNrNTk4OXd2cDBpbjczb29hN2F6dzg4NmsifQ.RduJfm1zIHzWEfYusIgaGQ',
                        'id': 'mapbox.mapbox-streets-v8',
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: HexColor("#B1B1B1"), width: 0.5))),
                        height: 50,
                        margin: EdgeInsets.only(top: 38),
                        //padding: EdgeInsets.only(bottom: 35),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 17),
                              child: InkWell(
                                  child: Text(
                                    "뒤로",
                                    style: TextStyle(
                                      color: HexColor("#B8BBC1"),
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context).pop()),
                            ),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "스팟 선택",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(right: 17),
                              child: InkWell(
                                child: Text(
                                  "확인",
                                  style: TextStyle(
                                      color: HexColor("ECAE00"),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () =>
                                    Navigator.of(context).pop(_updatedInfo),
                              ),
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          addressName,
                          style: TextStyle(
                              color: HexColor("#B8BBC1"), fontSize: 14),
                        )),
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "스팟수정",
                            style: TextStyle(
                                color: HexColor("#FF6969"), fontSize: 10),
                          )),
                      onTap: () {
                        getDetailAddress().then((value) => updateInformation());
                      },
                    ),
                  ],
                ),
              ],
            )),
          )
        : Scaffold(
            body: Center(
            child: Text("Loading...."),
          ));
  }

//get address name. Alt - pakacage geolocator
  void getDetils(double lat, double lng) async {
    var result = await this
        .googlePlace
        .search
        .getNearBySearch(Location(lat: lat, lng: lng), 1);
    if (result != null && result.results != null && mounted) {
      setState(() {
      });
    }
  }
}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({this.latitude, this.longitude});
}
