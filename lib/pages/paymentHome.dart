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
  PaymentPage({this.meetingId});

//  PaymentPage({Key key}) : super(key: key);

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
       // Navigator.pushNamed(context, '/existing-cards');
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ExistingCardsPage(meetingId: widget.meetingId,)));
        print(widget.meetingId);
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
      amount: payAmount.toString(),
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
      new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

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
