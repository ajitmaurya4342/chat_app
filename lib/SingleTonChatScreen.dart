import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_app/socket_singleton.dart';

import 'package:web_socket_channel/io.dart';

import 'NewChatScreen.dart';



class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {

  TextEditingController editingController = new TextEditingController();
  bool nameTaken = false;
  String NAME = "name";
  String MESSAGE = "message";

  final TextEditingController _textEditingController =
  new TextEditingController();
  bool _isComposingMessage = false;
  double containerHeight=0.82;

  SocketSingleton _socket = SocketSingleton();
  String username = "";
  List<ChatPerson> messages = List();
  IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();
     channel = IOWebSocketChannel.connect("ws://192.168.0.105:5000/");

    channel.stream.listen((data) {
      print("DataReceived: " + data);
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print("Some Error");
    });
    username = _socket.name;
  }

  getData () {
    print("Hello all");
  }



  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    final w = MediaQuery.of(context).size.width;
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;
    final  height1=isKeyboardShowing?h*0.52:h*0.82;



    return new Scaffold(
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
                  padding: const EdgeInsets.fromLTRB(10,0,0,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Row(

                        children: <Widget>[
                          Container(
                            width:w*0.5,
                            // color:Colors.black,

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

                                            fontSize: 11.0,color:Colors.white),),
                                    ),

                                  ],
                                ),
                              ],
                            ),

                          ),
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
        body:
        Container(
          child: new Column(
            children: <Widget>[
              new StreamBuilder(

                stream: channel.stream,
                builder: (context, snapshot) {


                  if(snapshot.data == null){
                   // print("fsdfdsfsdf");
                    messages.clear();
                  //  getData();
                    return Container(
                        height:height1,
                        color:Colors.black12,
                        child: NewChatScreen());
                  }else {

                    // {
                    //   "name" : "ajit",
                    //   "data" : "ajhskjsf shf kjsdhfkdshfk hskdfhkdshf"
                    // }
                    print("fdsfds");
                    String username = json.decode(snapshot.data)['name'];
                    String message = json.decode(snapshot.data)['data'];


                    messages.insert(0, ChatPerson(
                        name : username,
                        message: message,
                        image : ''
                    ));

                    return Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: ListView.builder(
                          reverse: false,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index){
                            ChatPerson _cp = messages[index];
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: NetworkImage("https://api.adorable.io/avatars/${_cp.name}"),
                                    backgroundColor: Colors.white12,
                                  ),
                                  title: Text(_cp.name ?? "No name"),
                                  subtitle: Text(_cp.message ?? "No message"),
                                ),
                                Divider(height: 1,)
                              ],
                            );
                          }),
                    );
                  }

                },
              ),

              new Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: InkWell(child: _buildTextComposer()),
              ),
            ],
          ),
        )
    );
  }

  final FocusNode _focusNodeChat = FocusNode();

  void _sendMyMessage(String enteredData) {

    //bool nameTaken = false;
    // {
    //   "type" : "name",
    //   "data" : "Anant"
    // }

    //bool nameTaken = type;
    // {
    //   "type" : "message",
    //   "data" : "ajhskjsf shf kjsdhfkdshfk hskdfhkdshf"
    // }

    if (enteredData.isNotEmpty) {

      // s.send
      _socket.channel.sink.add(
          json.encode({
       "type": "sdfdsf",
            "data": "fsdfsdf"
          }));
      editingController.text = "";

      if(!nameTaken) {
        setState(() {
          nameTaken = true;
          username = enteredData;
        });
      }
    }
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
  @override
  void dispose() {
    _socket.channel.sink.close();
    super.dispose();
  }

  _changeName() {
    setState(() {
      nameTaken = false;
    });
  }
}

class ChatPerson {
  String name;
  String message;
  String image;

  ChatPerson({this.name, this.message, this.image});


}