import 'package:econsultent/cells/category_cell.dart';
import 'package:econsultent/cells/hd_cell.dart';
import 'package:econsultent/cells/trd_cell.dart';
import 'package:econsultent/models/category.dart';
import 'package:econsultent/models/consultant.dart';
import 'package:econsultent/pages/detail_page.dart';
import 'package:econsultent/utils/custom_icons_icons.dart';
import 'package:econsultent/utils/my_flutter_app_icons.dart';
import 'package:econsultent/utils/he_color.dart';
import 'package:flutter/material.dart';
import 'package:econsultent/pages/EditProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:econsultent/pages/Start.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// ***********************************
/// Dropdown menu Constants
/// ***********************************
class Constants{
  static const String EditProfile = 'Edit Profile';
  static const String SignOut = 'SignOut';

  static const List<String> choices = <String>[
    EditProfile,
    SignOut
  ];
}

class _HomePageState extends State<HomePage> {
  List<Consultant> _hDoctors = List<Consultant>();
  List<Category> _categories = List<Category>();
  List<Consultant> _trDoctors = List<Consultant>();

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


  /// **********************************************
  /// ACTIONS
  /// **********************************************

  _onCellTap(Consultant consultant) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(consultant: consultant),
        ));
  }

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  void initState() {
    super.initState();
    _hDoctors = _getHDoctors();
    _categories = _getCategories();
    _trDoctors = _getTRDoctors();
    this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hDoctorsSection(),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _categorySection(),
                  SizedBox(
                    height: 32,
                  ),
                  _trDoctorsSection(),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: HexColor('#150047')),

      /// ***********************************
      /// Dropdown menu
      /// ***********************************
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
            showSearch(context: context, delegate: DataSearch());
          },
        ),
      ],
    );
  }

  /// ***********************************
  /// Dropdown menu choice action
  /// ***********************************
  void choiceAction(String choice) {
    if (choice == Constants.EditProfile) {
      Navigator.push(
          context, MaterialPageRoute( builder: (context) => EditProfile( ) ) );
    } else if (choice == Constants.SignOut) {
      signOut();
    }
  }

  /// Highlighted Doctors Section
  SizedBox _hDoctorsSection() {
    return SizedBox(
      height: 199,
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24),
        itemCount: _hDoctors.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(indent: 16),
        itemBuilder: (BuildContext context, int index) => HDCell(
          consultant: _hDoctors[index],
          onTap: () => _onCellTap(_hDoctors[index]),
        ),
      ),
    );
  }

  /// Category Section
  Column _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(indent: 16),
            itemBuilder: (BuildContext context, int index) =>
                CategoryCell(category: _categories[index]),
          ),
        ),
      ],
    );
  }

  /// Top Rated Consultants Section
  Column _trDoctorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Rated Consultants',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: _trDoctors.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
            thickness: 16,
            color: Colors.transparent,
          ),
          itemBuilder: (BuildContext context, int index) =>
              TrdCell(consultant: _trDoctors[index]),
        ),
      ],
    );
  }

  /// **********************************************
  /// DUMMY DATA
  /// **********************************************

  /// Get Highlighted Doctors List
  List<Consultant> _getHDoctors() {
    List<Consultant> hDoctors = List<Consultant>();

    hDoctors.add(Consultant(
      firstName: 'Albert',
      lastName: 'Alexander',
      image: 'albert.jpg',
      type: 'Kidney',
      rating: 4.5,
    ));
    hDoctors.add(Consultant(
      firstName: 'Elisa',
      lastName: 'Rose',
      image: 'albert.jpg',
      type: 'Kidney',
      rating: 4.5,
    ));
    hDoctors.add(Consultant(
      firstName: 'Elisa',
      lastName: 'Rose',
      image: 'albert.jpg',
      type: 'Kidney',
      rating: 4.5,
    ));

    return hDoctors;
  }

  /// Get Categories
  List<Category> _getCategories() {
    List<Category> categories = List<Category>();
    categories.add(Category(
      icon: MyFlutterApp.hand_holding_medical,
      title: 'Medical',
    ));
    categories.add(Category(
      icon: MyFlutterApp.law,
      title: 'Law',
    ));
    categories.add(Category(
      icon: MyFlutterApp.business,
      title: 'Business',
    ));
    categories.add(Category(
      icon: MyFlutterApp.building,
      title: 'Civil',
    ));
    return categories;
  }

  /// Get Top Rated Doctors List
  List<Consultant> _getTRDoctors() {
    List<Consultant> trDoctors = List<Consultant>();

    trDoctors.add(Consultant(
      firstName: 'Mathew',
      lastName: 'Chambers',
      image: 'mathew.png',
      type: 'Bone',
      rating: 4.3,
    ));
    trDoctors.add(Consultant(
        firstName: 'Cherly',
        lastName: 'Bishop',
        image: 'cherly.png',
        type: 'Civil',
        rating: 4.7));
    trDoctors.add(Consultant(
        firstName: 'Albert',
        lastName: 'Alexander',
        image: 'albert.jpg',
        type: 'Law',
        rating: 4.3));
    trDoctors.add(Consultant(
      firstName: 'Elisa',
      lastName: 'Rose',
      image: 'albert.jpg',
      type: 'Kidney',
      rating: 4.5,
    ));
    return trDoctors;
  }
}

/// **********************************************
/// Search bar Implimentation
/// **********************************************
class DataSearch extends SearchDelegate<String>{

  /// **********************************************
  /// DUMMY DATA
  /// **********************************************
  final cities = [
    "Medical",
    "Law",
    "Business",
    "Civil engineering"
  ];

  final recentCities = [
    "Law",
    "Business"
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions (actions for app bar)
    return [IconButton(icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading (leading icon on the left of the app bar)
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults (Show some result based on the selection)
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions (show when someone searches for something)
    final suggestionList = query.isEmpty
        ?recentCities
        :cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context,index)=>ListTile(
        onTap: (){
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(text: TextSpan(
            text: suggestionList[index].substring(0,query.length),
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold ),
            children: [TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey))
            ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }

}