import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutterapp/component/profile_components.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/auth_service_imp.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutterapp/component/video_thumbnail.dart';
import 'package:flutterapp/services/service_locator.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  int page = 1;
  int limit = 10;
  int currentIndex = 0;
  bool albumLoaded = false;
  TabController _controller;
  PostServiceImp postService;
  AuthServiceImp authServiceImp;
  List<PostModel> posts;
  List<PostModel> myPosts;
  UserModel profile;
  ScrollController scrollController = new ScrollController();
  SharedPreferences prefs;

  List<IconData> _icons = [
    FontAwesomeIcons.photoVideo,
    FontAwesomeIcons.solidHeart,
    FontAwesomeIcons.list,
  ];

  @override
  void initState() {
    super.initState();
    postService = getIt<PostServiceImp>();
    authServiceImp = getIt<AuthServiceImp>();
    _controller = TabController(length: 2, vsync: this);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {}
    });
    loadProfile();
  }

  loadProfile() async {
    prefs = await SharedPreferences.getInstance();
    var response = await authServiceImp.getMyProfile();
    if (!response.isSuccessful) {
      albumLoaded = true;
      myPosts = List();
      return;
    }
    var body = jsonDecode(response.body);
    if (this.mounted) {
      setState(() {
        profile = UserModel.fromJSON(body);
      });
    }
    loadData();
    checkUpdatedInfo();
  }

  void loadData() async {
    if (this.mounted) {
      setState(() {
        albumLoaded = false;
      });
    }
    var response = await postService.getMyposts();
    var body = jsonDecode(response.body);
    if (this.mounted) {
      setState(() {
        myPosts = PostModel.listFromJSON(body["items"], profile);
        //posts.addAll(list);
        albumLoaded = true;
      });
    }
  }

  checkUpdatedInfo() {
    if (profile == null) {
      return;
    }
    FULL_NAME = profile.firstname + ' ' + profile.lastname;
    AVATAR_IMG = profile.picture;
    USER_NAME = profile.username;
    USER_ROLE = profile.role;
    if (prefs.getString(FULLNAME) != FULL_NAME) {
      prefs.setString(FULLNAME, FULL_NAME);
    }
    if (prefs.getInt(ROLE) != USER_ROLE) {
      prefs.setInt(ROLE, USER_ROLE);
    }
    if (prefs.getString(AVATAR) != AVATAR_IMG) {
      prefs.setString(AVATAR, AVATAR_IMG);
    }
    if (prefs.getString(USERNAME) != USER_NAME) {
      prefs.setString(USERNAME, USER_NAME);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red[700], Colors.redAccent]),
            ),
            height: 250,
          ),
          Center(
            child: Container(
              height: 210,
              margin: EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                        ),
                        AVATAR_IMG != null
                            ? CachedNetworkImage(
                                imageUrl: AVATAR_IMG,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'lib/assets/default_profile.jpg'),
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(
                                    'lib/assets/default_profile.jpg'),
                                radius: 38,
                              ),
                      ],
                    ),
                  ),
                  Text("@" + USER_NAME != null ? USER_NAME : '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300)),
                  Text(FULL_NAME != null ? FULL_NAME : '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 3),
                  Text(profile != null ? getUserRole(profile.role) : "Client",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(profile != null ? '${profile.followers}' : '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                          Text('Followers',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(profile != null ? '${profile.followings}' : '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                          Text('Following',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        onPressed: () {
                          logout();
                        },
                        color: Colors.white,
                        textColor: Colors.deepOrangeAccent,
                        child: Text("Logout".toUpperCase(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ]),
        TabBar(
          controller: _controller,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black87,
          indicatorColor: Colors.black87,
          tabs: [
            Tab(
              icon: const Icon(FontAwesomeIcons.photoVideo, size: 18),
            ),
            Tab(
              icon: const Icon(FontAwesomeIcons.list, size: 18),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  myPosts != null
                      ? Flexible(child: profileAlbum(myPosts, scrollController))
                      : Container(),
                  Center(
                    child: !albumLoaded
                        ? Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            child: SpinKitCircle(size: 30, color: Colors.grey),
                          )
                        : Container(),
                  )
                ],
              )),
              Card(child: profileInfoWidget())
            ],
          ),
        )
      ],
    ));
  }

  List<Widget> getIcons() {
    List<Widget> icons = List();
    for (int i = 0; i < _icons.length; i++) {
      icons.add(Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentIndex = i;
            });
          },
          child: Container(
            color: currentIndex == i ? Colors.grey[100] : Colors.white,
            height: 50,
            child: Icon(_icons[i],
                size: 18,
                color: currentIndex == i ? Colors.redAccent : Colors.black),
          ),
        ),
      ));
    }
    return icons;
  }

  void logout() async {
    await authServiceImp.clearLocalStorage();
    authServiceImp.resetAuthService();
    postService.resetPostService();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
