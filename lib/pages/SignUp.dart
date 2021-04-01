import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'LogoutPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:econsultent/pages/home_page.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  File _image;

  /////////
  final fb = FirebaseDatabase.instance;
  //////

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>( );

  String _name, _email, _password;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen( (user) async
    {
      if (user != null) {
        Navigator.push( context, MaterialPageRoute(
            builder: (context) => HomePage( ) ) );
      }
    }
    );
  }

  @override
  void initState() {
    super.initState( );
    this.checkAuthentication( );
  }

  String _id = "";
  String _pathImg = "";

  signUp() async {
    if (_formKey.currentState.validate( ) && _image != null) {
      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password );
        FirebaseUser user = result.user;
        if (user != null) {
          ////////
          _id = user.uid.toString( );
          print( _id );
          final ref = fb.reference( ).child( "general_user" ).child( '$_id' );
          ref.child( 'name' ).set( _name );
          ref.child( 'email' ).set( _email );

          //call ProPic upload method
          upload( context );
          //ProPic path upload to database
          ref.child( "proPic" ).set( _pathImg );

          UserUpdateInfo updateuser = UserUpdateInfo( );
          updateuser.displayName = _name;
          user.updateProfile( updateuser );
        }
      }
      catch (e) {
        showError( e.message );
        print( e );
      }
    }
    else {
      //call propic error
      showError1();
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text( 'ERROR' ),
            content: Text( errormessage ),

            actions: <Widget>[
              FlatButton(

                  onPressed: () {
                    Navigator.of( context ).pop( );
                  },
                  child: Text( 'OK' ) )
            ],
          );
        }
    );
  }

  //Propic error
  showError1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text( 'ERROR' ),
            content: Text( 'Set your profile picture!' ),

            actions: <Widget>[
              FlatButton(

                  onPressed: () {
                    Navigator.of( context ).pop( );
                  },
                  child: Text( 'OK' ) )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
          child: Container(

            child: Column(

              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),

                imageProfile( ),
                SizedBox(
                  height: 20,
                ),

                Container(

                  child: Form(

                    key: _formKey,
                    child: Column(

                      children: <Widget>[

                        Container(

                          child: TextFormField(

                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Enter Name';
                              }else if(input.length<4){
                                return 'Username should be grater than or equel 4';
                              }
                            },

                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon( Icons.person ),
                            ),

                            // onSaved: (input) => _name = input
                            onChanged: (val) {
                              _name = val;
                            },

                          ),
                        ),

                        Container(

                          child: TextFormField(

                              validator: (input) {
                                if (input.isEmpty)
                                  return 'Enter Email';
                              },

                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon( Icons.email )
                              ),

                              //onSaved: (input) => _email = input
                              onChanged: (val) {
                                _email = val;
                              }
                          ),
                        ),

                        Container(

                          child: TextFormField(

                              validator: (input) {
                                if (input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },

                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon( Icons.lock ),
                              ),
                              obscureText: true,

                              //onSaved: (input) => _password = input
                              onChanged: (val) {
                                _password = val;
                              }
                          ),
                        ),

                        SizedBox( height: 20 ),

                        RaisedButton(
                          padding: EdgeInsets.fromLTRB( 70, 10, 70, 10 ),
                          onPressed: signUp,
                          child: Text( 'SignUp', style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          )
                          ),
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular( 20.0 ),
                          ),
                        )

                      ],
                    ),

                  ),
                ),
              ],
            ),
          ),
        )

    );
  }

  //Image selection
  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _image == null
              ? AssetImage( "images/my3.jpg" )
              : FileImage( File( _image.path ) ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet( )),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.black38,
              size: 28.0,
            ),
          ),
        ),
      ],
    );
  }

  //Popup and selct image
  Widget bottomSheet() {
    return Container(
      height: 100.0,
       width: MediaQuery
           .of( context )
           .size
           .width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column( children: <Widget>[
        Text( "Choose Profile photo",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon( Icons.camera ),
              onPressed: () {
                takePhoto( ImageSource.camera );
              },
              label: Text( "Camera" ),
            ),
            FlatButton.icon(
              icon: Icon( Icons.image ),
              onPressed: () {
                takePhoto( ImageSource.gallery );
              },
              label: Text( "Gallery" ),
            ),
          ],
        )
      ],
      ),
    );
  }

//Image Picker methd
  void takePhoto(ImageSource source) async {
    var image = await ImagePicker.pickImage(
      source: source,
    );
    setState( () {
      _image = image;
      _pathImg = path.basename(_image.path);
    } );
  }

  //ProPic upload to firebase storage
  Future upload(BuildContext context) async {
    String imageName = path.basename(_image.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {});
  }

}