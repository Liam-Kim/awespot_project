import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: HexColor("#080808"),
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: HexColor("#757575"))),
        title: Text("설정", style: TextStyle(
          color: Colors.white,
        ),),
        centerTitle: true,
        backgroundColor: HexColor("#080808"),
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