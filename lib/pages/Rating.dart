import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:econsultent/pages/detail_page.dart';

class RatingsPage extends StatefulWidget {
  @override
  _RatingsPage createState() => _RatingsPage();
}

class _RatingsPage extends State<RatingsPage>{

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
        print("lk");
      } );
    }
  }

  @override
  void initState(){
    super.initState();
    this.getUser();
  }
  /// *****GET GENERAL USER DETAILS*******

  int _rating,_no=1;
  String  _text;
  String _consultentId = "2apJ7C4ef8ZQGkJmLC0m5N1IhgX2";

  /// ******************************************************
  /// SEND TO DATABASE
  /// ******************************************************
  final FirebaseDatabase database = FirebaseDatabase.instance;
  void _incrementCounter(){
    if(_consultentId=="2apJ7C4ef8ZQGkJmLC0m5N1IhgX2"){
      _no=_no+1;
    }
        database.reference().child("Reviews").
        child(_consultentId).child(_no.toString()).set({
          "name" : "${user.displayName}",
          "rating" : _currentRating,
          'text' : _text,
        });

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
              Icons.arrow_back
          ),
          onPressed: (){
          //  Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage()));
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
            _incrementCounter(),
            getUser(),
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
            print(_currentRating);
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