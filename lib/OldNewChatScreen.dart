import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
  final FocusNode _focusNodeChat = FocusNode();
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



  final TextEditingController _textEditingController =
  new TextEditingController();
  bool _isComposingMessage = false;
  double containerHeight=0.82;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    final w = MediaQuery.of(context).size.width;
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;
    final  height1=isKeyboardShowing?h*0.52:h*0.82;

    return  WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(

          appBar: new AppBar(
            backgroundColor: Colors.green,
            title:  Row(
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

                          children: <Widget>[
                            Container(
                              width:w*0.6,
                              // color:Colors.black,
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  Text(
                                    "Ajit Maurya",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,color:Colors.white),
                                  ),
                                  Row(

                                    children: <Widget>[
                                      //Icon(i%3==0?Icons.check:Icons.check_circle,size: 15,color:i%3==0?Colors.white:i%3==1?Colors.blueGrey:Colors.blueAccent),

                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0),
                                        child: Text("Last Seen 1:10 pm",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,

                                              fontSize: 13.0,color:Colors.white),),
                                      ),

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
            ),
            elevation:
            Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
            actions: <Widget>[
//            new IconButton(
//                icon: new Icon(Icons.exit_to_app), )
            ],
          ),
          body: new Container(

            child: new Column(
              children: <Widget>[
                Container(
                  height:height1,
                  color:Colors.black12,

                  child:ListView.builder(
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
                  ),
                ),

                new Divider(height: 1.0),

                new Container(
                  decoration:
                  new BoxDecoration(color: Theme.of(context).cardColor),
                  child: InkWell(child: _buildTextComposer()),
                ),

              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? new BoxDecoration(
                border: new Border(
                    top: new BorderSide(
                      color: Colors.grey[200],
                    )))
                : null,
          )),
    );
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {

                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  focusNode: _focusNodeChat,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },


                  onSubmitted: _textMessageSubmitted,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),

              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

  }





}


