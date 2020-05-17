import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_app/ChatScreen.dart';
import 'package:socket_app/Drawer.dart';
import 'package:socket_app/start_page.dart';
import 'package:socket_app/constant.dart';
import 'package:http/http.dart' as http;

class NewChat extends StatefulWidget {

  @override
  NewChatState createState() => NewChatState();
}

class NewChatState extends State<NewChat> {

  var NewUserList=[];
  var page_no=0;

  @override
  void initState() {
    getData();


    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDetail=json.decode(prefs.getString("UserDetail"));
//    print("${BASEURL}?id=${userDetail["id"]}");
    print("${BASEURL}?id=${userDetail["id"]}&page_no=${page_no}");
    final res = await http.get(
        "${BASEURL}?id=${userDetail["id"]}&page_no=${page_no}",
        headers: {
          "Accept": "application/json",

        }
    );


    final data = json.decode(res.body);
  //  print(data);
    if(data.length>0){

      for(var i=0;i<data.length;i++){

        this.NewUserList.add(data[i]);

      }
      this.page_no=this.page_no+1;
      setState(() {
      });

      getData();
    }

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("New Chat", style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600),),
        actions: <Widget>[


        ],
        backgroundColor: Colors.green,
      ),
//      drawer:new Drawer(
//        child: Drawer1(),
//      ),
      body: Container(
       // height:1000,
        color:Colors.white,

        child:NewUserList.length>0?ListView.builder(
//                      scrollDirection: Axis.vertical,
            itemCount: NewUserList.length,
            itemBuilder: (BuildContext context, i) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap:() async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("ToChat",json.encode(NewUserList[i]));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen()
                            ));

                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            size: 60.0,
                          ),
                          Expanded(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "${NewUserList[i]["user_name"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20.0),
                                      ),
//                                      Text(
//                                        "22/07/01",
//                                        style: TextStyle(color: Colors.black45),
//                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      "${NewUserList[i]["phone_number"]}",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              );
            }
        ):Center(
          child: Container(
            height:20,
            width: 20,
            child:CircularProgressIndicator(

            )
          ),
        )
      ),
    );
  }

}