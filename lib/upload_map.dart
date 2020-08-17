import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'search_address.dart';

class MapSearchPage extends StatefulWidget {
  @override
  _MapSearchPageState createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  //FirebaseUser providerUser = Provider.of<UserRepository.>(context);
  bool isGetLocaton = false;
  var location = Location();
  int addressKey = 0;
  String _searchPlace = '검색';
  LatLng uploadPosition;
  MapController _mapController = MapController();

  Future<Null> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      uploadPosition = LatLng(userLocation.latitude, userLocation.longitude);
      print(uploadPosition);

      setState(() {
        isGetLocaton = true;
      });
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
  }

  @override
  void initState() {
    getLocation();

    super.initState();
  }

//test
  @override
  Widget build(BuildContext context) {
    return isGetLocaton
        ? Column(
            children: <Widget>[
              Container(
                  color: Colors.black,
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Divider(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
                              child: Text("업로드 모드",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18))),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.white))),
                          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.search,
                                size: 30,
                                color: Colors.white,
                              ),
                              Container(
                                width: 5,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    final result = Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WillPopScope(
                                                onWillPop: () {
                                                  Navigator.pop(context);
                                                },
                                                child: SearchAddress(
                                                    addressKey))));
                                    result.then((result) {
                                      setState(() {
                                        _searchPlace = result.name;
                                        uploadPosition = LatLng(
                                            result.geometry.location.lat,
                                            result.geometry.location.lng);
                                        _mapController.move(
                                            uploadPosition, 6.0);
                                        print("재설정된 위치");
                                        print(uploadPosition);
                                      });
                                    });
                                  },
                                  child: Text(
                                    _searchPlace,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  )),
              Expanded(
//                height: MediaQuery.of(context).size.height - 190,
//                width: MediaQuery.of(context).size.width,
                child: FlutterMap(
                  mapController: _mapController,
                  options: new MapOptions(
                    minZoom: 1.5,
                    maxZoom: 12.0,
                    center: uploadPosition,
                    zoom: 6.0,
                  ),
                  layers: [
                    new MarkerLayerOptions(markers: [
                      Marker(
                          point: uploadPosition,
                          builder: (context) => Container(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ))
                    ]),
                    new TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/liam29/ck599tpkb0qlv1djyswi4dzcx/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGlhbTI5IiwiYSI6ImNrNTk4OXd2cDBpbjczb29hN2F6dzg4NmsifQ.RduJfm1zIHzWEfYusIgaGQ",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoibGlhbTI5IiwiYSI6ImNrNTk4OXd2cDBpbjczb29hN2F6dzg4NmsifQ.RduJfm1zIHzWEfYusIgaGQ',
                        'id': 'mapbox.mapbox-streets-v8',
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Text("Loading...."),
          );
  }
}
