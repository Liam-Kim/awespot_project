import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:provider/provider.dart';
import 'user_repository.dart';

import 'package:location/location.dart' as lo;
import "package:latlong/latlong.dart";

class MapHome extends StatefulWidget {
  @override
  _MapHomeState createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  bool isGetLocaton = false;
  UserLocation _currentLocation;
  var location = lo.Location();
  //GoogleMapController mapController;

  bool isGetStarLocation = false;
  List<Marker> markers;
  List<Marker> markersRed;
  List<Marker> markersYellow;
  List<Marker> markersGreen;
  int pointIndex = 0;
  int pointIndexRed = 0;
  int pointIndexYellow = 0;
  int pointIndexGreen = 0;
  List points;
  List pointsRed;
  List pointsYellow;
  List pointsGreen;
  final double starSize = 40;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
      print(userLocation.latitude);
      print(userLocation.longitude);

      setState(() {
        isGetLocaton = true;
      });
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }

  Future<Null> getStarLocation() async {
    try {
      //get data from firebase
      points = [
        LatLng(37.5408422, 127.1967538),
        LatLng(37.5408422 + 1, 127.1967538),
        LatLng(37.5408422 - 1, 127.1967538 - 1),
        LatLng(37.5408422 + 1, 127.1967538 - 1),
      ];

      pointsRed = [
        LatLng(37.5408422, 127.1967538),
        LatLng(37.5408422 + 0.5, 127.1967538),
        LatLng(37.5408422 - 0.5, 127.1967538 - 0.5),
        LatLng(37.5408422 + 0.5, 127.1967538 - 0.5),
      ];
      pointsYellow = [
        LatLng(37.5408422 + 0.4, 127.1967538),
        LatLng(37.5408422, 127.1967538 + 0.4),
        LatLng(37.5408422 + 0.4, 127.1967538 + 0.4),
        LatLng(37.5408422 - 0.4, 127.1967538 + 0.4),
      ];
      pointsGreen = [
        LatLng(37.5408422, 127.1967538 + 0.3),
        LatLng(37.5408422 + 0.3, 127.1967538),
        LatLng(37.5408422 - 0.3, 127.1967538 - 0.3),
        LatLng(37.5408422 + 0.3, 127.1967538 - 0.3),
      ];

      markersGreen = [
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsGreen[pointIndexGreen++],
          builder: (ctx) => Image.asset(
            "assets/greenstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsGreen[pointIndexGreen++],
          builder: (ctx) => Image.asset(
            "assets/greenstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsGreen[pointIndexGreen++],
          builder: (ctx) => Image.asset(
            "assets/greenstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsGreen[pointIndexGreen++],
          builder: (ctx) => Image.asset(
            "assets/greenstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
      ];

      markersYellow = [
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsYellow[pointIndexYellow++],
          builder: (ctx) => Image.asset(
            "assets/yellowstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsYellow[pointIndexYellow++],
          builder: (ctx) => Image.asset(
            "assets/yellowstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsYellow[pointIndexYellow++],
          builder: (ctx) => Image.asset(
            "assets/yellowstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsYellow[pointIndexYellow++],
          builder: (ctx) => Image.asset(
            "assets/yellowstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
      ];

      markersRed = [
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsRed[pointIndexRed++],
          builder: (ctx) => Image.asset(
            "assets/redstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsRed[pointIndexRed++],
          builder: (ctx) => Image.asset(
            "assets/redstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsRed[pointIndexRed++],
          builder: (ctx) => Image.asset(
            "assets/redstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: pointsRed[pointIndexRed++],
          builder: (ctx) => Image.asset(
            "assets/redstar.png",
            width: starSize,
            height: starSize,
          ),
        ),
      ];

      markers = [
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: points[pointIndex++],
          builder: (ctx) => Image.asset(
            "assets/bluestar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: points[pointIndex++],
          builder: (ctx) => Image.asset(
            "assets/bluestar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: points[pointIndex++],
          builder: (ctx) => Image.asset(
            "assets/bluestar.png",
            width: starSize,
            height: starSize,
          ),
        ),
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: points[pointIndex++],
          builder: (ctx) => Image.asset(
            "assets/bluestar.png",
            width: starSize,
            height: starSize,
          ),
        ),
      ];
      setState(() {
        isGetStarLocation = true;
      });
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
  }

  @override
  void initState() {
    getLocation();
    getStarLocation();

    print("get location");

    super.initState();
  }

//test
  @override
  Widget build(BuildContext context) {
    //final UserRepository providerUser = Provider.of<UserRepository>(context);
    return isGetLocaton //&& isGetStarLocation
        ? Container(
            child: Stack(
            children: [
              FlutterMap(
                options: new MapOptions(
                  minZoom: 1.5,
                  maxZoom: 12.0,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                  center: LatLng(
                      _currentLocation.latitude, _currentLocation.longitude),
                  zoom: 3.0,
                ),
                layers: [
                  new TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/liam29/ckdyrk8ut03sq1aquldyi7nz8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGlhbTI5IiwiYSI6ImNrNTk4OXd2cDBpbjczb29hN2F6dzg4NmsifQ.RduJfm1zIHzWEfYusIgaGQ",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoibGlhbTI5IiwiYSI6ImNrNTk4OXd2cDBpbjczb29hN2F6dzg4NmsifQ.RduJfm1zIHzWEfYusIgaGQ',
                      'id': 'mapbox.mapbox-streets-v8',
                    },
                  ),
                  MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    markers: markersRed,
                    builder: (context, markersRed) {
                      return Container(
                        child: Image.asset(
                          "assets/redstar.png",
                          width: starSize * 2,
                          height: starSize * 2,
                          color: Colors.red[200],
                        ),
                      );
                    },
                  ),
                  MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    markers: markers,
                    builder: (context, markers) {
                      return Container(
                        child: Image.asset(
                          "assets/bluestar.png",
                          width: starSize * 2,
                          height: starSize * 2,
                        ),
                      );
                    },
                  ),
                  MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    markers: markersYellow,
                    builder: (context, markersYellow) {
                      return Container(
                        child: Image.asset(
                          "assets/yellowstar.png",
                          width: starSize * 2,
                          height: starSize * 2,
                          color: Colors.yellow[100],
                        ),
                      );
                    },
                  ),
                  MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    markers: markersGreen,
                    builder: (context, markersGreen) {
                      return Container(
                        child: Image.asset("assets/greenstar.png",
                            width: starSize * 2,
                            height: starSize * 2,
                            color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ],
          ))
        : Center(
            child: Text("Loading...."),
          );
  }
}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({this.latitude, this.longitude});
}
