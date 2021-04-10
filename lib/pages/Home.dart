import 'package:flutter/material.dart';

import 'package:econsultent/pages/Start.dart';
import 'package:econsultent/pages/detail.dart';
import 'package:econsultent/pages/EditProfile.dart';

import 'package:econsultent/utils/custom_icons_icons.dart';
import 'package:econsultent/utils/he_color.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Search.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class Constants{
  static const String EditProfile = 'Edit Profile';
  static const String SignOut = 'Sign Out';

  static const List<String> choices = <String>[
    EditProfile,
    SignOut
  ];
}

class _HomePageState extends State<HomePage> {

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  Query _ref;

  @override
  void initState() {
    // TODO: implement noSuchMethod
    super.initState();
    _ref = FirebaseDatabase.instance.reference()
        .child('Consultants')
        .orderByChild('averageRating');
    this.checkAuthentification();
  }

  Widget _buildContactItem({Map Consultants}) {
    Color fieldColor = getFieldColor(Consultants['field']);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
      height: 150,
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
                      backgroundImage: Consultants['proPicURL'] == null
                          ? AssetImage( "images/avatar.png" )
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
                      SizedBox(height: 6,),
                      Row(children: [
                        SizedBox(width: 6,),
                        Text(Consultants['field'],style: TextStyle(fontSize: 16,
                            color: fieldColor,
                            //Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),),
                      ],
                      ),
                      SizedBox(height: 6,),
                      Row(children: [
                        SizedBox(width: 6,),
                        Text(Consultants['subField'],style: TextStyle(fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),),
                      ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>Detail(consultantKey: Consultants['key'],)));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.arrow_forward_ios, color: Colors.blue[800], size: 50,),
                            ],
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getFieldColor(String field){
    Color color =Theme.of(context).accentColor;

    if(field == 'Education'){
      color = Colors.green;
    }

    if(field == 'Medical'){
      color = Colors.red;
    }

    return color;
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////

//**************************************************
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isloggedin= false;

  checkAuthentification() async{

    _auth.onAuthStateChanged.listen((user) {

      if(user ==null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Start()));
      }
    });
  }


  //
  signOut()async{
    _auth.signOut();
  }

  //**************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
     // body: list(),
      body: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Text(
            'Top Rated Consultants',
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


  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: HexColor('#150047')),


      leading: PopupMenuButton<String>(
        onSelected: choiceAction,
        itemBuilder: (BuildContext context){
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),

      actions: [
        IconButton(
          icon: Icon(
            CustomIcons.search,
            size: 20,
          ),
          onPressed: () {
          //  showSearch(context: context, delegate: DataSearch());
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Search()));
          },
        ),
      ],
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.EditProfile) {
      Navigator.push(
          context, MaterialPageRoute( builder: (context) => EditProfile() ) );
    } else if (choice == Constants.SignOut) {
      signOut();
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget list() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.0),
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
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

}
