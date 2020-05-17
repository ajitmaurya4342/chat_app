import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constant.dart';


class ChatScreen extends StatefulWidget {



//  final IOWebSocketChannel channel;
//  ChatScreen({Key key,  this.channel}) : super(key: key);

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  Timer timer;
  var privateChatDetail;

  IOWebSocketChannel channel;

  @override
  void initState() {


    getData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();

  }

  var page_no=0;
  var NewUserList=[];
  var dateArray=[];
  var userId="";
  responseData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDetail=json.decode(prefs.getString("UserDetail"));
    var privateChat=json.decode(prefs.getString("ToChat"));
    print(userDetail["id"]);
     userId="${userDetail["id"]}";


      ///print( "${BASEURL}/getChatList?from_id=${userDetail["id"]}&to_id=${privateChat["id"]}&page_no=${page_no}");
    // print(userDetail);
    final res = await http.get(
        "${BASEURL}getChatList?from_id=${userDetail["id"]}&to_id=${privateChat["id"]}&page_no=${page_no}",
        headers: {
          "Accept": "application/json",

        }
    );


    final data = json.decode(res.body);

    if(data.length>0){

      for(var i=0;i<data.length;i++){

        var check=dateArray.indexOf(data[i]["MainDate"]);
        if(check>=0){
        }else{
         dateArray.add(data[i]["MainDate"]);
          }

        this.NewUserList.add(data[i]);

      }
      this.page_no=this.page_no+1;
      setState(() {
      });

      responseData();
    }

  }



  @override
  void dispose() {
    super.dispose();
    print("Chat Dispose");
    doOffline(1);
   timer.cancel();



    channel.sink.close();

  }

  AppLifecycleState _notification;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    print(state);
    if(state==AppLifecycleState.paused){
      print("Chat Pause");
      doOffline(0);
    }else if (state==AppLifecycleState.resumed){
      doOffline(3);
      print("Chat Resume");
    }

    setState(() { _notification = state; });
  }

  doOffline(id) async {

    if(id==1){
      SharedPreferences prefs=await SharedPreferences.getInstance();
      prefs.setString("Screen", "Home");
    }


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDetail=json.decode(prefs.getString("UserDetail"));
    print("${BASEURL}doOfline?id=${userDetail["id"]}&data=${id}");
    final res = await http.get(
        "${BASEURL}doOfline?id=${userDetail["id"]}&data=1",
        headers: {
          "Accept": "application/json",

        }
    );
     print(res.body);
   // final data = json.decode(res.body);

  }

  final FocusNode _focusNodeChat = FocusNode();

  connectSocketFun() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();

    if(count==1) {
      channel = IOWebSocketChannel.connect("ws://13.233.192.46:5000/");

      channel.stream.listen((data) {


        var dataNew=json.decode(data);


        if(dataNew["type"]=="toDetail"){
          //print(dataNew["data"]);
        privateChatDetail=dataNew["data"][0];
          setState(() {

          });
        }else if(dataNew["type"]=="send_chat"){

          var check=dateArray.indexOf(dataNew["data"]["MainDate"]);
          if(check>=0){
          }else{
            dateArray.add(dataNew["data"]["MainDate"]);
          }
          NewUserList.insert(0,dataNew["data"]);
          setState(() {

          });

        }else if(dataNew["type"]=="updateChat"){


          for(var i=0;i<NewUserList.length;i++){
            if(NewUserList[i]["msg_status"]==1) {
              NewUserList[i]["msg_status"] = 2;
            }

           }

          setState(() {

          });

        }

      }, onDone: () {
        print("Donev");


      }, onError: (error) {
        print(error);
      });

      var userDetail = json.decode(prefs.getString("UserDetail"));
      privateChatDetail = json.decode(prefs.getString("ToChat"));

      userDetail["screenType"] = "Chat";
      channel.sink.add(
          json.encode({
            "type": "connect",
            "data": userDetail,
           "ToChat":privateChatDetail,
          }));
      count=0;

    }else{
      print("Stop Connect");
    }

    setState(() {

    });
  }
  var count=1;
  getData() async {

    responseData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    privateChatDetail = json.decode(prefs.getString("ToChat"));
    prefs.setString("Screen", "Chat");



    var connectivityResult2 = await (Connectivity().checkConnectivity());
    if (connectivityResult2 == ConnectivityResult.mobile) {
      connectSocketFun();

      // I am connected to a mobile network.
    } else if (connectivityResult2 == ConnectivityResult.wifi) {
      connectSocketFun();

      // I am connected to a wifi network.
    }

    timer= new Timer.periodic(new Duration(seconds: 2), (timer) async {

      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile) {
        connectSocketFun();

        channel.sink.add(
            json.encode({
              "type": "ping",
              "data": "ping3",
              "ToChat":privateChatDetail,

            }));
        // I am connected to a mobile network.
      } else if (connectivityResult == ConnectivityResult.wifi) {
        connectSocketFun();

        channel.sink.add(
            json.encode({
              "type": "ping",
              "data": "ping",
              "ToChat":privateChatDetail,

            }));

        // I am connected to a wifi network.
      }else{
        count=1;
        setState(() {

        });
      }


      if(privateChatDetail["isOnline"]>0){
        for(var i=0;i<NewUserList.length;i++){
          if(NewUserList[i]["msg_status"]==2){
            break;
          }

          if(NewUserList[i]["msg_status"]==0 && privateChatDetail["isOnline"]==1) {
            NewUserList[i]["msg_status"] = 1;
          }else if(NewUserList[i]["msg_status"]==0 && (privateChatDetail["isOnline"]==3 || privateChatDetail["isOnline"]==2)){
            NewUserList[i]["msg_status"] = 2;
          }



        }
      }

    });



  }

  Future<bool> _onWillPop()  {
    Navigator.pop(context);
  }

  _newFunction(obj){
    print(obj["MainDate"]);
    var check=dateArray.indexOf(obj["MainDate"]);
    if(check>=0){
      return false;
    }else{

      dateArray.add(obj["MainDate"]);
//      setState(() {
//
//      });
      //print("fsdfds");
//      print(dateArray);

    }


    return true;
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
    final  height1=isKeyboardShowing?h>700?h*0.49:h*0.41:h>700?h*0.82:h*0.8;

    if (isKeyboardShowing) {

      channel.sink.add(json.encode(
          {
            "type": "typing",
            "data": 2
          }
      )

      );
    }else{
      channel.sink.add(json.encode(
          {
            "type":"typing",
            "data":3
          }
      ));

    }


    return  WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(

          appBar: new AppBar(
            backgroundColor: Colors.green,
            title:  Row(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 38,
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
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[
                                  Text(
                                    "${privateChatDetail["user_name"]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,color:Colors.white),
                                  ),
                                  Row(

                                    children: <Widget>[
                                      //Icon(i%3==0?Icons.check:Icons.check_circle,size: 15,color:i%3==0?Colors.white:i%3==1?Colors.blueGrey:Colors.blueAccent),

                                      Padding(
                                        padding: const EdgeInsets.only(top:2.0),
                                        child:Text( privateChatDetail["isOnline"]==0 ?"Last Seen ${privateChatDetail["LastSeen"]}":privateChatDetail["isOnline"]==1 || privateChatDetail["isOnline"]==3?"Online":"typing..",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,

                                              fontSize: 12.0,color:Colors.white),),
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

                  child:NewUserList.length>0?ListView.builder(
//                      scrollDirection: Axis.vertical,
                      reverse: true,
                      itemCount: NewUserList.length,
                      itemBuilder: (BuildContext context1, i) {


                         // print(NewUserList[i]);
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
                                              textDirection: "${NewUserList[i]["from_id"]}"==userId?TextDirection.rtl:TextDirection.ltr,
                                              children: <Widget>[
                                                Container(
                                                  width:NewUserList[i]["msg"].length>10?w*0.7:w*0.3,
                                                  color:Colors.black,
                                                  padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                                  child: Column(
                                                    textDirection: TextDirection.rtl,
                                                    crossAxisAlignment: CrossAxisAlignment.start,

                                                    children: <Widget>[
                                                      Text(NewUserList[i]["msg"]
                                                  ,style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 13.0,color:Colors.white),
                                                      ),
                                                      Row(
                                                        textDirection: TextDirection.rtl,
                                                        children: <Widget>[
                                                          Icon(NewUserList[i]["msg_status"]==0?Icons.check:Icons.check_circle,size: 15,color:NewUserList[i]["msg_status"]==0?Colors.white:NewUserList[i]["msg_status"]==1?Colors.blueGrey:Colors.blueAccent),
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(10,0,0,0),
                                                          ),
                                                          Text(NewUserList[i]["SentDate"],
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,

                                                                fontSize: 10.0,color:Colors.white),),

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
                                  textDirection: "${NewUserList[i]["from_id"]}"==userId?TextDirection.rtl:TextDirection.ltr,
                                ),
                              ),
                            ),


                          ],
                        );
                      }
                  ):new Container(),
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
          )
      ),
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
SharedPreferences prefs=await SharedPreferences.getInstance();
    if( _textEditingController!=null){
      var userDetail = json.decode(prefs.getString("UserDetail"));
      var obj={
        "from_id":userDetail["id"],
        "to_id":privateChatDetail["id"],
        "msg":_textEditingController.text,
        "chat_type_id":"1",
        "type":"send_chat",
        "toDetail":privateChatDetail,
        "myDetail":userDetail
      };

//      print(obj);
//      return false;



      channel.sink.add(json.encode(obj));
      _textEditingController.clear();
    }


    setState(() {
      _isComposingMessage = false;
    });

  }





}


