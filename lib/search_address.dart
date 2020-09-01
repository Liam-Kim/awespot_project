
import 'package:awespot_project/widget/change_hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class SearchAddress extends StatefulWidget {
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  DetailsResult detailsResult;

  @override
  void initState() {
    //  String apiKey = DotEnv().env['AIzaSyDVAWSg1M4az9jXbvZcaoC0XFOTyuIqvfI'];
    googlePlace = GooglePlace('AIzaSyDVAWSg1M4az9jXbvZcaoC0XFOTyuIqvfI');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#202020"),
      body: SafeArea(
        child: Container(
          //margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: HexColor("#B1B1B1"), width: 0.5))),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: null)),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        autofocus: true,
                        cursorColor: Colors.white,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            autoCompleteSearch(value);
                          } else {
                            if (predictions.length > 0 && mounted) {
                              setState(() {
                                predictions = [];
                              });
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      child: Icon(
                        Icons.my_location,
                        color: HexColor("#ECAE00"),
                        size: 22,
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: InkWell(
                            child: Text("확인",
                                style: TextStyle(
                                    fontSize: 14, color: HexColor("#FFFFFF")))))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 22,
                      ),
                      title: Text(
                        predictions[index].description,
                        style:
                            TextStyle(color: HexColor("#FFFFFF"), fontSize: 14),
                      ),
                      onTap: () {
                        debugPrint(predictions[index].placeId);
                        getDetils(predictions[index].placeId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDetils(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        
        detailsResult = result.result;
        print(detailsResult.addressComponents[2].shortName);
        print(detailsResult.addressComponents[1].longName);
        print(detailsResult.addressComponents[0].longName);
        print(detailsResult.geometry.location.lat);
        print(detailsResult.name);
        Navigator.pop(context, detailsResult);
      });
    }
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}
