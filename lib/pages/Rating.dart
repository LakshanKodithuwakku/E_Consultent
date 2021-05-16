import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:econsultent/pages/detail.dart';

class RatingsPage extends StatefulWidget {

  String consultentId;
  RatingsPage({this.consultentId});

  @override
  _RatingsPage createState() => _RatingsPage();
}

class _RatingsPage extends State<RatingsPage>{


  /// **********************************************
  /// empty error popup
  /// **********************************************
  showError1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text( 'ERROR' ),
            content: Text( 'You should give a rating before submitting!' ),

            actions: <Widget>[
              FlatButton(

                  onPressed: () {
                    Navigator.of( context ).pop( );
                  },
                  child: Text( 'OK' ) )
            ],
          );
        }
    );
  }


  /// **************************************
  /// GET GENERAL USER DETAILS
  /// **************************************
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser( );
    await firebaseUser?.reload( );
    firebaseUser = await _auth.currentUser( );

    if (firebaseUser != null) {
      setState( () {
        this.user = firebaseUser;
      } );
    }
  }

  @override
  void initState(){
    super.initState();
    this.getUser();
    getUserDetail();
    reviewsData();
  }

  //----------------------------------------------------------------------------------------------calculate ratings-pamo
  var entries = [];
  Future<void> getReviewNames() async {
    final response = FirebaseDatabase.instance
        .reference()
        .child('Reviews')
        .child(consultentId)
        .once();

    await response.then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (String key in values.keys) {
        entries.add(key);
      }
    });
    //   print(entries);
  }

  var ratings = [];
  Future<void> getRatingValues() async {
    final response = FirebaseDatabase.instance
        .reference()
        .child('Reviews')
        .child(consultentId);
    for (int i = 0; i < entries.length; i++) {
      await response
          .child('${entries[i]}')
          .child('rating')
          .once()
          .then((DataSnapshot snapshot) {
        ratings.add(snapshot.value);
      });
    }
//    print(ratings);
  }

  Future<void> reviewsData() async {
    //call from initState
    await getReviewNames();
    await getRatingValues();
  }

  double avgRating = 0.0;
  Future<void> calculateAvgRatings() async {
    int total = 0;
    for (int i = 0; i < ratings.length; i++) {
      total = total + ratings[i];
    }
    avgRating = ((total + _currentRating) / (ratings.length + 1));
  }

  final FirebaseDatabase mainref = FirebaseDatabase.instance;
  Future<void> sendtoDatabase() async {
    final rat = mainref.reference().child('Consultants').child(consultentId);
    rat.child("averageRating").set(avgRating.toStringAsFixed(1));
  }

  Future<void> processCreatingAvgRating() async {
    //call from button
    await calculateAvgRatings();
    await sendtoDatabase();
  }
  //--------------------------------------------------------------------------------------------------------


  /// *****GET GENERAL USER DETAILS*******
  DatabaseReference _ref;
  String proPicURL, name;

  /// ******************************************************
  /// Map user data
  /// ******************************************************
  getUserDetail() async{
    await getUser();
    _ref = FirebaseDatabase.instance.reference().child('general_user');
    DataSnapshot snapshot = await _ref.child("${user.uid}").once();

    Map general_user = snapshot.value;
    proPicURL = general_user['proPicURL'];
    name = general_user['name'];
  }
  /// *****Map user data*******
  int _rating;
  String  _text;

  /// ******************************************************
  /// create a random number
  /// ******************************************************
  String CreateCryptoRandomString([int length = 8]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
  ///*********create a random number***********************

  /// ******************************************************
  /// SEND TO DATABASE
  /// ******************************************************
  final FirebaseDatabase database = FirebaseDatabase.instance;
  void _incrementCounter(){
        database.reference().child("Reviews").
        child(consultentId).child(CreateCryptoRandomString()).set({
          "name" : name,
          "rating" : _currentRating,
          'text' : _text,
          "GUID" : "${user.uid}",
          "proPicURL" : proPicURL,
        });
        processCreatingAvgRating();
        _currentRating =0;
    setState(() {
      database.reference().child("Reviews").once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> data = snapshot.value;
        print("Value: $data");
      });
    });
  }
  /// ****************SEND TO DATABASE*****************

  /// ******************************************************
  /// PAGE BODY
  /// ******************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Share your experience"),centerTitle: true,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Detail()));
            _currentRating =0;
          },
        ),),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: ListView(
          children: <Widget> [
            SizedBox(height: 100,
            ),
            Rating((rating){
              setState(() {
                _rating = rating;
              });
            }),
            SizedBox(height: 50,
            ),
            CommentBox(),
            SizedBox(height: 50,
            ),
            button(),
          ],
        ),
      ),
    );
  }
  /// **************PAGE BODY***************************

  /// **************************************
  /// Comment box
  /// **************************************
  Widget CommentBox(){
    return TextFormField(
      maxLines: 4,
      maxLength: 200,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )
        ),
        labelText: "Comment",
        helperText: "You can place the description of the consultant",
        hintText: "Place your experience!",
      ),
      onChanged: (val){
        _text = val;
      },
    );
  }
  /// *********Comment box****************

  /// **************************************
  /// Submit button
  /// **************************************
  Widget button(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Tap to button to add your review",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 30,),
        InkWell(

          /// Add to database
          onTap: () => {
            if(_currentRating>0){
              _incrementCounter(),
              //   processCreatingAvgRating(),
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Detail())),
            }else{
              showError1()
            }
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
/// ************Submit button*************




/// GLOBEL VERIABLE
int _currentRating = 0;

/// **************************************
/// Star rating implementation
/// **************************************
class Rating extends StatefulWidget {

  final int maximumRating;
  final Function(int) onRatingSelected;

  Rating(this.onRatingSelected, [this.maximumRating = 5]);

  @override
  _Rating createState() => _Rating();
}

class _Rating extends State<Rating>{

  Widget _buildRatingStar(int index){

    if(index < _currentRating){
      return Icon(Icons.star, color: Colors.orange);
    } else{
      return Icon(Icons.star_border_outlined);
    }
  }

  Widget _buildBody(){
    final stars = List<Widget>.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
          child: _buildRatingStar(index),
          onTap: (){
            setState(() {
              _currentRating = index + 1;
            });
            this.widget.onRatingSelected(_currentRating);
          }
      );
    });

    return Row(children: stars, mainAxisAlignment: MainAxisAlignment.center);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
/// *******Star rating implementation*****