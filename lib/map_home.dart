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

class _MapHomeState extends State<MapHome> with TickerProviderStateMixin {
  List<String> dummy = [
    'http://travel.chosun.com/site/data/img_dir/2017/06/30/2017063001239_0.jpg',
    'https://i.pinimg.com/originals/3d/f8/f6/3df8f6ea7e407f8e1ed90d1ebcfcfccf.jpg',
    'https://p4.wallpaperbetter.com/wallpaper/55/365/257/tourism-sea-sky-vacation-wallpaper-preview.jpg'
  ];
  bool isGetLocaton = false;
  UserLocation _currentLocation;
  var location = lo.Location();
  //GoogleMapController mapController;
  int _index;
  MapController mapController = MapController();
  String boxtest = "처음이라요";

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
    print("test marker point");
    print(markersGreen[0].point.latitude);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
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
              Positioned.fill(
                child: FlutterMap(
                  mapController: mapController,
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
                          "https://api.mapbox.com/styles/v1/liam29/ckeiay0a64ma319o3ey7tlczm/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGlhbTI5IiwiYSI6ImNrNTk4OXd2cDBpbjczb29hN2F6dzg4NmsifQ.RduJfm1zIHzWEfYusIgaGQ",
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
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        height: 199,
                        child: PageView.builder(
                            itemCount: 3,
                            controller: PageController(viewportFraction: 0.8),
                            onPageChanged: (int index) {
                              setState(() {
                                _index = index;
                                _animatedMapMove(markersGreen[_index].point, 8);
                                // _mapctl.move(markersGreen[_index].point, 6);
                              });

                              // _mapctl.move(LatLng(36.7894662, 127.1073744), 3);
                            },
                            itemBuilder: (context, i) {
                              return Container(
                                alignment: Alignment.bottomLeft,
                                margin: EdgeInsets.only(left: 8, right: 8),
                                height: 199,
                                width: 288,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        dummy[i],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      foregroundDecoration: BoxDecoration(
                                          color: Colors.white,
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topLeft,
                                              colors: [
                                                Colors.black12,
                                                Colors.white
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(7.0)),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5, bottom: 5),
                                          child: Text(
                                            "$i" + "번째 여행이다아 놀러가고 싶다",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            }),
                      )))
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
