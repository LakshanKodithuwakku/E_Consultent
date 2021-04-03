import 'package:flutter/material.dart';
import 'package:econsultent/pages/home_page.dart';

class MyDropDown extends StatefulWidget {
  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown>{
  final List<String> type = ["Video", "Audio", "Text chat"];
  final List<String> duration = ["Quick solution","One hour","Scheduled day"];

  String selectedtype = "Video";
  String selectedduration = "Quick solution";

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
                  Text(selectedtype, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),),
                  SizedBox(height: 50,),
                  button(),
                ],
              )

            ],
          ),
        ),
    );
  }

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

          /// Add to database
          onTap: () => {

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
}