import 'dart:async';

import 'package:econsultent/pages/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  FirebaseUser user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser as FirebaseUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'An email has been sent to ${user.email} please verify'),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser as FirebaseUser;
    await user.reload();
    if (user.isEmailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  /// ***********************************************
  /// EMAIL VERIFICATION
  /// ***********************************************
  void sendVerificationEmail() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    //User firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser.sendEmailVerification();

   /* Fluttertoast.showToast(
        msg: "email verifcation link has sent to your email.");
*/
    /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
            (Route<dynamic> route) => false);*/
  }
}


