import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:econsultent/pages/home_page.dart';
import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:path/path.dart' as path;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  File _image;
  String _name, _email, _password;

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
                              hintText: 'Lakshan',
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

                        SizedBox( height: 70 ),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CancelButton(),
                            SizedBox(width: 20,),
                            SaveButton(),
                          ],
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

  /// *****************************************
  /// Save Button
  /// *****************************************
  Widget SaveButton(){
    return FlatButton(
      padding: EdgeInsets.only(left:45,right:45),

      onPressed: (){

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
      //_pathImg = path.basename(_image.path);
    } );
  }

}