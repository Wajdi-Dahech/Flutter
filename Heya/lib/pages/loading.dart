import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/services/auth_service_imp.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutterapp/services/service_firebase.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:flutterapp/services/service_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  FireBaseService fireBaseService;
  AuthServiceImp authServiceImp;
  PostServiceImp postServiceImp;
  ServiceProvider serviceProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireBaseService = getIt<FireBaseService>();
    authServiceImp = getIt<AuthServiceImp>();
    postServiceImp = getIt<PostServiceImp>();
    serviceProvider = getIt<ServiceProvider>();
    fireBaseService.init();
    Future.delayed(Duration(seconds: 1), () {
      checkLogged();
    });
  }

  checkLogged() async {
    await authServiceImp.getLocalStorage();
    if (isLOGGED != null && isLOGGED == true) {
      serviceProvider.initServices();
      authServiceImp.resetAuthService();
      postServiceImp.resetPostService();
      fireBaseService.updateFireBaseUser(USER_ID);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.redAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                width: 250,
                image: AssetImage('lib/assets/heyya_logo_white.png'),
              ),
              SizedBox(
                height: 40,
              ),
              SpinKitFadingCube(
                color: Colors.white,
                size: 50.0,
              )
            ],
          )),
    );
  }
}
