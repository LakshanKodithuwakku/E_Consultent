import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Start.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('Reset Password'),
          leading: IconButton(
              icon: Icon(
                  Icons.arrow_back
              ),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Start()));
              }// navigateToStart(),
          ),),

        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  child: Image(image: AssetImage("images/login.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[

                        Container(
                          child: TextFormField(
                              validator: (value)
                              {
                                if(value.isEmpty)
                                  return 'Enter Email';
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0)
                                  ),
                                  prefixIcon:Icon(Icons.email)
                              ),

                            onChanged: (value) {
                              setState(() {
                                _email = value.trim();
                              });
                            },

                          ),
                        ),

                          SizedBox(height:20),

                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70,10,70,10),
                          onPressed: (){
                            _formKey.currentState.validate();
                            auth.sendPasswordResetEmail(email: _email);
                            Navigator.of(context).pop();
                          },
                          child: Text('Send Request',style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          )),
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
}



