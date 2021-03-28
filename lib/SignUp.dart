import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  /////////
   final fb = FirebaseDatabase.instance;
  //////

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password;

  checkAuthentication() async {

    _auth.onAuthStateChanged.listen((user) async
    {
      if(user != null)
      {
        Navigator.push(context, MaterialPageRoute(

            builder: (context)=>HomePage()));
      }
    }
    );
  }

  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  signUp()async{
    if(_formKey.currentState.validate())
    {
      _formKey.currentState.save();
      try {
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password )) as FirebaseUser;
        if (user != null) {
          ////////
          final ref = fb.reference().child("Student");
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          ref.child(user.uid).set({
            "name": _name,
            "password": _password,
            "email":_email,
          }
          );
          ////////
          UserUpdateInfo updateuser = UserUpdateInfo( );
          updateuser.displayName = _name;
          user.updateProfile( updateuser );

        }
      }
      catch(e){
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage){

    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(

            title: Text('ERROR'),
            content: Text(errormessage),

            actions: <Widget>[
              FlatButton(

                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
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

                imageProfile(),
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

                              validator: (input)
                              {
                                if(input.isEmpty)
                                  return 'Enter Name';
                              },

                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon:Icon(Icons.person),
                              ),

                             // onSaved: (input) => _name = input
                      onChanged: (val){
                      _name=val;
                },

                          ),
                        ),

                        Container(

                          child: TextFormField(

                              validator: (input)
                              {
                                if(input.isEmpty)
                                  return 'Enter Email';
                              },

                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon:Icon(Icons.email)
                              ),

                             //onSaved: (input) => _email = input
                            onChanged: (val){
                            _email=val;
                            }
                          ),
                        ),

                        Container(

                          child: TextFormField(

                              validator: (input)
                              {
                                if(input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },

                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:Icon(Icons.lock),
                              ),
                              obscureText: true,

                              //onSaved: (input) => _password = input
                              onChanged: (val) {
                                _password = val;
                              }
                          ),
                        ),

                        SizedBox(height:20),

                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70,10,70,10),
                          onPressed: signUp,
                          child: Text('SignUp',style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          )
                          ),
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
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

  Widget imageProfile() {
      return Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile==null
                ? AssetImage("images/my3.jpg")
                : FileImage(File(_imageFile.path)),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
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

  Widget bottomSheet(){
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        Text("Choose Profile photo",
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
              icon: Icon(Icons.camera),
              onPressed: (){
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: (){
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ],
        )
      ],
      ),
    );
  }

//Image Picker methd
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState((){
      _imageFile = pickedFile;
    });
  }

}