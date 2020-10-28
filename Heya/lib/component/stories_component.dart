import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/component/story_widget.dart';
import 'package:flutterapp/models/global.dart';
import 'package:flutterapp/models/user.dart';

Widget getStories(BuildContext context) {
  return ListView(
      scrollDirection: Axis.horizontal, children: getUserStories(context));
}

List<Widget> getUserStories(BuildContext context) {
  List<Widget> stories = [];
  for (int i = 0; i < 10; i++) {
    final User user = new User('DWajdi',
        AssetImage('lib/assets/my_profile.jpg'), [], [], [], [], true);
    stories.add(getStory(user, context));
  }
  return stories;
}

Widget getStory(User follower, BuildContext context) {
  return Container(
    margin: EdgeInsets.all(5),
    child: Column(
      children: <Widget>[
        Container(
            height: 50,
            width: 50,
            child: Stack(
              alignment: Alignment(0, 0),
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    backgroundColor:
                        follower.hasStory ? Colors.red : Colors.grey,
                  ),
                ),
                Container(
                  height: 47,
                  width: 47,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MoreStories()));
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    child: CircleAvatar(
                      backgroundImage: follower.profilePicture,
                    ),
                  ),
                ),
              ],
            )),
        Text(follower.username, style: textStyle)
      ],
    ),
  );
}
