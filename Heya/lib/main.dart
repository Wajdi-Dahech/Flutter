import 'package:flutter/material.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/pages/loading.dart';
import 'package:flutterapp/pages/primary.dart';
import 'package:flutterapp/pages/signin.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setup();
  // _setupLogging();
  runApp(MyApp());
//  runApp(DevicePreview(
//    enabled: !kReleaseMode,
//    builder: (context) => MyApp(),
//  ));
  initSharedPreferences();
}

_setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print('${event.level.name} : ${event.time}: ${event.message}');
  });
}

initSharedPreferences() async {
  var prefs = await SharedPreferences.getInstance();
  FULL_NAME = prefs.getString(FULLNAME);
  AVATAR_IMG = prefs.get(AVATAR);
  USER_NAME = prefs.getString(USERNAME);
  USER_ID = prefs.getInt(USERID);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //locale: DevicePreview.of(context).locale,
      // <--- Add the locale
      // builder: DevicePreview.appBuilder,
      // <--- Add the builder
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => MyHomePage(),
        '/login': (context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Heya.tn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
