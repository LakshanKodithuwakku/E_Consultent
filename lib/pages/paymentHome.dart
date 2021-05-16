import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:econsultent/services/payment-service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:econsultent/pages/notification.dart';

import 'Home.dart';
import 'existing-cards.dart';
import 'notification.dart';

class PaymentPage extends StatefulWidget {
  String meetingId ;
  String _cardNo, _exp, _vcc;

  PaymentPage({this.meetingId});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final mref = FirebaseDatabase.instance;

  //get the client Id
  String cid = "";
  Future<void> getUserID() async {
    final FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      cid = userData.uid.toString();
    });
  }

  //get booking amount
  String payAmount;
  Future<void> getAmount() async {
    await getUserID();
    final ref = mref
        .reference()
        .child('general_user')
        .child('$cid')
        .child('booking')
        .child(widget.meetingId);
    await ref.child('amount').once().then((DataSnapshot snapshot) {
      setState(() {
        payAmount = snapshot.value;
      });
    });
    print(payAmount);
    print(widget.meetingId);
  }

  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ExistingCardsPage(meetingId: widget.meetingId,)));
        print(widget.meetingId);
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    await dialog.hide();
    createAlertDialog(context);
  }

  createAlertDialog(BuildContext context){
    TextEditingController customController = TextEditingController();
    return showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Container(
          height: 290,
          child: Column(
          children: <Widget>[
          Container(
          child: Form(

            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox( height: 15, ),
                cardNo(),
                SizedBox( height: 15, ),
                exp(),
                SizedBox( height: 15, ),
                vcc(),
              ],
            ),
          ),
          ),
          ],
          ),
          ),

          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Save'),
              onPressed: () async {
                await save();
                Navigator.of(context).pop(customController.text.toString());
              },
            )
          ],
        );
    });
  }

  /// ******************************************
  Widget cardNo(){
    return Container(

      child: TextFormField(
          validator: (input) {
            if(input.isEmpty){
              return 'Card no cannot be empty';
            }
          },

          decoration: InputDecoration(
            labelText: 'Card No',
            hintText: '4242424242424242',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.credit_card ),
          ),

          onChanged: (val) {
            _cardNo = val;
          }
      ),
    );
  }

  Widget exp(){
    return Container(

      child: TextFormField(
          validator: (input) {
            if(input.isEmpty){
              return 'EXP date cannot be empty';
            }
          },

          decoration: InputDecoration(
            labelText: 'EXP Date',
            hintText: '05/25',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.calendar_today ),
          ),

          onChanged: (val) {
                  _exp = val;
          }
      ),
    );
  }

  Widget vcc(){
    return Container(

      child: TextFormField(
        //  controller: _passwordController,
          validator: (input) {
            if(input.isEmpty){
              return 'VCC cannot be empty';
            }
          },

          decoration: InputDecoration(
            labelText: 'VCC',
            hintText: '222',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock_outline_rounded ),
          ),

          onChanged: (val) {
                  _cvv = val;
          }
      ),
    );
  }
  /// *************Popup form****************

  /// *****GET GENERAL USER DETAILS*******
  DatabaseReference _ref;
  String name;
  /// ******************************************************
  /// Map user data
  /// ******************************************************
  getUserDetail() async{
    await getUserID();
    _ref = FirebaseDatabase.instance.reference().child('general_user');
    DataSnapshot snapshot = await _ref.child(cid).once();

    Map general_user = snapshot.value;
    name = general_user['name'];
  }
  /// *****Map user data*******
  String _cardNo, _exp, _cvv;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>( );
  final FirebaseDatabase database = FirebaseDatabase.instance;
  save() async{
    if (_formKey.currentState.validate( )) {
      await getUserDetail();
        database.reference().child("general_user").
        child(cid).child("card").child(CreateCryptoRandomString()).set({
          "cardHolderName" : name,
          "cardNumber" : _cardNo,
          'cvvCode' : _cvv,
          "expiryDate" : _exp,
          "showBackView" : false,
        });
    }
  }


  /// ******************************************************
  /// create a random number
  /// ******************************************************
  String CreateCryptoRandomString([int length = 8]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
  ///*********create a random number***********************

  @override
  void initState() {
    getUserID();
    super.initState();
    StripeService.init();
    getAmount(); //method to call get amount
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay via card'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Notifications()));
            }
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: theme.primaryColor);
                  text = Text('Pay via new card');
                  break;
                case 1:
                  icon = Icon(Icons.credit_card, color: theme.primaryColor);
                  text = Text('Pay via existing card');
                  break;
              }

              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: theme.primaryColor,
            ),
            itemCount: 2),
      ),
    );
    ;
  }
}
