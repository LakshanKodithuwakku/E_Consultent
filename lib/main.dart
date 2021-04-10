import 'package:econsultent/pages/Rating.dart';
import 'package:flutter/material.dart';
//import 'package:econsultent/pages/home_page.dart';
import 'package:econsultent/pages/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
          primaryColor: Colors.blueAccent
      ),
      debugShowCheckedModeBanner: false,
      home:
      HomePage(),
      //RatingsPage(),

    );
  }
}