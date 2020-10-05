import 'package:flutter/material.dart';
import 'setting.dart';

class ProfilePage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    double width = queryData.size.width;
    double height = queryData.size.height;

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: HexColor("#080808"),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: HexColor("#FFFFFF"),),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            )
          ],
          backgroundColor:  HexColor("#080808"),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height*0.1,),
                  Icon(
                    Icons.account_circle,
                    size: 130.0,
                    color: Colors.white,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '인혜 박',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'inhye0108',
                        style: TextStyle(color: HexColor("#808080")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.square(height*0.4),
            child: TabBar(
              indicatorColor: HexColor("#ECAE00"),
              labelColor: HexColor("#424242"),
              tabs: [
                Text("프로필", style: TextStyle(
                  color: Colors.white,
                ),),
                Text("업적", style: TextStyle(
                  color: Colors.white,
                ),),
                Text("보관함", style: TextStyle(
                  color: Colors.white,
                ),),
              ],
            ),
          ),
        ),
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