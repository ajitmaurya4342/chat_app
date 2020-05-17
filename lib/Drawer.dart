import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_app/NewChat.dart';
import 'package:socket_app/start_page.dart';


class Drawer1 extends StatefulWidget {

  final OnTabChange mL;

  Drawer1({Key key, this.mL}) : super(key : key);

  @override
  _Drawer1State createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {

  String userName="";
  String userProfileImage="https://static.thenounproject.com/png/994628-200.png";
  String email="";

  @override
  void initState() {
    super.initState();
  getData();

  }

  getData() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDetail=json.decode(prefs.getString("UserDetail"));
   // print(userDetail);

    userName=userDetail["name"];
    userProfileImage=null;
     email=userDetail["email"];
    setState(() {

    });
  }
  
  signOut()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("UserDetail");

    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()
        ));
    
  }


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    final w = MediaQuery.of(context).size.width;
    return new SizedBox(
//        width: 250,
      child: Drawer(
        elevation: 12.0,
        child: ListView(

          padding:EdgeInsets.only(left: 0),
          children: <Widget>[
            InkWell(
              onTap: () {
//                Navigator.pop(context);
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (build) => PersonalDetail()));

              },
              child: new UserAccountsDrawerHeader(


                accountName: Row(
                  children: <Widget>[
                    Container(

                      child: new Text(

                        "${this.userName}",

                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.only(top:12),
                    ),

                   FlatButton(
//                   padding: EdgeInsets.all(16),
//                   color: Colors.green,
                           onPressed: () {
//                             Navigator.pop(context);
//                       Navigator.push(context,
//                        MaterialPageRoute(builder: (build) => PersonalDetail()));

                           },
                       child: IconButton(icon:Icon(Icons.edit,size: 30,),color: Colors.white,onPressed:(){ Navigator.pop(context);


                       } ),
                     )
                  ],
                ),
                accountEmail:  new Text(

                  "${this.email}",

                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                currentAccountPicture: new CircleAvatar(
                    child: InkWell(
                      child: userProfileImage != ''
                          ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                // ignore: unnecessary_brace_in_string_interps
                                image: NetworkImage("${userProfileImage}"),
                                fit: BoxFit.cover),
                          ))
                          : Image.asset(
                        'images/profile_image.png',
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        scale: 16,
                      ),
                      onTap: () {


                      },

                    )),
                decoration: BoxDecoration(color: Color.fromRGBO(46, 168, 212, 1)),



              ),
            ),

            ListTile(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewChat()
                    ));
              },
              leading: new Icon(Icons.question_answer, size: 24),
              title: new Text(
                "New Chat",
                style: TextStyle(fontSize: h>700?16:15,fontWeight: FontWeight.bold),
              ),
              contentPadding: EdgeInsets.only(left: 10),
            ),

            ListTile(
                  onTap: signOut,
              leading: new Icon(Icons.question_answer, size: 24),
              title: new Text(
                "Sign Out",
                style: TextStyle(fontSize: h>700?16:15,fontWeight: FontWeight.bold),
              ),
              contentPadding: EdgeInsets.only(left: 10),
            ),
//                ListTile(
//                    title: new Text(userId != null ? "Logout" : "Sign In"),
//                    onTap: () {
//                      userId != null ? _logout(context) : _signIn(context);
//                    }),
          ],
        ),
      ),
    );
  }
}


abstract class OnTabChange{
  // ignore: non_constant_identifier_names
  void OnTabChanged(int item);
}