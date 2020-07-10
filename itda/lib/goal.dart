import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itda/goal_list.dart';
import 'goal_list.dart';

class GoalPage extends StatefulWidget{
  final String email;
  GoalPage({Key key,@required this.email}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final _todaytextController = TextEditingController();
  final _weektextController = TextEditingController();
  final _yeartextController = TextEditingController();

   String today =" ";
   String week = "";
   String year="";
   FirebaseUser user ;

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        today =snapshot.data["today"];
        week = snapshot.data["week"];
        year = snapshot.data["year"];
      });
    });

  }

  Future<void> todayUpdate(String today) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'today' : today,
    });
  }

  Future<void> weekUpdate(String week) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'week' : week,
    });
  }

  Future<void> yearUpdate(String year) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'year' : year,
    });
  }

  @override
  void initState() {

    super.initState();
    getUser();
  }

  Widget _todaybuildTextComposer() {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child:  Row(                             // NEW
        children: [
          Flexible(                           // NEW
            child:  TextField(
              controller: _todaytextController,
              onSubmitted: _todayhandleSubmitted,
              decoration:  InputDecoration.collapsed(
                  hintText: "오늘의 목표"),
            ),
          ), // NEW
          Flexible(                           // NEW
            child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _todayhandleSubmitted(_todaytextController.text)),
          ),                                    // NEW
        ],                                      // NEW
      ),                                        // NEW
    );
  }

  Widget _weekbuildTextComposer() {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child:  Row(                             // NEW
        children: [
          Flexible(                           // NEW
            child:  TextField(
              controller: _weektextController,
              onSubmitted: _weekhandleSubmitted,
              decoration:  InputDecoration.collapsed(
                  hintText: "이번 주의 목표"),
            ),
          ), // NEW
          Flexible(                           // NEW
            child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _weekhandleSubmitted(_weektextController.text)),
          ),                                    // NEW
        ],                                      // NEW
      ),                                        // NEW
    );
  }

  Widget _yearbuildTextComposer() {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child:  Row(                             // NEW
        children: [
          Flexible(                           // NEW
            child:  TextField(
              controller: _yeartextController,
              onSubmitted: _yearhandleSubmitted,
              decoration:  InputDecoration.collapsed(
                  hintText: "올해의 목표"),
            ),
          ), // NEW
          Flexible(                           // NEW
            child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _yearhandleSubmitted(_yeartextController.text)),
          ),                                    // NEW
        ],                                      // NEW
      ),                                        // NEW
    );
  }

  void _todayhandleSubmitted(String text) {
    todayUpdate(text);
    setState(() {
      today = text;
    });
    _todaytextController.clear();
  }
  void _weekhandleSubmitted(String text) {
    weekUpdate(text);
    setState(() {
      week = text;
    });

    _weektextController.clear();
  }
  void _yearhandleSubmitted(String text) {
    yearUpdate(text);
    setState(() {
      year = text;
    });

    _yeartextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
              elevation: 0,
              backgroundColor: HexColor("#e9f4eb"),
              centerTitle: true,
              actions: [
                Container(
                  width: 40,
                )
              ],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "목표를 ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 28,
                    child: Image.asset("assets/Itda_black.png"),
                  ),
                ],
              )
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 400,
                          height: 400,
                          child:  Image.asset(
                            'assets/tree.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 100,),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "오늘의 목표: ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  today,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "이번 주의 목표: ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  week,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "올해의 목표: ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  year,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "내 목표를 정하고\n"
                          "친구들과 이야기하여\n"
                          "실천 의지를 높여요",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  _todaybuildTextComposer(),
                  _weekbuildTextComposer(),
                  _yearbuildTextComposer(),
                ],
              ),
            ),
          ),
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

