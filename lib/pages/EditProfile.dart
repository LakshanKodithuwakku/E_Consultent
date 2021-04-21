import 'package:econsultent/passwordChange/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:econsultent/pages/Home.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

String a;
class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController;

  bool showCurrentPassword = true;
  bool showPassword = true;
  bool showConformPassword = true;

  File _image;
  String _name, _password, _pathImg = "";
  String name="",proPic="",password;

  DatabaseReference _ref;
  @override
  void initState() {
    super.initState( );
    _nameController = TextEditingController();
   // getData();
    getUserID();
    getUserDetails();
  }

 /* //-------init function can not make as asynchronous function
  Future<void> getData() async {
      await getUserID();
      await getUserDetails();
  }
  //-----------------------------------------------*/

  //--------------------Retrive user id from firebase
  FirebaseUser user;
  String id;
  Future<void> getUserID() async {
    final FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      id = userData.uid.toString();
    });
  }
//------------------------------------------------------

  /// *******************************************************
  /// GET USER DETAILS
  /// *******************************************************
  Future<void> getUserDetails( ) async{
    await getUserID();
    _ref = FirebaseDatabase.instance.reference( ).child( 'general_user' );
    DataSnapshot snapshot = await _ref.child("$id").once();
    Map general_user = snapshot.value;
    _nameController.text = general_user['name'];
    _name = general_user['name'];
    print(_name);
    proPic = general_user['proPicURL'];
    print(proPic);
  }
  /// *****************GET USER DETAILS********************

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
    //String
    proPic = await taskSnapshot.ref.getDownloadURL();
    print(proPic);
    return proPic;
  }

  /// ******************************************************
  /// SEND TO DATABASE
  /// ******************************************************
  final FirebaseDatabase database = FirebaseDatabase.instance;
  Future<void> _userUpdate() async {
    if(_image != null) {
      database.reference( ).child( "general_user" ).
      child( "${user.uid}" ).update( {
        "name": _name,
        "proPic": _pathImg,
        "proPicURL": await upload( context )
      } );
    }else{
      database.reference( ).child( "general_user" ).
      child( "${user.uid}" ).update( {
        "name": _name,
      } );
    }
    setState(() {
      database.reference().child("general_user").once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> data = snapshot.value;
        print("Value: $data");
      });
    });

  }
  /// ****************SEND TO DATABASE*****************

  /// *****************************************
  /// Page Body
  /// *****************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(title: Text("Edit Profile"),centerTitle: true,
          leading: IconButton(
            icon: Icon(
                Icons.arrow_back
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
            },
          ),),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            child: Column(

              children: <Widget>[
                SizedBox(
                  height: 70.0,
                ),
                imageProfile( ),
                SizedBox(
                  height: 20,
                ),

                Container(

                  child: Form(

                    child: Column(

                      children: <Widget>[
                        displayName(),
                        SizedBox( height: 20 ),
                        test(),
              /*          currentPassword(),
                        SizedBox( height: 20 ),
                        newPassword(),
                        SizedBox( height: 20 ),
                        conformNewPassword(),
                        SizedBox( height: 70 ),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CancelButton(),
                            SizedBox(width: 20,),
                            SaveButton(),
                          ],
                        )
*/
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

  /// *****************************************
  /// current Name
  /// *****************************************
  Widget displayName(){
    return Container(
      child: TextFormField(
        controller: _nameController,
        validator: (input) {
          if (input.isEmpty) {
            return 'Enter Name';
          }else if(input.length<4){
            return 'Username should be grater than or equel 4';
          }
        },

        decoration: InputDecoration(
          hintText: 'Enter new name',
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
  /// ***********current name**************

  /// *****************************************
  /// current Password
  /// *****************************************
  Widget currentPassword(){
    return Container(

      child: TextFormField(

          validator: (input) {
            if (input.length < 6)
              return 'Provide Minimum 6 Character';
          },

          decoration: InputDecoration(
            labelText: 'Current Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () => setState((){
                showCurrentPassword = ! showCurrentPassword;
              }),
            ),
          ),
          obscureText: showCurrentPassword,

          onChanged: (val) {
            _password = val;
          }
      ),
    );
  }
  /// *********current Password***************

  /// *****************************************
  /// New Password
  /// *****************************************
  Widget newPassword(){
    return Container(

      child: TextFormField(

          validator: (input) {
            if (input.length < 6)
              return 'Provide Minimum 6 Character';
          },

          decoration: InputDecoration(
            labelText: 'Create New Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () => setState((){
                showPassword = ! showPassword;
              }),
            ),
          ),
          obscureText: showPassword,

          onChanged: (val) {
            _password = val;
          }
      ),
    );
  }
  /// *********New Password***************

  /// *****************************************
  /// Conform New Password
  /// *****************************************
  Widget conformNewPassword(){
    return Container(

      child: TextFormField(

          validator: (input) {
            if (input.length < 6)
              return 'Provide Minimum 6 Character';
          },

          decoration: InputDecoration(
            labelText: 'Conform New Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            prefixIcon: Icon( Icons.lock ),
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () => setState((){
                showConformPassword = ! showConformPassword;
              }),
            ),
          ),
          obscureText: showConformPassword,

          onChanged: (val) {
            _password = val;
          }
      ),
    );
  }
  /// *********Conform New Password***************

  /// *****************************************
  /// Save Button
  /// *****************************************
  Widget SaveButton(){
    return FlatButton(
      padding: EdgeInsets.only(left:45,right:45),

      onPressed: (){
        upload(context);
        _userUpdate();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
      },
      child: Text( 'SAVE', style: TextStyle(
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

  /// *****************************************
  /// Cancel Button
  /// *****************************************
  Widget CancelButton(){
   return FlatButton(
      padding: EdgeInsets.only(left:35,right:35),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
      },
      child: Text( 'CANCEL', style: TextStyle(
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

  /// *****************************************
  /// Profile Pic
  /// *****************************************
  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _image == null
              ? NetworkImage(proPic)
              : FileImage( File( _image.path )),
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

  /// *****************************************
  /// Image select method popup
  /// *****************************************
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

  /// *****************************************
  /// Image Picker method
  /// *****************************************
  void takePhoto(ImageSource source) async {
    var image = await ImagePicker.pickImage(
      source: source,
    );
    setState( () {
      _image = image;
      _pathImg = path.basename(_image.path);
    } );
  }


  Widget test(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 20.0),
          Flexible(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Change Password",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Password',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 3.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.pinkAccent, width: 2.0)),
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'AvenirLight'),
                      hintText: "Password",
                      errorText: checkCurrentPasswordValid
                          ? null
                          : "Please double check your current password",
                    ),
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'New Password',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white, width: 3.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.pinkAccent, width: 2.0)),
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontFamily: 'AvenirLight'),
                        hintText: "New Password"),
                    controller: _newPasswordController,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Repeat Password',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 3.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.pinkAccent, width: 2.0)),
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'AvenirLight'),
                      hintText: "Repeat Password",
                    ),
                    obscureText: true,
                    controller: _repeatPasswordController,
                    validator: (value) {
                      return _newPasswordController.text == value           //check repeat password previous entered password
                          ? null
                          : "Please validate your entered password";
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          RaisedButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onPressed: () async {
              //      var auth = locator.get<UserController>();
              UserController auth = UserController();            //creat a object of User controller class
              checkCurrentPasswordValid = await auth
                  .validateCurrentPassword(_passwordController.text);          //true or false

              setState(() {});

              if (_formKey.currentState.validate() &&
                  checkCurrentPasswordValid) {
                auth.updateUserPassword(_newPasswordController.text);
                Navigator.pop(context);
              }
            },
            child: Text("Save Password",
                style: TextStyle(
                    fontSize: 14, letterSpacing: 1, color: Colors.black)),
          ),
        ],
      ),
    );
  }
  var _displayNameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool checkCurrentPasswordValid = true;

  @override
  void dispose() {
    _displayNameController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }


}