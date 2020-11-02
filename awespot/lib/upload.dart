import 'dart:core';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';


bool checkColor = false;
List<String> circleColor = ["#111E39", "#3B5284", "#ECAE00", "#F8CF5F", "#D47D7A", "#F1A3A0", "#FFFFFF"];
List<bool> circleBool = [false, false, false, false, false, false, false];
int idx = 0;

class UploadPage extends StatefulWidget{

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  final _titleTextConroller = TextEditingController();
  final _contentTextConroller = TextEditingController();
  var selectedItem ;
  var selected ;
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

      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print("url:"+dowurl.toString());
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

    if(images.length == 0){
      return buildInitAsset(context);
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
          ),
          onTap: (){
            Navigator.of(context).pop();
          },
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
                  child: selected == null ? Text("카테고리 선택", style: TextStyle(
                    color: HexColor("#FFFFFF"),
                  ),) : Text(
                    "$selected",
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
                        onPressed: () async{
                           selectedItem = await showModalBottomSheet(
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
                                        onTap: (){
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: false,
                                              isDismissible: false,
                                              builder: (BuildContext context) {
                                                return AddCategory();
                                              }
                                          );
                                        },
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
                                        onTap: (){
                                          print(selectedItem);
                                          setState(() {
                                            selected = selectedItem;
                                          });
                                          Navigator.of(context).pop();
                                        },
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
                                        selectedItem = categories[value];
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

class AddCategory extends StatefulWidget{
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    final _textController = TextEditingController();

    double height = query.size.height;

    return Container(
      height: height * 0.4,
      child: Scaffold(
        backgroundColor: HexColor("#424242"),
        appBar: AppBar(
          elevation: 0,
          shape: Border(bottom: BorderSide(color: HexColor("#B1B1B1"))),
          backgroundColor: HexColor("#424242"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            InkWell(
              child: Container(
                child: Center(
                  child: Text(
                    "생성",
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                    ),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
            ),
          ],
          title: Text("카테고리 선택"),
        ),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#E4E4E4")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#E4E4E4")),
                            ),
                            hintText: "카테고리를 입력하세요",
                            hintStyle: TextStyle(
                                color: HexColor("#9A9A9A")
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "카테고리 색",
                            style: TextStyle(
                              color: HexColor("#EFEFEF"),
                            ),
                          ),
                          SizedBox(height: 10,),
                          CreateCircleColor(),
                        ]
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}

class CreateCircleColor extends StatefulWidget{

  @override
  _CreateCircleColorState createState() => _CreateCircleColorState();
}

class _CreateCircleColorState extends State<CreateCircleColor> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () {
              if(circleBool[0] == true){
                setState(() {
                  circleBool[0] = false;
                });
              }
              else {
                setState(() {
                  circleBool[1] = false;
                  circleBool[2] = false;
                  circleBool[3] = false;
                  circleBool[4] = false;
                  circleBool[5] = false;
                  circleBool[6] = false;
                  circleBool[0] = true;
                });
              }
            },
            child: circleBool[0] ? Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(circleColor[0]),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ) : Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(circleColor[0]),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () {
              if(circleBool[1] == true){
                setState(() {
                  circleBool[1] = false;
                });
              }
              else {
                setState(() {
                  circleBool[0] = false;
                  circleBool[2] = false;
                  circleBool[3] = false;
                  circleBool[4] = false;
                  circleBool[5] = false;
                  circleBool[6] = false;
                  circleBool[1] = true;
                });
              }
            },
            child: circleBool[1] ? Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(circleColor[1]),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ) : Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(circleColor[1]),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () {
              if(circleBool[2] == true){
                setState(() {
                  circleBool[2] = false;
                });
              }
              else {
                setState(() {
                  circleBool[1] = false;
                  circleBool[0] = false;
                  circleBool[3] = false;
                  circleBool[4] = false;
                  circleBool[5] = false;
                  circleBool[6] = false;
                  circleBool[2] = true;
                });
              }
            },
            child: circleBool[2] ? Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(circleColor[2]),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ) : Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(circleColor[2]),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () {
              if(circleBool[3] == true){
                setState(() {
                  circleBool[3] = false;
                });
              }
              else {
                setState(() {
                  circleBool[1] = false;
                  circleBool[2] = false;
                  circleBool[0] = false;
                  circleBool[4] = false;
                  circleBool[5] = false;
                  circleBool[6] = false;
                  circleBool[3] = true;
                });
              }
            },
            child: circleBool[3] ? Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(circleColor[3]),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ) : Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(circleColor[3]),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () {
              if(circleBool[4] == true){
                setState(() {
                  circleBool[4] = false;
                });
              }
              else {
                setState(() {
                  circleBool[1] = false;
                  circleBool[2] = false;
                  circleBool[3] = false;
                  circleBool[0] = false;
                  circleBool[5] = false;
                  circleBool[6] = false;
                  circleBool[4] = true;
                });
              }
            },
            child: circleBool[4] ? Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(circleColor[4]),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ) : Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(circleColor[4]),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () {
              if(circleBool[5] == true){
                setState(() {
                  circleBool[5] = false;
                });
              }
              else {
                setState(() {
                  circleBool[1] = false;
                  circleBool[2] = false;
                  circleBool[3] = false;
                  circleBool[4] = false;
                  circleBool[0] = false;
                  circleBool[6] = false;
                  circleBool[5] = true;
                });
              }
            },
            child: circleBool[5] ? Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(circleColor[5]),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ) : Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(circleColor[5]),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: InkWell(
            onTap: () {
              if(circleBool[6] == true){
                setState(() {
                  circleBool[6] = false;
                });
              }
              else {
                setState(() {
                  circleBool[1] = false;
                  circleBool[2] = false;
                  circleBool[3] = false;
                  circleBool[4] = false;
                  circleBool[5] = false;
                  circleBool[0] = false;
                  circleBool[6] = true;
                });
              }
            },
            child: circleBool[6] ? Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(circleColor[6]),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ) : Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor(circleColor[6]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}