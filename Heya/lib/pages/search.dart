import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/component/search_components.dart';
import 'package:flutterapp/models/item_model.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/auth_service_imp.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> sorts = ["Name", "Stars", "Followers"];
  List<String> specialties = [
    "Any",
    "Salon Owner",
    "Spa Owner",
    "Makeup Artist",
    "Hairstylist",
    "Colorist",
    "Esthetician",
    "Make up"
  ];
  int page = 1;
  int limit = 10;
  int sortIndex = 0;
  int specialtyIndex = 0;
  int selectedState;
  int selectedCity;
  bool userLoaded = false;
  PostServiceImp serviceImp;
  AuthServiceImp userService;
  GlobalKey<ScaffoldState> _drawerKey;
  List<States> states;
  List<City> currentCities;
  RefreshController _refreshController;
  List<UserModel> users;
  TextStyle optionTitle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.8);

  @override
  void initState() {
    super.initState();
    states = getLocations();
    serviceImp = getIt<PostServiceImp>();
    userService = getIt<AuthServiceImp>();
    _refreshController = RefreshController(initialRefresh: true);
    currentCities = List();
    _drawerKey = GlobalKey();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    page = 1;
    users = null;
    _refreshController.resetNoData();
    if (mounted) setState(() {});
    await loadData();
    if (mounted) setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    int nb = await loadData();
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
    if (nb == 0) {
      _refreshController.loadNoData();
    }
    if (mounted) setState(() {});
  }

  Future<int> loadData() async {
    int nb = 0;
    List<UserModel> list = await this.userService.getDiscoverUsers(page, limit);
    if (users == null) {
      users = List();
    }
    users.addAll(list);
    if (list.length > 0) {
      page++;
    }
    nb = list.length;
    return nb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search",
            style: TextStyle(
              fontFamily: 'PlayBall',
              fontSize: 25,
            )),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SmartRefresher(
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.redAccent,
          color: Colors.white,
        ),
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed! Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else if (mode == LoadStatus.noMore) {
              body = users != null && users.length > 0
                  ? Text("No more users")
                  : Text('');
            } else {
              body = Text("");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: ListView(
          children: getUsersWidget(),
        ),
      ),
      key: _drawerKey,
      // assign key to Scaffold
      floatingActionButton: Container(
        height: 40,
        child: FloatingActionButton(
          backgroundColor: Colors.grey[600],
          onPressed: () {
            print('opening drawer');
            _drawerKey.currentState.openDrawer();
          },
          child: FaIcon(
            FontAwesomeIcons.cog,
            size: 15,
          ),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sort By',
                  style: optionTitle,
                ),
                SizedBox(height: 10),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: sorts
                        .asMap()
                        .entries
                        .map((e) => getSortWidget(e.key, e.value))
                        .toList()),
                SizedBox(height: 20),
                Text(
                  'Location',
                  style: optionTitle,
                ),
                SizedBox(height: 10),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [getLocationFilter()]),
                SizedBox(height: 20),
                Text(
                  'Specialties',
                  style: optionTitle,
                ),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 4.5,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 3,
                    children: getSpecialties(),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.redAccent)),
                  onPressed: () {},
                  color: Colors.red[300],
                  textColor: Colors.white,
                  child: Text("Apply".toUpperCase(),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.grey[300])),
                  onPressed: () {},
                  color: Colors.grey[200],
                  textColor: Colors.black87,
                  child: Text("Reset".toUpperCase(),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget getSortWidget(int index, String value) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          sortIndex = index;
        })
      },
      child: Container(
        margin: EdgeInsets.only(top: 2),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        decoration: (BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                  color: sortIndex == index ? Colors.red[300] : Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            Container(
              child: sortIndex == index
                  ? FaIcon(
                      FontAwesomeIcons.check,
                      size: 15,
                      color: Colors.red[300],
                    )
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getSpecialties() {
    List<Widget> list = List();
    int i = -1;
    specialties.forEach((e) {
      i++;
      list.add(getSpecialtyWidget(i, e));
    });
    return list;
  }

  Widget getSpecialtyWidget(int index, String value) {
    return RaisedButton(
      onPressed: () => {
        setState(() {
          specialtyIndex = index;
        })
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: specialtyIndex == index ? Colors.red[300] : Colors.white,
      textColor: Colors.white,
      child: Center(
        child: Text(
          value,
          style: TextStyle(
              color: specialtyIndex == index ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getLocationFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButton<int>(
          hint: Text("Select State"),
          value: selectedState,
          onChanged: (int value) {
            setState(() {
              selectedState = value;
              currentCities = states[selectedState].cities;
              selectedCity = null;
            });
          },
          items: states.map((States state) {
            return DropdownMenuItem<int>(
              value: state.id,
              child: Row(
                children: <Widget>[
                  Text(
                    state.name,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(width: 20),
        DropdownButton<int>(
          hint: Text("Select City"),
          value: selectedCity,
          onChanged: (int value) {
            setState(() {
              selectedCity = value;
            });
          },
          items: currentCities.map((City city) {
            return DropdownMenuItem<int>(
              value: city.id,
              child: Row(
                children: <Widget>[
                  Text(
                    city.name,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<Widget> getUsersWidget() {
    return users != null
        ? users.map((userModel) => userWidget(context, userModel)).toList()
        : [];
  }
}
