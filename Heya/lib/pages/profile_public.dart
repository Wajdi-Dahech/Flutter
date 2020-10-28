import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterapp/component/profile_components.dart';
import 'package:flutterapp/component/search_components.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/auth_service_imp.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/config/custom_extensions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PublicProfilePage extends StatefulWidget {
  UserModel userModel;

  PublicProfilePage(this.userModel);

  @override
  _PublicProfilePageState createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage>
    with SingleTickerProviderStateMixin {
  List<PostModel> posts;
  int currentIndex = 0;
  int page = 1;
  int limit = 9;
  TabController _controller;
  PostServiceImp postService;
  AuthServiceImp authServiceImp;
  dynamic userRating = 0;
  bool albumLoaded = false;
  ScrollController scrollController = new ScrollController();
  bool disableFollow = true;
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
    _controller = TabController(length: 3, vsync: this);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        //loadData();
      }
    });
    loadProfile();
    loadData();
  }

  loadProfile() async {
    loadRating();
    var response = await authServiceImp.getProfile(widget.userModel.id);
    disableFollow = false;
    var body = jsonDecode(response.body);
    widget.userModel = UserModel.fromJSON(body);
    if (this.mounted) {
      setState(() {});
    }
  }

  loadRating() async {
    var rate = await authServiceImp.getRateUser(widget.userModel.id);
    userRating = rate;
    if (this.mounted) {
      setState(() {});
    }
  }

  void loadData() async {
    albumLoaded = false;
    if (this.mounted) {
      setState(() {});
    }
    posts = await postService.getPostsByUser(widget.userModel, page, limit);
    //posts.addAll(list);
    albumLoaded = true;
    if (this.mounted) {
      setState(() {});
    }
  }

  onFollowUser() async {
    bool isFollowed = widget.userModel.isFollowed;
    if (isFollowed) {
      widget.userModel.followers--;
      widget.userModel.isFollowed = false;
      setState(() {});
      await postService.unFollowUser(widget.userModel.id);
    } else {
      widget.userModel.followers++;
      widget.userModel.isFollowed = true;
      setState(() {});
      await postService.followUser(widget.userModel.id);
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
            height: 240,
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 50),
                    Container(
                      child: Stack(
                        alignment: Alignment(0, 0),
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 48,
                          ),
                          getAvatar()
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${widget.userModel.firstname.capitalize()} ${widget.userModel.lastname.capitalize()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '@${widget.userModel.username.capitalize()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          getUserRole(widget.userModel.role),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            widget.userModel != null
                                ? '${widget.userModel.followers}'
                                : '0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        Text('Followers',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.userModel != null
                              ? '${widget.userModel.followings}'
                              : '0',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Following',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    !disableFollow
                        ? ButtonTheme(
                            minWidth: 110,
                            height: 35,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)),
                              onPressed: () {
                                onFollowUser();
                              },
                              color: widget.userModel.isFollowed
                                  ? Colors.white60
                                  : Colors.white,
                              textColor: widget.userModel.isFollowed
                                  ? Colors.black87
                                  : Colors.deepOrangeAccent,
                              child: Text(
                                  "${widget.userModel.isFollowed ? 'Unfollow' : 'Follow'}"
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                            ),
                          )
                        : ButtonTheme(
                            height: 35,
                            minWidth: 110,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)),
                              onPressed: () {},
                              color: Colors.redAccent,
                              textColor: Colors.white,
                              child: Text(
                                "Loading..",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userRating > 0 ? userRating.toStringAsFixed(2) : '0',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ...getStars(userRating, 20, Colors.white),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
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
            Tab(
              icon: const Icon(FontAwesomeIcons.star, size: 18),
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
                  posts != null
                      ? Flexible(child: profileAlbum(posts, scrollController))
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
              Card(child: profileInfoWidget()),
              Card(child: profileInfoWidget()),
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
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget getAvatar() {
    return widget.userModel != null
        ? CachedNetworkImage(
            imageUrl: widget.userModel.picture,
            imageBuilder: (context, imageProvider) => Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                Image.asset('lib/assets/default_profile.jpg'),
          )
        : CircleAvatar(
            backgroundImage: AssetImage('lib/assets/default_profile.jpg'),
            radius: 45,
          );
  }
}
