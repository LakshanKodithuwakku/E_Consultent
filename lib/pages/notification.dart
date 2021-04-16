import 'package:econsultent/pages/paymentHome.dart';
import 'package:econsultent/pages/videochat/index.dart';
import 'package:econsultent/pages/videochat/meeting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'package:firebaseapp/shared/loading.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  //-------------------------------get User id
  String id;
  FirebaseUser user;
  Future<void> getUserID() async {
    final FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      id = userData.uid.toString();
    });
  }

  //------------------------------------------
  final mainref = FirebaseDatabase.instance;
  bool _loading = true; //for query!=null is not true
  //-------------------------------------get meeting from database
  Query _ref;

  Future<void> getMeetings() async {
    _ref = FirebaseDatabase.instance
        .reference()
        .child('general_user')
        .child('$id')
        .child('booking')
        .orderByChild('date');
    //.orderByChild('startTime');
  }

  //----------------------------------------------------
  Future<void> getData() async {
    await getUserID();
    await getMeetings();
    _loading = false;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return //_loading
        //? Loading()
        //:
    Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.blueAccent,
            ),
            body: Container(
              //    padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Meeting requests",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Flexible(
                    child: FirebaseAnimatedList(
                      query: _ref,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map booking = snapshot.value;
                        booking['key'] = snapshot.key;

                        var temp = DateTime.now();
                        var d1 = DateTime(temp.year, temp.month, temp.day);
                        //     print(d1);
                        var temp1 = DateTime.parse(booking['date']);
                        var d2 = DateTime(temp1.year, temp1.month, temp1.day);
                        //     print(d2);
                        var d3 = d2.add(Duration(days: 1));
                        //      print(d3);
                        //  print(d3.compareTo(d1) <= 0);
                        if (d3.compareTo(d1) <= 0) {
                          //day after scheduled day it will automatically removed  (meetings)
                          FirebaseDatabase.instance
                              .reference()
                              .child('Consultants')
                              .child('$id')
                              .child('meetings')
                              .child('${booking['key']}')
                              .remove();
                        }

                        return //d3.compareTo(d1) == 0? null:
                            Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                )),
                            padding: EdgeInsets.only(
                                top: 5.0, left: 12.0, right: 12.0),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            height: 160,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Date :",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "${booking['date']}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue[800],
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Start Time :",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "${booking['startTime']}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue[800],
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),

                                    //////////////////////////////////////////////////////////////////////////////
                                    Row(
                                      children: [
                                        Text(
                                          "Consultent :",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),

                                        Text(
                                          "${booking['consultentName']}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    //////////////////////////////////////////////////////////////////////////////
                                    Row(
                                      children: [
                                        Text(
                                          "Meeting Duration :",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "${booking['selectedduration']}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Meeting Type :",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "${booking['selectedtype']}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Payment :",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "${booking['amount']}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                     Row(
                                      mainAxisAlignment: MainAxisAlignment.end,

                                      children: [
                                        verify("${booking['pay']}", "${booking['accepeted']}", "${booking['key']}"),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  /////////////////////////////////////////////////////////////////////////////////////
  Widget verify(String p, String v, String ID){
    if( v == 'true' && p != 'true') {
      return
          RaisedButton(
            color: Colors.grey[300],
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular( 20 ) ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=> PaymentPage(meetingId:ID,),));
              print(ID);
            },
            child: Text( "Pay",
                style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.6,
                    color: Colors.black ) ),
      );
    }else if(p == 'true'){
      return RaisedButton(
        color: Colors.blueAccent,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>IndexPage(),));
        },
        child: Text("Join Meeting",
            style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.6,
                color: Colors.white)),
      );
    }else{
      return InkWell(
        child: Container(
          color: Colors.blue[100],
        ),
      );
    }
  }
/////////////////////////////////////////////////////////////////////////////////////////
}


