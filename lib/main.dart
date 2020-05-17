import 'package:flutter/material.dart';
import 'package:socket_app/homepage.dart';




void main() {
  runApp(new MyApp());

}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,

    );
  }



}
