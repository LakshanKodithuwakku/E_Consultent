import 'package:flutter/material.dart';

class RatingsPage extends StatefulWidget {
  @override
  _RatingsPage createState() => _RatingsPage();
}

/// **************************************
/// Rating Page arrangement
/// **************************************
class _RatingsPage extends State<RatingsPage>{
  int _rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Share your experience"),centerTitle: true,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back
          ),
          onPressed: (){

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

  int _currentRating = 0;

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