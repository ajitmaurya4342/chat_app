import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_app/constant.dart';
import 'package:http/http.dart' as http;
import 'package:socket_app/homepage.dart';
class LoginPage extends StatefulWidget {

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FocusNode name_node=new FocusNode();
  FocusNode email_node=new FocusNode();
  FocusNode phone_number_node=new FocusNode();


  final name = TextEditingController();
  final email = TextEditingController();
  final phone_number=TextEditingController();
  var count=0;
  var ErrorText="";


  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
  void _showLoading(context) {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            //contentPadding: const EdgeInsets.only(left : 16, right: 0, top: 10, bottom: 10),
            content: Container(
              color:Colors.transparent,
              width: 200,

              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: const EdgeInsets.all(16.0),),
                  Text('Please wait...'),
                ],
              ),
            ),
          );
        }
    ); //end showDialog()
  }
  loginForm() async {
//    print(validateEmail(email.text));
//    return false;
    name_node.unfocus();
    phone_number_node.unfocus();
    email_node.unfocus();
    this.count = 0;
    if (name.text == "" || phone_number.text == "" || email.text == "") {
      this.count = 1;
      this.ErrorText = "Please Fill all the details";
    } else if (name.text.length < 4) {
      this.count = 1;
      this.ErrorText = "Please enter name more than 3 letter";
    } else if (phone_number.text.length < 10) {
      this.count = 1;
      this.ErrorText = "Phone number should be 10 digit";
    } else if (!validateEmail(email.text)) {
      this.count = 1;
      this.ErrorText = "Please enter valid mail";
    }
    if (this.count > 0) {
      setState(() {

      });
      return false;
    }
    _showLoading(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await  _firebaseMessaging.getToken().then((token) async {
      prefs.setString('firebase_token', token);
      print(token);
    });

    var obj = {
      "name": name.text,
      "phone": phone_number.text,
      "email": email.text,
      "token_notification":prefs.getString('firebase_token')
    };


    http.post("${BASEURL}insert",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(obj)
    ).then((http.Response response) {

      final data = json.decode(response.body);
      print(data);
      prefs.setString("UserDetail", json.encode(data["userDetail"][0]));
      Navigator.pop(context);
       Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => HomePage()
           ));

    });
//    print(res.body);
//
//    final data = json.decode(res.body);
//    print(data);

    //prefs.setString("Solution",res.body);


//    if (data["status_code"] == 200) {
//
//    }
  }






  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);


    final emailField = TextField(
      controller: email,
      focusNode: email_node,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final phoneField = TextField(
      controller: phone_number,
      focusNode: phone_number_node,
      obscureText: false,
      keyboardType:TextInputType.number,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone Number",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: name,
      focusNode: name_node,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Full Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          print("fsdfs");
          loginForm();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: new Icon(Icons.chat, size: 155,color: Colors.lightBlue,),
                  ),
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                phoneField,

                SizedBox(
                  height: 35.0,
                ),
               count>0? Text(this.ErrorText,style: TextStyle(color:Colors.red),):Text(" "),
                loginButon,

                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}