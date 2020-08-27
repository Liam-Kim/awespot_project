import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:switch_it/switch_it.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';

class UploadPage extends StatefulWidget{

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  final _titleTextConroller = TextEditingController();
  final _contentTextConroller = TextEditingController();
  bool status = false;
  StorageReference storageImageRef;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool checkClicked = false;
  Location location = Location();
  List<double> gpsLatitude = List<double>();
  List<double> gpsLongtitude = List<double>();
  List<String> categories = [
    "카테고리 미분류", "새내기들과의 부산여행", "2020 나의 첫 배낭여행"
  ];


  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Widget showGPS(){
    String location = "위치 정보 없음";
    double latitude = 0.0;
    double longtitue = 0.0;

    for(int i=0; i<gpsLongtitude.length; i++){
      if(gpsLongtitude[i] != null){
        longtitue = gpsLongtitude[i];
        latitude = gpsLatitude[i];
        break;
      }
    }

    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Text(
          longtitue != 0.0 && latitude != 0.0 ? "위도: ${latitude}, 경도: ${longtitue}" : location ,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<Null> _uploadImages() async {
      print("Length: ${images.length}");
     images.forEach((f) async {
      File image = await getImageFileFromAssets(f);
      print("imagepath: ${image.path}");
      DateTime nowtime = new DateTime.now();
      final StorageReference _ref = _firebaseStorage.ref().child("$nowtime");

      final StorageUploadTask uploadTask = _ref.putFile(image);

      await uploadTask.onComplete;
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    Metadata metadata;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#2E2E2E",
          actionBarTitle: "최대 5장",
          allViewTitle: "All Photos",
          useDetailsView: true,
          startInAllView: true,
          actionBarTitleColor: "#2E2E2E",
          selectCircleStrokeColor: "#000000",
        ),
      );

      print(resultList.length);
    } on Exception catch (e) {
      error = e.toString();
    }

    for(int i=0; i<resultList.length; i++){
      Metadata metadata = await resultList[i].requestMetadata();
      gpsLatitude.add(metadata.gps.gpsLatitude);
      gpsLongtitude.add(metadata.gps.gpsLongitude);
    }


    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });

  }


  Widget buildInitAsset(BuildContext context){
    MediaQueryData queryData = MediaQuery.of(context);
    double width = queryData.size.width;
    double height = queryData.size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(width*0.05, height*0.01, width*0.05, height*0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width*0.3,
            height: width*0.3,
            child: InkWell(
              child: Icon(
                Icons.photo_camera,
                color: Colors.white,
                size: width*0.15,
              ),
              onTap: (){
                loadAssets();
                setState(() {
                  checkClicked = true;
                });
              },
            ),
            decoration: BoxDecoration(
              border: Border.all(color: HexColor("#FFFFFF")),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageView(BuildContext context){
    MediaQueryData query = MediaQuery.of(context);

    int widthInt = (query.size.width*0.3).toInt();
    int heightInt = (query.size.height*0.3).toInt();


    print("images.length: ${images.length}");

    for(int i=0; i<images.length; i++){
      print(i);
    }

    return Container(
      padding: EdgeInsets.all(10),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, i){
          return Container(
            margin: EdgeInsets.all(10),
            width: query.size.width*0.3,
            height: query.size.width*0.3,
            child: AssetThumb(
              width: 1000,
              height: 1000,
              asset: images[i],
            ),
          );
        },
      ),
    );

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    double width = query.size.width;
    double height = query.size.height;

    return Scaffold(
      backgroundColor: HexColor("#121212"),
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: HexColor("#B1B1B1"))),
        leading: InkWell(
          child: Center(
            child: Text(
                "뒤로",
              style: TextStyle(
                color: HexColor("#9A9A9A"),
              ),
            ),
          )
        ),
        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Center(
                child: Text(
                  "완료",
                  style: TextStyle(
                    color: HexColor("#FFFFFF"),
                  ),
                ),
              )
            ),
            onTap: _uploadImages,
          ),
        ],
        backgroundColor: HexColor("#2E2E2E"),
        title: Text(
            "스팟 추가",
          style: TextStyle(
            fontSize: width*0.035,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: width,
          height: height*0.25,
          color: HexColor("#121212"),
          child: Column(
            children: [
              Container(
                child: Divider(thickness: 0.3, color: HexColor("#E5E5E5"), ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(width*0.04, 0,width*0.04, 0),
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, width*0.04, 0),
                    width: width*0.7,
                    child: Text(
                      "태그 추가",
                      style: TextStyle(
                        color: HexColor("#E5E5E5"),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(width*0.04, 0, width*0.04,0),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ],
              ),
              Container(
                child: Divider(thickness: 0.3, color: HexColor("#E5E5E5"), ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(width*0.04, 0,width*0.04, 0),
                    child: Icon(
                      Icons.people,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, width*0.04, 0),
                    width: width*0.7,
                    child: Text(
                      "함께한 친구",
                      style: TextStyle(
                        color: HexColor("#E5E5E5"),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(width*0.04, 0, width*0.04,0),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ],
              ),
              Container(
                child: Divider(thickness: 0.3, color: HexColor("#E5E5E5"), ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(width*0.04, 0, width*0.05, 0),
                    width: width*0.83,
                    child: Text(
                      "콘텐츠 공개 여부",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(width*0.04, 0, width*0.04,0),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          checkClicked ?  buildImageView(context) : buildInitAsset(context),
          showGPS(),
          SizedBox(height: 10,),
          Container(
            child: Divider(thickness: 0.3, color: HexColor("#E5E5E5"), ),
          ),//TODO: Divider
          Padding(
            padding: EdgeInsets.fromLTRB(width*0.1, 0,0,0),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "카테고리 선택",
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(width*0.6, 0, width*0.04,0),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          showModalBottomSheet<void>(
                              isScrollControlled: false,
                              isDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                            return Container(
                                height: height*0.4,
                                child: Scaffold(
                                  backgroundColor: HexColor("#424242"),
                                  appBar: AppBar(
                                    elevation: 0,
                                    shape: Border(bottom: BorderSide(color: HexColor("#B1B1B1"))),
                                    backgroundColor: HexColor("#424242"),
                                    centerTitle: true,
                                    leading: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                    actions: [
                                      InkWell(
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: Center(
                                              child: Text(
                                                "추가",
                                                style: TextStyle(
                                                  color: HexColor("#ECAE00"),

                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: Center(
                                              child: Text(
                                                "완료",
                                                style: TextStyle(
                                                  color: HexColor("#9A9A9A"),
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                    title: Text(
                                      "카테고리",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ),
                                  body: CupertinoPicker.builder(
                                    backgroundColor: HexColor("#424242"),
                                    onSelectedItemChanged: (value) {
                                    },
                                    itemExtent: 40.0,
                                      childCount: categories.length,
                                    itemBuilder: (context, i) {
                                      return Text(
                                       categories[i],
                                        style: TextStyle(
                                          color: Colors.white,

                                        ),
                                      );
                                    }
                                  ),
                                ),
                            );
                          });
                        },
                      ),
                    )
                ), //TODO: Cilcked Arrow
              ],
            ),
          ),//TODO: 카테고리
          Container(
            child: Divider(thickness: 0.3, color: HexColor("#E5E5E5"), ),
          ), //TODO: Divider
          Container(
            padding: EdgeInsets.fromLTRB(query.size.width*0.1,0,query.size.width*0.1,0),
              child: TextField(
                controller: _titleTextConroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "제목을 입력하세요.",
                    hintStyle: TextStyle(
                        color: HexColor("#9A9A9A")
                    )
                ),
              ),
          ),//TODO: 제목을 입력하세요
          Container(
              child: Divider(thickness: 0.3, color: HexColor("#E5E5E5"), ),
          ),//TODO: Divider
          Container(
            padding: EdgeInsets.fromLTRB(query.size.width*0.1,0,query.size.width*0.1,0),
            child: TextField(
              controller: _contentTextConroller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "스팟에 대해 자유롭게 적어주세요.",
                  hintStyle: TextStyle(
                      color: HexColor("#9A9A9A")
                  )
              ),
            ),
          ),//TODO: 스팟에 대해 자유롭게 적어주세요
        ],
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}