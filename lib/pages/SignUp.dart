import 'package:econsultent/pages/verify.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:econsultent/pages/Home.dart';
import 'package:econsultent/pages/Start.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
//import 'package:econsultent/pages/verify.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  String _name, _email, _password, NIC, password,_uploadeFileURL,fileURL;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen( (user) async
    {
      if (user != null) {
        Navigator.push( context, MaterialPageRoute(
            builder: (context) => //VerifyScreen()));
                HomePage( ) ) );
       // await sendVerificationEmail();
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
    if (_formKey.currentState.validate( )) {
      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password );
        await sendVerificationEmail();
        FirebaseUser user = result.user;
        if (user != null) {
          ////////
          _id = user.uid.toString( );
          print( _id );
          final ref = fb.reference( ).child( "general_user" ).child( '$_id' );
          ref.child( 'name' ).set( _name );
          ref.child( 'email' ).set( _email );
          ref.child( 'NIC' ).set( NIC );
          //ProPic path upload to database
          ref.child( "proPic" ).set( _pathImg );
          //call ProPic upload method
          String mediaUrl = await upload( context );
          ref.child('proPicURL').set(mediaUrl);

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

  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
                Icons.arrow_back
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Start()));
            },
          ),),

        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0,
          ),
          child: Container(

            child: Column(

              children: <Widget>[
                imageProfile( ),
                SizedBox(
                  height: 20,
                ),

                Container(

                  child: Form(

                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        nameFeld(),
                        SizedBox( height: 20, ),
                        nicfeld(),
                        SizedBox( height: 20, ),
                        emailFeld(),
                        SizedBox( height: 20, ),
                        createPassword(),
                        SizedBox( height: 20, ),
                        conformPassword(),
                        SizedBox( height: 20 ),
                        button(),
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

  /// ******************************************
  /// NAME
  /// ******************************************
  Widget nameFeld(){
  return Container(
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
      hintText: 'This is your user name',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      prefixIcon: Icon( Icons.person ),
    ),

    onChanged: (val) {
      _name = val;
    },

  ),
  );
  }
  /// *******************NAME********************

  /// ******************************************
  /// NIC
  /// ******************************************
  Widget nicfeld(){
    return Container(

        child: TextFormField(

            validator: (input) {
              if (input.isEmpty) {
                return 'Enter NIC';
              }else if(input.length>10){
                return 'Enter valid NIC';
              }
            },

            decoration: InputDecoration(
                labelText: 'NIC',
                hintText: 'This is yor national ID',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                prefixIcon: Icon( Icons.person )
            ),

            onChanged: (val) {
              NIC = val;
            }
        ),
      );
  }
  /// *******************NIC********************

  /// ******************************************
  /// EMAIL
  /// ******************************************
  Widget emailFeld() {
    return Container(
      child: TextFormField(
          validator: (input) {
            if (input.isEmpty)
              return 'Enter Email';
          },

          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'This is yor valid email',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
              prefixIcon: Icon( Icons.email )
          ),

          onChanged: (val) {
            _email = val;
          }
      ),
    );
  }
  /// *******************EMAIL**********************

  /// ******************************************
  /// CREATE PASSWORD
  /// ******************************************
  Widget createPassword(){
    return Container(

      child: TextFormField(
          controller: _passwordController,
          validator: (input) {
            if(input.isEmpty){
              return 'Password cannot be empty';
            }else if (input.length < 6) {
              return 'Provide Minimum 6 Character';
            }
          },

          decoration: InputDecoration(
            labelText: 'Create Password',
            hintText: 'Create new password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
          ),
          obscureText: true,

          onChanged: (val) {
            password = val;
          }
      ),
    );
  }
  /// *************Create Password****************

  /// ******************************************
  /// CONFORM PASSWORD
  /// ******************************************
  Widget conformPassword() {
    return Container(

      child: TextFormField(
          controller: _confirmPasswordController,
          validator: (input) {
            if (input != _passwordController.value.text)
              return 'Password do not match!';
          },

          decoration: InputDecoration(
            labelText: 'Conform Password',
            hintText: 'Type created password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
          ),
          obscureText: true,

          onChanged: (val) {
            _password = val;
          }
      ),
    );
  }
  /// *************CONFORM PASSWORD*****************

  /// **********************************************
  /// Image selection
  /// **********************************************
  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _image == null
              ? AssetImage( "images/avatar.png" )
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

  /// **********************************************
  /// Image selection method popup
  /// **********************************************
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

  /// **********************************************
  /// Image Picker methd
  /// **********************************************
  void takePhoto(ImageSource source) async {
    var image = await ImagePicker.pickImage(
      source: source,
    );
    setState( () {
      _image = image;
      _pathImg = path.basename(_image.path);
    } );
  }

  /// **********************************************
  /// ProPic upload to firebase storage
  /// **********************************************
  Future<String> upload(BuildContext context) async {
    String imageName = path.basename(_image.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    // Once the image is uploaded to firebase get the download link.
    String downlaodUrl = await taskSnapshot.ref.getDownloadURL();
    print(downlaodUrl);
    return downlaodUrl;
  }

  /// **********************************************
  /// SIGNUP BUTTON
  /// **********************************************
  Widget button(){
    return RaisedButton(
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
    );
  }
  /// ***********SIGNUP BUTTON***********************


  /// ***********************************************
  /// EMAIL VERIFICATION
  /// ***********************************************
  void sendVerificationEmail() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    //User firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser.sendEmailVerification();

    Fluttertoast.showToast(
        msg: "email verifcation link has sent to your email.");

    /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
            (Route<dynamic> route) => false);*/
  }
}