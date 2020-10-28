import 'dart:ui';

const String LOGGED = "LOGGED";
const String ACCESS_TOKEN = "ACCESS_TOKEN";
const String BASE_URL = "https://heya-dev.herokuapp.com";

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

const String FIRESTORAGE = "gs://heyya-edbfb.appspot.com";
const String USERNAME = "USERNAME";
const String FULLNAME = "FULLNAME";
const String AVATAR = "AVATAR";
const String USERID = "USERID";
const String ROLE = "ROLE";
String USER_NAME = "username";
int USER_ID = -1;
int USER_ROLE = 2;
String USER_TOKEN = "";
String FULL_NAME = "full name";
String AVATAR_IMG = "";
bool isLOGGED = false;
Map<String, String> ROLES = {
  "CLIENT": "CLIENT",
  "PROFESSIONAL": "PROFESSIONAL"
};
var videos = [
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'
];
