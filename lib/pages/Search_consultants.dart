import 'package:econsultent/pages/detail.dart';
import 'package:econsultent/pages/Search.dart';
import 'package:econsultent/utils/he_color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class SearchConsultant extends StatefulWidget {
  @override
  String category;
  SearchConsultant({this.category});
  _SearchConsultantState createState() => _SearchConsultantState(category);
}

class _SearchConsultantState extends State<SearchConsultant> {
  @override
  String category;
  _SearchConsultantState(this.category);

  Query _ref;

  @override
  void initState() {
    // TODO: implement noSuchMethod
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('Categories')
        .child('$category')
        .orderByChild('averageRating');
  }

  Widget _buildContactItem({Map Consultants}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
      height: 140,
      decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: Consultants['proPicURL'] == ""
                          ? AssetImage("images/avatar.png")
                          : NetworkImage(Consultants['proPicURL']),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            Consultants['firstName'],
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            Consultants['secondName'],
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Consultants['verified']
                          ? Text(
                              'Verified Consultant',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[500],
                                  fontWeight: FontWeight.w600),
                            )
                          : Text(
                              'Consultant',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[500],
                                  fontWeight: FontWeight.w600),
                            ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: 25,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            Consultants['averageRating'],
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //  SizedBox(width: 300,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>Detail(consultantKey: Consultants['key'],)));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: HexColor('#150047')),

      /// ***********************************
      /// Dropdown menu
      /// ***********************************
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => Search()));
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    Widget list() {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(10.0),
          // child: Column(
          // ),
          // height: double.infinity,
          child: SizedBox(
            height: 400.0,
            child: FirebaseAnimatedList(
              query: _ref,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                // ignore: non_constant_identifier_names
                Map Consultants = snapshot.value;
                Consultants['key'] = snapshot.key;
                return _buildContactItem(Consultants: Consultants);
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Text(
            '$category',
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(child: list())
        ],
      ),
    );
  }
}
