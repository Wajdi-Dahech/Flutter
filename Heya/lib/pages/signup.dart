import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/component/shared_components.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/models/global.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/pages/primary.dart';
import 'package:flutterapp/pages/signin.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutterapp/services/service_firebase.dart';
import 'package:flutterapp/services/service_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterapp/services/auth_service_imp.dart';
import 'package:flutterapp/services/service_locator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController passwordController = TextEditingController();
  String password;
  String confirmPassword;
  String email;
  String firstname;
  String lastname;
  String username;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String dropdownValue = ROLES["CLIENT"];
  AuthServiceImp authServiceImp;
  PostServiceImp postServiceImp;
  ServiceProvider serviceProvider;
  FireBaseService fireBaseService;
  BuildContext dialogContext;

  @override
  void initState() {
    super.initState();
    authServiceImp = getIt<AuthServiceImp>();
    postServiceImp = getIt<PostServiceImp>();
    serviceProvider = getIt<ServiceProvider>();
    fireBaseService = getIt<FireBaseService>();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        //margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Center(
                child: Text("Sign Up",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              Center(
                child: Image(
                  width: 250,
                  image: AssetImage('lib/assets/heyya_logo.png'),
                ),
              ),
              SizedBox(height: 60),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Name is required';
                        }
                      },
                      onSaved: (String value) {
                        firstname = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Lastname is required';
                        }
                      },
                      onSaved: (String value) {
                        lastname = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Email is required';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Invalid Email';
                        }
                      },
                      onSaved: (String value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Username is required';
                        }
                      },
                      onSaved: (String value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      controller: passwordController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return "Password's length should be at least 6";
                        }
                      },
                      onSaved: (String value) {
                        password = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Confirm password is required';
                        }
                        if (passwordController.text != value) {
                          return 'Password dont match';
                        }
                      },
                      onSaved: (String value) {
                        confirmPassword = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Text(
                      "I'm a : ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[ROLES["CLIENT"], ROLES["PROFESSIONAL"]]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Center(
                child: FlatButton(
                  child: Text('Register'),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    onRegister();
                    //Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),
              Center(
                child: FlatButton(
                  child: Text('Login'),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                    //Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onRegister() async {
    //previewDialog();
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    print("username: " + username);
    /*print(firstname);
    print(lastname);
    print(email);
    print(password);
    print(confirmPassword);*/
    var role = dropdownValue == ROLES["CLIENT"] ? 2 : 3;

    Map<String, dynamic> body = Map();
    body.addEntries([
      MapEntry("email", email),
      MapEntry("firstname", firstname),
      MapEntry("lastname", lastname),
      MapEntry("username", username.trim()),
      MapEntry("password", password),
      MapEntry("confirmPassword", confirmPassword),
      MapEntry("role", role),
    ]);
    var data = await this.authServiceImp.registerUser(body);
    if (data != null) {
      print(data.statusCode);
      if (data.statusCode == 400) {
        var body = jsonDecode(data.body);
        showToast(body["message"]);
      } else if (data.statusCode == 201) {
        showToast("SingUp Sucessfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              email: email,
            ),
          ),
        );
      }
    }
  }

  void previewDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 80,
            width: 80,
            child: Center(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Loading..."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
