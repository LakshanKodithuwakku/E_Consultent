import 'package:econsultent/pages/Search_consultants.dart';
import 'package:econsultent/pages/Home.dart';
import 'package:econsultent/utils/he_color.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //-------------------Consultant Category

  final _formkey = GlobalKey<FormState>(); //help the validate

  String value1 = "";
  String value2 = "";
  bool isA = false;
  String sub;
  List<DropdownMenuItem<String>> category = List();
  bool disabledropdown = true;

  final Medical = {
    "1": "Allergists",
    "2": "Dermatologist",
    "3": "Dental",
    "4": "Psychiatrist",
    "5": "Veterinary",
  };

  final Law = {
    "1": "Bankruptcy",
    "2": "Business",
    "3": "Civil",
    "4": "Criminal",
    "5": "Family",
    "6": "Personal Injury"
  };

  final Education = {
    "1": "Primary Education",
    "2": "Secondary Education",
    "3": "Higher Education",
    "4": "Special Education",
    "5": "Aesthetic Education"
  };

  final Counseling = {
    "1": "Educational",
    "2": "Guidance and Career",
    "3": "Marriage and family",
    "4": "Mental health",
    "5": "Substance abuse",
    "6": "Rehabiliation",
  };

  final Business = {
    "1": "Accountacy",
    "2": "Business Administration",
    "3": "Entrepreneurship",
    "4": "Finance",
    "5": "Marketing"
  };

  void populateMedical() {
    for (String key in Medical.keys) {
      category.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(Medical[key]),
        ),
        value: Medical[key],
      ));
    }

    /* for (int v in Medical.keys) {
      multiItem.add(MultiSelectDialogItem(v, Medical[v]));
    } */
  }

  void populateLaw() {
    for (String key in Law.keys) {
      category.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(Law[key]),
        ),
        value: Law[key],
      ));
    }
    /*for (int v in Law.keys) {
      multiItem.add(MultiSelectDialogItem(v, Law[v]));
    } */
  }

  void populateEducation() {
    for (String key in Education.keys) {
      category.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(Education[key]),
        ),
        value: Education[key],
      ));
    }
    /*for (int v in Education.keys) {
      multiItem.add(MultiSelectDialogItem(v, Education[v]));
    } */
  }

  void populateCounseling() {
    for (String key in Counseling.keys) {
      category.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(Counseling[key]),
        ),
        value: Counseling[key],
      ));
    }
    /*for (int v in Education.keys) {
      multiItem.add(MultiSelectDialogItem(v, Education[v]));
    } */
  }

  void populateBusiness() {
    for (String key in Business.keys) {
      category.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(Business[key]),
        ),
        value: Business[key],
      ));
    }
    /*for (int v in Education.keys) {
      multiItem.add(MultiSelectDialogItem(v, Education[v]));
    } */
  }

  //selected value of first dropdownform field ,populate the values of second dropdownbutton
  void selected(_value) {
    if (_value == "Medical") {
      category = [];

      populateMedical();
    } else if (_value == "Law") {
      category = [];

      populateLaw();
    } else if (_value == "Education") {
      category = [];

      populateEducation();
    } else if (_value == "Counseling") {
      category = [];

      populateCounseling();
    } else if (_value == "Business") {
      category = [];

      populateBusiness();
    }

    setState(() {
      value1 = _value;
      disabledropdown = false; //second dropdownbutton
      value2 = "";
    });
  }

  void secondselected(_value) {
    setState(() {
      value2 = _value;
      isA = true;
    });
  }

//------------------------------------------------
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
              Navigator.of(context).push( MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body:
          //  child: SingleChildScrollView(
          //   physics: BouncingScrollPhysics(),
          SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'What type of a Consultant you need.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    )),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      //Categoty
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Category',
                                          labelStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontFamily: 'AvenirLight'),
                                        ),
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: "Medical",
                                            child: Center(
                                              child: Text("Medical"),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "Law",
                                            child: Center(
                                              child: Text("Law"),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "Education",
                                            child: Center(
                                              child: Text("Education"),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "Counseling",
                                            child: Center(
                                              child: Text("Counseling"),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "Business",
                                            child: Center(
                                              child: Text("Business"),
                                            ),
                                          ),
                                        ],
                                        onChanged: (_value) => selected(_value),
                                        validator: (value) => value == null
                                            ? 'Please select your category'
                                            : null,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Container(
                                      //Sub Category
                                      width: 340,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: DropdownButton<String>(
                                        hint: Text(
                                          "Sub Category",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        underline: Container(
                                            color: Colors.transparent),
                                        items: category,
                                        onChanged: disabledropdown
                                            ? null
                                            : (_value) =>
                                                secondselected(_value),
                                        //  validator: (value) => value == null? 'Please select your sub category': null,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 15.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Colors.black38),
                                        ),
                                      ),
                                      width: 260,
                                      child: Text(
                                        "$value2",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: RaisedButton(
                                        color: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () {
                                          if (_formkey.currentState
                                              .validate()) {
                                            String category = "$value1-$value2";
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        SearchConsultant(
                                                            category:
                                                                category)));
                                          }
                                        },
                                        child: Text("Search",
                                            style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 2.2,
                                                color: Colors.black)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //  ),
    );
  }
}
