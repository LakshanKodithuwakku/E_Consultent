import 'package:econsultent/pages/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:econsultent/services/payment-service.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  String meetingId;
  ExistingCardsPage({this.meetingId});

 // ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {

  String consultentId;
  @override
  void initState() {
    super.initState();
    getData();
    getConsultantDetail();
  }

  Future<void> getData() async {
    await getUserID();
    _reff = FirebaseDatabase.instance.reference()
        .child('general_user').child(id//'L5GT25FSKgQ5bURE2GjHTHPgQqN2'
    ).child('card');
  }


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

  payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
      message: 'Please wait...'
    );
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
      amount: '15000',
      currency: 'LKR',
      card: stripeCard
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        )
      ).closed.then((_) {
        Navigator.pop(context);
        print(widget.meetingId);
        print(id);
        print("chiku");

      //  _savePrice();////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: list()
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  Query _reff;

  Widget _buildContactItem({Map card}){
    return InkWell(
      onTap: () {
        payViaExistingCard(context, card);
      },
      child: CreditCardWidget(
        cardNumber: card['cardNumber'],
        expiryDate: card['expiryDate'],
        cardHolderName: card['cardHolderName'],
        cvvCode: card['cvvCode'],
        showBackView: false,
      ),
    );
  }


  Widget list() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          child: FirebaseAnimatedList(
            query: _reff,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              // ignore: non_constant_identifier_names
              Map card = snapshot.value;
              card['key'] = snapshot.key;
              print(card['key']);
              return _buildContactItem(card: card);
            },
          ),
        ),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  DatabaseReference _ref;
  getConsultantDetail() async{
    await getUserID();
    _ref = FirebaseDatabase.instance.reference().child('general_user').child(id).child("booking");
    DataSnapshot snapshot = await _ref.child(widget.meetingId).once();

    Map booking = snapshot.value;
    consultentId = booking['consultentId'];
    print (consultentId);
  }

  /// ******************************************************
  /// SEND TO DATABASE
  /// ******************************************************
  final FirebaseDatabase database = FirebaseDatabase.instance;
  void _savePrice(){
    database.reference().child("general_user").
    child(id).child("booking").child(widget.meetingId).update({
      "pay" : 'true',
    });
    database.reference().child("Consultants").
    child(consultentId).child("acceptedmeetings").child(widget.meetingId).update({
      "pay" : 'true',
    });

    setState(() {
      database.reference().child("Client").once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> data = snapshot.value;
        print("Value: $data");
      });
    });
  }
/// ****************SEND TO DATABASE*****************


}