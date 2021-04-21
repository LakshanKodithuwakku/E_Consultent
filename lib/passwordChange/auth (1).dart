import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth
      .instance;

  //Sign out
  Future signOut() async {
    FirebaseUser user = await _auth.currentUser();
    try {
      print(user.providerData[1].providerId);
      /*    if (user.providerData[1].providerId == 'google.com') {
        return await _googleSignIn.disconnect();
      }  */
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  //validate the current password
  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _auth.currentUser(); //get the current user

    var authCredentials = EmailAuthProvider.getCredential(
        //create auth credential with current user's email and password that you pass(entered)
        email: firebaseUser.email,
        password: password);
    try {
      var authResult = await firebaseUser.reauthenticateWithCredential(
          authCredentials); //try to reauthticate with those credential
      return authResult.user != null; //if there is user return true
    } catch (e) {
      print(e);
      return false;
    }
  }

  //update the password
  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser();
    firebaseUser.updatePassword(password);         //update the password of current user
  }
}
