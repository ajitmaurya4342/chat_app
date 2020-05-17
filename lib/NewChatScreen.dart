import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class NewChatScreen extends StatefulWidget {
  @override
  NewChatScreenState createState() {
    return new NewChatScreenState();
  }
}

class NewChatScreenState extends State<NewChatScreen> {

  @override
  void initState() {
    getData();

    super.initState();

  }

  getData(){

//    _focusNodeChat.addListener(() {
//      print(_focusNodeChat.hasFocus);
//      if(_focusNodeChat.hasFocus) {
//
//        containerHeight = 0.52;
//        setState(() {
//
//        });
//      }else{
//
//        _focusNodeChat.unfocus();
//        containerHeight = 0.80;
//        setState(() {
//
//        });
//      }
//
//
//    });
  }

  Future<bool> _onWillPop()  {
    Navigator.pop(context);
  }
//
//    if(_focusNodeChat.hasFocus) {
//      _focusNodeChat.unfocus();
//      print("fsdfsd");
//    }else{
//
//    }
//
//  }





  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    final w = MediaQuery.of(context).size.width;


    return ListView.builder(
//                      scrollDirection: Axis.vertical,
            reverse: true,
            itemCount: 100,
            itemBuilder: (BuildContext context1, i) {
              return Column(

                children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap:(){
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(builder: (context) => ChatScreen()
//                                      ));

                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            size: 35,
                          ),
                          Expanded(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    textDirection: i%2==0?TextDirection.rtl:TextDirection.ltr,
                                    children: <Widget>[
                                      Container(
                                        width:w*0.7,
                                        color:Colors.black,
                                        padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                        child: Column(
                                          textDirection: TextDirection.rtl,
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: <Widget>[
                                            Text(
                                              "Ajit Maurya  egdbwfwef wf  sdfs dvxcv sdvsdf dsfsd dsfsdv dsf gds gsd ${i}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13.0,color:Colors.white),
                                            ),
                                            Row(
                                              textDirection: TextDirection.rtl,
                                              children: <Widget>[
                                                Icon(i%3==0?Icons.check:Icons.check_circle,size: 15,color:i%3==0?Colors.white:i%3==1?Colors.blueGrey:Colors.blueAccent),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                                                ),
                                                Text("1:10 pm",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,

                                                      fontSize: 13.0,color:Colors.white),),

                                              ],
                                            ),
                                          ],
                                        ),

                                      ),
//                                              Text(
//                                                "22/07/01",
//                                                style: TextStyle(color: Colors.black45),
//                                              ),
                                    ],
                                  ),

//                                          Padding(
//                                            padding: const EdgeInsets.only(top: 2.0),
//                                            child: Text(
//
//                                              "Ajit",
//
//                                              style: TextStyle(
//                                                  color: Colors.black45, fontSize: 16.0,),
//                                            ),
//                                          )
                                ],
                              ),
                            ),
                          )
                        ],
                        textDirection: i%2==0?TextDirection.rtl:TextDirection.ltr,
                      ),
                    ),
                  ),
                  Divider(),
                ],
              );
            }

    );

  }







}


