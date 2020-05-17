import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_app/ChatScreen.dart';
import 'package:socket_app/Drawer.dart';
import 'package:socket_app/start_page.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';

class HomePage extends StatefulWidget {
 // const AppLifecycleReactor({ Key key }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver{

  Timer timer;

  IOWebSocketChannel channel;

  @override
  void initState() {
    responseData();
   getData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();

  }
  var userId="";
  var page_no=0;
  var countUnread=[];
  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
SharedPreferences prefs=await SharedPreferences.getInstance();
    print(state);
    if(state==AppLifecycleState.paused){
    print("Home Pause");
    doOffline(0);



    }else if (state==AppLifecycleState.resumed){
      print(prefs.getString("Screen"));
      if(prefs.getString("Screen")=='Home'){
        doOffline(1);
      }

      print("Home Resume");
    }

   setState(() { _notification = state; });
  }


  responseData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDetail=json.decode(prefs.getString("UserDetail"));
    prefs.setString("Screen", "Home");
     print("fdsfdsfsdf");
   // print(userDetail["id"]);
    userId="${userDetail["id"]}";
//print( "${BASEURL}getAllChatTalk?id=${userDetail["id"]}&page_no=${page_no}");
    final res = await http.get(
        "${BASEURL}getAllChatTalk?id=${userDetail["id"]}&page_no=${page_no}",
        headers: {
          "Accept": "application/json",

        }
    );

    final data = json.decode(res.body);

    print(data);

   // print(data);
    if(data["getList"].length>0){


        if(page_no==0){


          this.NewUserList=data["getList"];
          countUnread=data["dataAllUnread"];


        }else{
          for(var i=0;i<data["getList"].length;i++){
          this.NewUserList.add(data["getList"][i]);

        }

      }
      this.page_no=this.page_no+1;
        setState(() {
        });

      responseData();
    }else{
      this.page_no=0;
      setState(() {
      });

    }

  }

  var count=1;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
    timer.cancel();
    print("Home dispose");
  }

  doOffline(id) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDetail=json.decode(prefs.getString("UserDetail"));
    print( "${BASEURL}doOfline?id=${userDetail["id"]}&data=${id}");
    final res = await http.get(
        "${BASEURL}doOfline?id=${userDetail["id"]}&data=${id}",
        headers: {
          "Accept": "application/json",

        }
    );

    final data = json.decode(res.body);

  }

  var NewUserList=[];
  connectSocketFun() async {
    if(count==1) {
      channel = IOWebSocketChannel.connect("ws://13.233.192.46:5000/");

      channel.stream.listen((data) {
        print("DataReceived:22 " + data);
        var dataNew=json.decode(data);
        if( dataNew["type"]=='refresh' || dataNew["type"]=='send_chat'){

          page_no=0;
          setState(() {

          });
          responseData();


        }

      }, onDone: () {
        print("Done");
       //+ doOffline();
        channel.sink.close();
      }, onError: (error) {
        print(error);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userDetail = json.decode(prefs.getString("UserDetail"));
      userDetail["screenType"] = "Home";
      channel.sink.add(
          json.encode({
            "type": "connect",
            "data": userDetail
          }));
      count=0;
    }else{
      print("Stop Connect 1");
    }

    setState(() {

    });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("UserDetail")==null){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()
          ));

    }

    var connectivityResult2 = await (Connectivity().checkConnectivity());
    if (connectivityResult2 == ConnectivityResult.mobile) {
      connectSocketFun();

      // I am connected to a mobile network.
    } else if (connectivityResult2 == ConnectivityResult.wifi) {
      connectSocketFun();

      // I am connected to a wifi network.
    }

    timer= new Timer.periodic(new Duration(seconds: 3), (timer) async {

      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile) {
        connectSocketFun();

        channel.sink.add(
            json.encode({
              "type": "ping",
              "data": "ping",
              "getMsgList":"fefer"

            }));
        // I am connected to a mobile network.
      } else if (connectivityResult == ConnectivityResult.wifi) {
        connectSocketFun();

        channel.sink.add(
            json.encode({
              "type": "ping",
              "data": "ping",
              "getMsgList":"fefer"

            }));

        // I am connected to a wifi network.
      }else{
        count=1;
        setState(() {

        });
      }

    });

  }
  @override
  Widget build(BuildContext context) {

    final h = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    final w = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat App", style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600),),
        actions: <Widget>[

//          Padding(
//            padding: const EdgeInsets.only(right: 20.0),
//            child: Icon(Icons.search),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(right: 16.0),
//            child: Icon(Icons.more_vert),
//          ),
        ],
        backgroundColor: Colors.green,
      ),
      drawer:new Drawer(
        child: Drawer1(),
      ),
      body: Container(
        //height:1000,
        color:Colors.white,

        child:NewUserList.length>0?ListView.builder(
//                      scrollDirection: Axis.vertical,
            itemCount: NewUserList.length,
            itemBuilder: (BuildContext context1, i) {
              var _index=-1;
             if(countUnread.length>0) {

               _index = countUnread.indexWhere((user) =>
               user["from_id"] == NewUserList[i]["user_to_id"]);
             }

            return Column(
            children: <Widget>[
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap:() async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("ToChat",json.encode(NewUserList[i]));
                    Navigator.push(
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
                              Text(
                                "${NewUserList[i]["lastDate"]}",
                                style: TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child:  Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:w*0.5,
                                  child: Text(
                                    "${NewUserList[i]["lastMsg"]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0),
                                  ),
                                ),
                            _index>=0?Padding(
                                  padding: const EdgeInsets.only(right:20.0),
                                  child: new InkResponse(

                                    child: new Container(
                                      width: 30,
                                      height: 20,

                                      decoration: new BoxDecoration(
                                        color: Colors.lightGreenAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child:Center(child: Text("${countUnread[_index]["unread"]}", style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.0),
                                      )),
                                    ),
                                  ),
                                ):Container(),
                              ],
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
        ),
      ),
    );
  }

}