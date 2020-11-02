import 'package:flutter/material.dart';
import 'setting.dart';

class ProfilePage extends StatelessWidget{

  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
      count,
          (int index) => Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Image.asset('tendency.png', fit: BoxFit.fill),
            ),
          ],
        ),
      ),
    );

    return cards;
  }
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
        body: TabBarView(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 28, 20, 28),
                  child: Text("여행성향",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: Container(
                    child: Image(image: AssetImage('tendency.png')),
                  )
                )
              ],
            ),
            ListView(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 28, 20, 28),
                    child: Text("어스팟 뱃지",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor("#202020"),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    height: 70,
                                    width: 70,
                                    child: Image(image: AssetImage("gold.png"),),
                                  ),
                                ],
                              ),
                              Text("다이아 뱃지",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor("#202020"),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    height: 70,
                                    width: 70,
                                    child: Image(image: AssetImage("gold.png"),),
                                  ),
                                ],
                              ),
                              Text("골드 뱃지",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor("#202020"),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    height: 70,
                                    width: 70,
                                    child: Image(image: AssetImage("gold.png"),),
                                  ),
                                ],
                              ),
                              Text("실버 뱃지",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),),
                            ],
                          ),
                        )
                      ],
                    ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: Text("달성한 업적",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor("#202020"),
                      ),
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Image(image: AssetImage("save.png"),),
                                  height: 70,
                                  width: 70,
                                ),
                                Text("내 맘속에 저장",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Image(image: AssetImage("receive.png"),),
                                  height: 70,
                                  width: 70,
                                ),
                                Text("내 스팟을 받아라",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Image(image: AssetImage("twinkle.png"),),
                                  height: 70,
                                  width: 70,
                                ),
                                Text("별이 빛나는 지도",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                ),
              ],
            ),

            ListView(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: Text("지정한 스팟",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                ),
                 GridView.count(
                    crossAxisCount: 2,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(20.0),
                    childAspectRatio: 8.0 / 9.0,
                    shrinkWrap: true,
                    children: _buildGridCards(10),
                    // Replace
                  ),
              ],
            )
          ],
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