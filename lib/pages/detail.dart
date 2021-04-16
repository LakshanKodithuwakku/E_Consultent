import 'package:econsultent/pages/review.dart';
import 'package:econsultent/utils/he_color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:econsultent/pages/Booking.dart';
import 'package:econsultent/pages/Rating.dart';
import 'package:econsultent/pages/Home.dart';

class Detail extends StatefulWidget {

  String consultantKey ;
  Detail({this.consultantKey});

  @override
  _DetailState createState() => _DetailState();
}

String fname,lname,field,rating,country,proPic, description,consultentId;
bool verified;
String l1,l2,l3;
int _no=0;
List<String> myList = List<String>(3);

/// ***********************************
/// Dropdown menu Constants
/// ***********************************
class Constants{
  static const String Report = 'Report';
  static const String GiveReview = 'Give Review';
  static const List<String> choices = <String>[
    GiveReview,
    Report
  ];
}

class _DetailState extends State<Detail> {

  DatabaseReference _ref;
  @override
  void initState(){
    super.initState();
   // _ref = FirebaseDatabase.instance.reference().child('Consultants');
    getConsultantDetail();
  }

  getConsultantDetail() async{
    _ref = FirebaseDatabase.instance.reference().child('Consultants');
    DataSnapshot snapshot = await _ref.child(widget.consultantKey).once();

    Map Consultants = snapshot.value;
    fname = Consultants['firstName'];
    lname = Consultants['secondName'];
    field = Consultants['field'];
    rating = Consultants['averageRating'];
    country = Consultants['country'];
    proPic = Consultants['proPicURL'];
    description = Consultants['description'];
    verified = Consultants['verified'];
    consultentId = Consultants['uid'];
  }

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleSection(),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( fname +' '+ lname,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_sharp,
                        color: HexColor('#222222'),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(country,
                        style: TextStyle(
                          color: HexColor('#000000'),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: HexColor('#FFF9EA'),
                      border: Border.all(color: HexColor('#FFEDBE'), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(  field,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(description,
                    style: TextStyle(
                      color: HexColor('#2E2E2E'),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 91,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        reviewButton(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 91,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /// App Bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: HexColor('#00C6AD'),
      elevation: 0,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.white),

      leading: IconButton(
        icon: Icon(Icons.arrow_back,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
        }
      ),

      /// ***********************************
      /// Dropdown menu
      /// ***********************************
      actions: [
        PopupMenuButton<String>(
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
      ],
    );
  }

  /// ***********************************
  /// Dropdown menu choice action
  /// ***********************************
  void choiceAction(String choice){
    if(choice == Constants.Report){
      _showMultiSelect(context);
    }else if(choice == Constants.GiveReview){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>RatingsPage(consultentId: consultentId,)));
    }
  }

  /// Title Section
  Container _titleSection() {
    return Container(
      height: 250,
      color: HexColor('#00C6AD'),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 207,
              height: 178,
              child: Image(
                filterQuality: FilterQuality.high,
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/bg_shape.png'),
              ),
            ),
          ),
          Positioned(
            right: 64,
            bottom: 30,
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: proPic == null
                        ? AssetImage( "images/avatar.png" )
                        : NetworkImage(proPic),
                  ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 15,
              color: Colors.white,
            ),
          ),
          Positioned(
            right: 32,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: HexColor('#FFBB23'),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(rating,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          verify(),
        ],
      ),
    );
  }


  Widget verify(){
    if( verified ) {
      return Positioned(
        right: 210,
        bottom: 50,
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
          decoration: BoxDecoration(
            color: HexColor( '#FFBB23' ),
            borderRadius: BorderRadius.circular( 50 ),
          ),
          child: Row(
            children: [
              Icon( Icons.verified_user_sharp,
                color: Colors.white,
                size: 44,
              ),
            ],
          ),
        ),
      );
    }else{
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.transparent,
            size: 34,
          ),
        ],
      );
    }
  }

  /// ******************************************
  /// Multi select Check box
  /// ******************************************

  List <MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    1: "He/She is a liar.",
    2: "Sexual harassment.",
    3: "Poor communication"
  };

  void populateMultiselect(){
    for(int v in  valuestopopulate.keys){
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
     multiItem = [];
    populateMultiselect();
    final items = multiItem;
    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
        );
      },
    );

    print(selectedValues);
    getvaluefromkey(selectedValues);
  }

  void getvaluefromkey(Set selection){
    if(selection != null){
      for(int X in selection.toList()){
        print(valuestopopulate[2]);
        myList[X] = valuestopopulate[X];
      }
    }
  }

  /// **********************************************
  /// SHOW REVIEW BUTTON
  /// **********************************************
  reviewButton() {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB( 70, 10, 70, 10 ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>Review(consultentId: consultentId,) ) );
      },
      child: Text( 'SHOW REVIEW', style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
      )
      ),
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( 20.0 ),
      ),
    );
  }
  /// ***********SHOW REVIEW BUTTON***********************


  /// **********************************************
  /// BOOK BUTTON
  /// **********************************************
  button() {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB( 70, 10, 70, 10 ),
      onPressed: () {
        //Navigator.push(
          //  context, MaterialPageRoute( builder: (context) => MyDropDown(consultentId: consultentId,) ) );
          Navigator.push(context, MaterialPageRoute(builder: (context) =>MyDropDown(consultentId: consultentId,) ) );
      },
      child: Text( 'Book', style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
      )
      ),
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( 20.0 ),
      ),
    );
  }
/// ***********BOOK BUTTON***********************

}

// ================== coped from stakeoverflow

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>( );

  void initState() {
    super.initState( );
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll( widget.initialSelectedValues );
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState( () {
      if (checked) {
        _selectedValues.add( itemValue );
      } else {
        _selectedValues.remove( itemValue );
      }
    } );
  }

  void _onCancelTap() {
    Navigator.pop( context );
  }

  void _onSubmitTap() {
    _incrementCounter();
  //  Navigator.pop( context, _selectedValues );

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text( 'Select Reasons' ),
      contentPadding: EdgeInsets.only( top: 12.0 ),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB( 14.0, 0.0, 24.0, 0.0 ),
          child: ListBody(
            children: widget.items.map( _buildItem ).toList( ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text( 'CANCEL' ),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text( 'OK' ),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains( item.value );
    return CheckboxListTile(
      value: checked,
      title: Text( item.label ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange( item.value, checked ),
    );
  }

  /// ******************************************************
  /// SEND TO DATABASE
  /// ******************************************************
  final FirebaseDatabase database = FirebaseDatabase.instance;
  void _incrementCounter(){
    database.reference().child("Report").
    child(consultentId).child(_no.toString()).set({
      "General_User_Id" : "2apJ7C4ef8ZQGkJmLC0m5N1IhgX0",
     "Reason" : myList[0] +" "+ myList[1] +" "+ myList[2]
    });
    _no++;
    myList[0]="";
    myList[1]="";
    myList[2]="";
    Navigator.pop( context, _selectedValues );
    setState(() {
      database.reference().child("Report").once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> data = snapshot.value;
        print("Value: $data");
      });
    });
  }
/// ****************SEND TO DATABASE*****************
}


