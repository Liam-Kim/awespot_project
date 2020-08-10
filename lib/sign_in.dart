import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'user_repository.dart';

class SignInPage extends StatefulWidget {
  final UserRepository user;

  SignInPage({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  SignInPageState createState() => new SignInPageState(
        user: user,
      );
}

class SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String genderValidation = "";
  Color borderColor = Colors.blue;
  List<bool> isSelected;
  SignInPageState({
    Key key,
    @required this.user,
  });
  final UserRepository user;
  final nickNameController = TextEditingController();
  final yearController = TextEditingController();
  final monthController = TextEditingController();
  final dayController = TextEditingController();
  final contryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    isSelected = [false, false];
    super.initState();
    //nickNameController.text = currentUserId;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    contryController.dispose();
    nickNameController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "회원가입",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("닉네임",
                        style: TextStyle(color: Colors.grey, fontSize: 17))),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15),
                      WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9_]"))
                    ],
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: "영어, 숫자, '_' 만 사용가능.",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    controller: nickNameController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return '닉네임을 입력해주세요.';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("생년월일",
                        style: TextStyle(color: Colors.grey, fontSize: 17))),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'ex) 19xx';
                            }
                            return null;
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[0-9]")),
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: "ex) 19xx",
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "년도",
                            labelStyle:
                                TextStyle(fontSize: 17, color: Colors.grey),
                          ),
                          textInputAction: TextInputAction.done,
                          controller: yearController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'ex) 8';
                            }
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            WhitelistingTextInputFormatter(RegExp("[0-9]"))
                          ],
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: "ex) 8",
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "월",
                            labelStyle:
                                TextStyle(fontSize: 17, color: Colors.grey),
                          ),
                          textInputAction: TextInputAction.done,
                          controller: monthController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                        child: TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'ex) 12';
                            }
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            WhitelistingTextInputFormatter(RegExp("[0-9]"))
                          ],
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: "ex) 12",
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "일",
                            labelStyle:
                                TextStyle(fontSize: 17, color: Colors.grey),
                          ),
                          textInputAction: TextInputAction.done,
                          controller: dayController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width / 10 * 9.5,
                    child: Text("성별",
                        style: TextStyle(fontSize: 17, color: Colors.grey))),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ToggleButtons(
                    borderColor: Colors.grey,
                    fillColor: Colors.blue,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 10 * 4.5,
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          "남",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 14,
                        width: MediaQuery.of(context).size.width / 10 * 4.5,
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          "여",
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          if (i == index) {
                            isSelected[i] = true;
                          } else {
                            isSelected[i] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),
                ),
                Container(
                  // padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(genderValidation,
                      style: TextStyle(fontSize: 12, color: Color(0xffDC2A2A))),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 10),
                //   padding: EdgeInsets.all(10),
                //   child: TextFormField(
                //     validator: (String value) {
                //       if (value.isEmpty) {
                //         return '국가를 입력해주세요.';
                //       }
                //       return null;
                //     },
                //     inputFormatters: [
                //       LengthLimitingTextInputFormatter(10),
                //     ],
                //     decoration: InputDecoration(
                //       labelText: "국가",
                //       labelStyle: TextStyle(fontSize: 17, color: Colors.grey),
                //     ),
                //     textInputAction: TextInputAction.done,
                //     controller: contryController,
                //     style: TextStyle(color: Colors.grey),
                //   ),
                // ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        child: ButtonTheme(
                          height: 60,
                          buttonColor: Colors.blue,
                          child: FlatButton(
                            child: Text(
                              "취소",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () async {
                              Provider.of<UserRepository>(context,
                                      listen: false)
                                  .signOut();
                            },
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        child: ButtonTheme(
                          height: 60,
                          buttonColor: Colors.blue,
                          child: FlatButton(
                            child: Text(
                              "완료",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                print("실행");
                                // 스낵바를 통해 메시지 출력
                                var dateBirth = Timestamp.fromDate(DateTime(
                                    int.parse(yearController.text),
                                    int.parse(monthController.text),
                                    int.parse(dayController.text)));
                                Firestore.instance
                                    .collection('User')
                                    .document(user.user.uid)
                                    .setData({
                                  'birth': dateBirth,
                                  'date_joined': Timestamp.now(),
                                  'date_latest': Timestamp.now(),
                                  'discover': 0,
                                  //'hometown': contryController.text,
                                  'isman': isSelected[0],
                                  'nickname': nickNameController.text,
                                  'photo_profile':
                                      "https://firebasestorage.googleapis.com/v0/b/awespot-fdd7f.appspot.com/o/awespotLogo.jpg?alt=media&token=515d5331-5a42-4ab9-b94d-06ba6203a391",
                                  'upload': 0
                                }).whenComplete(() {
                                  print("완료!!");
                                  user.setStatus = Status.Authenticated;
                             
                                  /*
                                  Navigator.pop(context);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return HomePage(
                                        user: user,
                                      );
                                    }),
                                  );
                                  */
                                });
                              } else {
                                if (isSelected[0] == false &&
                                    isSelected[1] == false) {
                                  setState(() {
                                    genderValidation = "성별을 입력해주세요.";
                                    print(genderValidation);
                                  });
                                }
                              }
                            },
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

}
