
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/global.dart';
import 'package:flutterapp/models/user.dart';

class LikesComponent extends StatefulWidget {
  final List<User> likes;
  final Function getBack;
  LikesComponent({this.likes,this.getBack});
  @override
  _LikesComponentState createState() => _LikesComponentState(likes:this.likes,getBack: this.getBack);
}

class _LikesComponentState extends State<LikesComponent> {
  final List<User> likes;
  final Function getBack;
  _LikesComponentState({this.likes,this.getBack});

  @override
  Widget build(BuildContext context) {
    List<Widget> likers = [];
    for (User follower in likes) {
      likers.add(new Container(
          height: 45,
          padding: EdgeInsets.all(10),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(follower.username, style: textStyleBold),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: FlatButton(
                    color: user.following.contains(follower)
                        ? Colors.white
                        : Colors.blue,
                    child: Text(
                        user.following.contains(follower)
                            ? "Following"
                            : "Follow",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: user.following.contains(follower)
                                ? Colors.grey
                                : Colors.white)),
                    onPressed: () {
                      setState(() {
                        if (user.following.contains(follower)) {
                          user.following.remove(follower);
                        } else {
                          user.following.add(follower);
                        }
                      });
                    },
                  ),
                )
              ],
            ),
            onPressed: () {},
          )));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Likes", style: textStyleBold),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            getBack();
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: likers,
        ),
      ),
    );
  }
}

