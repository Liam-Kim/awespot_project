import 'package:awespot/upload.dart';
import 'package:awespot/map.dart';
import 'package:awespot/community.dart';
import 'package:awespot/profile.dart';
import 'package:awespot/search.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'dart:async';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _cIndex = 0;
  List<Asset> images = List<Asset>();
  List<Widget> _pages = [SearchPage(), MapPage(), UploadPage(), CommunityPage(), ProfilePage()];
  String _error = 'No Error Dectected';

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    double width = query.size.width;
    double height = query.size.height;
//    Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => UploadPage()));
    return new Scaffold(
      backgroundColor: Colors.black26,
      body: _pages[_cIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor("#080808"),
        selectedItemColor: HexColor("#ECAE00"),
        unselectedItemColor: HexColor("#DADADA"),
        type: BottomNavigationBarType.fixed,
        currentIndex: _cIndex,
        items: [
           BottomNavigationBarItem(
            icon: Icon(Icons.star_border, size: 30,),
             title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.cloud_circle, size: 30),
            title: new Text(""),
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              child: IconButton(
                icon: Icon(
                  Icons.add_box,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPage()),
                );
              },
            ),
            title: new Text(""),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.chat, size: 30),
            title: new Text(""),
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              child: IconButton(
                icon: Icon(
                  Icons.perm_identity,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            title: new Text(""),
          ),
        ],
        onTap: (index){
          _incrementTab(index);
        },
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