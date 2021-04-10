import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:econsultent/pages/Home.dart';
import 'package:econsultent/pages/paymentHome.dart';
import 'package:econsultent/pages/detail.dart';


class MyDropDown extends StatefulWidget {

  String consultentId;
  MyDropDown({this.consultentId});
  @override
  _MyDropDownState createState() => _MyDropDownState();
}
String p1,p2,p3,p4,p5,p6;
class _MyDropDownState extends State<MyDropDown>{
  /// *******************************************************
  /// GET PRICE DETAILS
  /// *******************************************************
  DatabaseReference _ref;
  @override
  void initState() {
    super.initState( );
    this.getUser( );
    pickedDate = DateTime.now( );
    time = TimeOfDay.now( );
    _ref = FirebaseDatabase.instance.reference( ).child( 'Price' );
    getPrice( );
  }

  getPrice() async{
    DataSnapshot snapshot = await _ref.once();
    Map Price = snapshot.value;
    p1 = Price['Video-Quick'];
    p2 = Price['Video-hour'];
    p3 = Price['Video-Scheduled'];
    p4 = Price['Text-Quick'];
    p5 = Price['Text-hour'];
    p6 = Price['Text-Scheduled'];
  }
  /// *****************GET PRICE DETAILS********************
  DateTime pickedDate;
  TimeOfDay time;

  final List<String> type = ["Video", "Text chat"];
  final List<String> duration = ["Quick solution","One hour","Scheduled day"];

  String selectedtype = "Video";
  String selectedduration = "Quick solution";
  String price= p1;

  /// **********************************************
  /// PAGE BODY
  /// **********************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[

              Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  ConferenceType(),
                  SizedBox(height: 50,),
                  Duration (),
                  SizedBox(height: 50,),
                  date(),
                  SizedBox(height: 50,),
                  timebar(),
                  SizedBox(height: 20,),
                  Text("Rs: "+price, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),),
                  SizedBox(height: 50,),
                  button(),
                ],
              )

            ],
          ),
        ),
    );
  }
  /// ***************PAGE BODY**********************

  /// **********************************************
  /// APP BAR
  /// **********************************************
  AppBar _buildAppBar(){
    return AppBar(
      title: Text("Book your cunsultant"),centerTitle: true,
      leading: IconButton(
          icon: Icon(
              Icons.arrow_back
          ),
          onPressed:(){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
          }// navigateToStart(),
      ),
    );
  }

  /// **********************************************
  /// PRICE CALCULATOR
  /// **********************************************
  Widget Pricegenarate(){
    switch (selectedtype){
      case 'Video':
        {
          if (selectedduration == 'Quick solution') {
            price = p1;
          } else if (selectedduration == 'One hour') {
            price = p2;
          } else if (selectedduration == 'Scheduled day') {
            price = p3;
          }
        }
        break;
      case 'Text chat':
        {
          if (selectedduration == 'Quick solution') {
            price = p4;
          } else if (selectedduration == 'One hour') {
            price = p5;
          } else if (selectedduration == 'Scheduled day') {
            price = p6;
          }
        }
        break;
    }
  }

  /// **********************************************
  /// CONFERENCE TYPE
  /// **********************************************
  Widget ConferenceType (){
    return
    Row(
      children: [
        Text("Conference type ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),

        SizedBox(width: 62,),
        DropdownButton<String>(
          value: selectedtype,
          onChanged: (value){
            setState(() {
              selectedtype = value;
              Pricegenarate();
            });
          },
          items: type.map<DropdownMenuItem<String>>((value){
            return DropdownMenuItem(
              child: Text(value),
              value: value,
            );
          }).toList(),
        ),
      ],
    );
  }

  /// **********************************************
  /// DURATION SELECT
  /// **********************************************
  Widget Duration(){
    return
      Row(
        children: [
          Text("Conference duration ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),

          SizedBox(width: 30,),
          DropdownButton<String>(
            value: selectedduration,
            onChanged: (value){
              setState(() {
                selectedduration = value;
                Pricegenarate();
              });
            },
            items: duration.map<DropdownMenuItem<String>>((value){
              return DropdownMenuItem(
                child: Text(value),
                value: value,
              );
            }).toList(),
          ),
        ],
      );
  }

  /// *****************************************
  /// Select date
  /// *****************************************
  Widget date(){
    return
          ListTile(
            title: Text("Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}",
              style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: _pickDate,
          );
  }
  
  _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year-5),
        lastDate: DateTime(DateTime.now().year+5),
    );

    if(date != null)
      setState(() {
        pickedDate = date;
      });
  }
  /// **************Select date*************

  /// *****************************************
  /// TIME date
  /// *****************************************
  Widget timebar(){
    return
      ListTile(
        title: Text("Time: ${time.hour}, ${time.minute}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: _pickTime,
      );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if(t != null)
      setState(() {
        time = t;
      });
  }
  /// **************TIME date*************

  /// **************************************
  /// Submit button
  /// **************************************
  Widget button(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Tap to button and submit",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 30,),
        InkWell(

          /// Add to database and redirect payment
          onTap: () => {
            _savePrice(),
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentPage(),)),
          },

          child: Container(
            height: 60,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text("Submit",style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),),
            ),
          ),
        )
      ],
    );
  }

  /// ******************************************************
  /// RETRIEVE CLIENT ID
  /// ******************************************************
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  getUser() async{
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if(firebaseUser !=null)
    {
      setState(() {
        this.user =firebaseUser;
      });
    }
  }

  ///*********RETRIEVE CLIENT ID****************************

  /// ******************************************************
  /// create a random number
  /// ******************************************************
  String CreateCryptoRandomString([int length = 32]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
  ///*********create a random number***********************

  /// ******************************************************
  /// SEND TO DATABASE
  /// ******************************************************
  final FirebaseDatabase database = FirebaseDatabase.instance;
  void _savePrice(){
    database.reference().child("Client").
    child("${user.uid}").child("booking").child(CreateCryptoRandomString()).set({
      "amount" : price,
      "clientID" : "${user.uid}",
      "selectedtype" : selectedtype,
      "selectedduration" : selectedduration,
      "consultentId" : consultentId,
    });
    database.reference().child("Consultants").
    child(consultentId).child("meetings").child(CreateCryptoRandomString()).set({
      "amount" : price,
      "clientID" : "${user.uid}",
      "selectedtype" : selectedtype,
      "selectedduration" : selectedduration,
      "date" : pickedDate.year.toString()+"-"+pickedDate.month.toString().padLeft(2,'0')+"-"+pickedDate.day.toString().padLeft(2,'0'),
      "startTime" : time.hour.toString().padLeft(2,'0')+":"+time.minute.toString().padLeft(2,'0'),
    });

    setState(() {
      database.reference().child("Client").once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> data = snapshot.value;
        print("Value: $data");
      });
    });
  }
/// ****************SEND TO DATABASE*****************
}