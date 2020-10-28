import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/component/shared_components.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/pages/primary.dart';
import 'package:flutterapp/pages/signup.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutterapp/services/service_firebase.dart';
import 'package:flutterapp/services/service_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterapp/services/auth_service_imp.dart';
import 'package:flutterapp/services/service_locator.dart';

class LoginPage extends StatefulWidget {
  String email;

  LoginPage({this.email});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final login = TextEditingController();
  final password = TextEditingController();
  AuthServiceImp authServiceImp;
  PostServiceImp postServiceImp;
  ServiceProvider serviceProvider;
  FireBaseService fireBaseService;
  BuildContext dialogContext;
  String username;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) login.text = widget.email;
    authServiceImp = getIt<AuthServiceImp>();
    postServiceImp = getIt<PostServiceImp>();
    serviceProvider = getIt<ServiceProvider>();
    fireBaseService = getIt<FireBaseService>();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    login.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        //margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Image(
              width: 250,
              image: AssetImage('lib/assets/heyya_logo.png'),
            )),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: TextField(
                controller: login,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: TextField(
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment(1.0, 0.0),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
              child: InkWell(
                child: Text(
                  'forgot password',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: FlatButton(
                child: Text('login'),
                color: Colors.redAccent,
                textColor: Colors.white,
                onPressed: () {
                  onLogin();
                  //Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ),
            Center(
              child: FlatButton(
                child: Text('Register'),
                color: Colors.redAccent,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ));
                  //Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void onLogin() async {
    previewDialog();
    String user = login.text.trim();
    String pwd = password.text.trim();
    var result = await authServiceImp.checkLogin(user, pwd);
    Navigator.pop(context);
    if (result == null) {
      showToast("Problem Login in");
      return;
    }
    var status = result["statusCode"];
    if (status != null && status == 400) {
      showToast(result["message"]);
      return;
    }
    var accessToken = result["accessToken"];
    var username = result["username"];
    var id = result["id"];
    var avatar = result["avatar"];
    if (accessToken != null) {
      await authServiceImp.setLocalStorage(
          username, avatar, accessToken, id, 2);
      await fireBaseService.updateFireBaseUser(id);
      serviceProvider.initServices();
      authServiceImp.resetAuthService();
      postServiceImp.resetPostService();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
