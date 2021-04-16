import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:econsultent/pages/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Mod {
  final String key;
  final String name;
  final int rating;
  final String text;
  final String proPicURL;
  Mod(this.key, this.name, this.rating, this.text, this.proPicURL);

  Mod.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        rating = snapshot.value['rating'],
        text = snapshot.value['text'],
        proPicURL = snapshot.value['proPicURL'];
  toJson() {
    return {
      "key": key, //number
      "name": name,
      "rating": rating,
      "text": text,
      "proPicURL": proPicURL,
    };
  }
}

class Review extends StatefulWidget {
  String consultentId;
  Review({this.consultentId});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final review = FirebaseDatabase.instance;
  DatabaseReference ref;
  bool _loading = true;

  List<Mod> reviews;
  Mod rev;

  //-----------------------------------get data from database
  Future<void> getData() async {
    reviews = new List(); //empty list
  //  rev = Mod("", "", null, "");
    ref = review.reference().child('Reviews').child(consultentId//'$id'
         );
    ref.onChildAdded.listen(_onEntryAdded); //
    ref.onChildChanged.listen(_onEntryChanged);
    _loading = false;
  }
  //------------------------------------------------

  _onEntryAdded(Event event) {
    setState(() {
      reviews.add(Mod.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = reviews.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      reviews[reviews.indexOf(old)] = Mod.fromSnapshot(event.snapshot);
    });
  }

  Future<void> getReviews() async {
    await getData();
    _loading = false;
  }

  void initState() {
    super.initState();
    getReviews();
  }

  //---------------------------------User Interface
  @override
  Widget build(BuildContext context) {
    return //_loading
     //   ? Loading()
     //   :
         Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Detail()));
                },
              ),
            ),
        //    resizeToAvoidBottomPadding: false,
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ratings and Reviews",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Flexible(
                  child: FirebaseAnimatedList(
                    query: ref,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: new Card(
                          color: Colors.blue[100],
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                            image: '${reviews[index].proPicURL}' == ""
                                                ? AssetImage('images/avatar.png')
                                                : NetworkImage('${reviews[index].proPicURL}')),
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              offset: Offset(0, 10))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      '${reviews[index].name}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17.0),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RatingBarIndicator(
                                    rating: reviews[index].rating.toDouble(),
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('${reviews[index].text}')),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

}
