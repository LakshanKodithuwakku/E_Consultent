import 'package:flutter/material.dart';
//import 'LogoutPage.dart';
import 'package:econsultent/pages/home_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
          primaryColor: Colors.blueAccent
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),

    );
  }
}