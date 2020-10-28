import 'package:flutter/material.dart';
import 'user.dart';
import 'package:intl/intl.dart';

String title = "Instagram";

final User user = new User(
    'DWajdi', AssetImage('lib/assets/my_profile.jpg'), [], [], [], [], false);

// Text Styles
TextStyle textStyle = new TextStyle(fontFamily: 'Gotham');
TextStyle textStyleBold = new TextStyle(
    fontFamily: 'Gotham', fontWeight: FontWeight.bold, color: Colors.black);
TextStyle textStyleLigthGrey =
    new TextStyle(fontFamily: 'Gotham', color: Colors.grey);
TextStyle whiteText = TextStyle(fontSize: 15, color: Colors.white);
TextStyle whiteBoldText =
    TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700);

// Common FunctionStringCallback

formattingDate(DateTime date) {
  final f = new DateFormat('MMMM dd hh:mm a');
  return f.format(date);
}
