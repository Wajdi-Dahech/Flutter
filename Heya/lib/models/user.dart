import 'post.dart';
import 'package:flutter/material.dart';

class User {
  String username;
  List<Post> posts;
  AssetImage profilePicture;
  List<User> followers;
  List<User> following;
  List<Post> savedPosts;
  bool hasStory;

  User(this.username, this.profilePicture, this.followers, this.following,
      this.posts, this.savedPosts, this.hasStory);
}

class UserModel {
  int id;
  String username;
  String firstname;
  String lastname;
  String picture;
  int rating;
  int followers;
  int followings;
  int role;
  String state;
  String city;
  bool isFollowed;

  UserModel(
      {this.id,
      this.username,
      this.picture,
      this.role,
      this.rating,
      this.state,
      this.city,
      this.isFollowed,
      this.firstname,
      this.followers,
      this.followings,
      this.lastname});

  static UserModel fromJSON(dynamic raw) {
    return UserModel(
      id: raw["id"],
      username: raw["username"] != null ? raw["username"] : "",
      picture: raw["avatar"],
      rating: 3,
      state: "tunis",
      city: "tunis",
      isFollowed: raw["isFollowed"] != null ? raw["isFollowed"] : false,
      firstname: raw["firstname"] != null ? raw["firstname"] : "",
      lastname: raw["lastname"] != null ? raw["lastname"] : "",
      followers: raw["followers"] != null ? raw["followers"] : 0,
      followings: raw["followings"] != null ? raw["followings"] : 0,
      role: raw["role"] != null ? raw["role"] : 2,
    );
  }

  static List<UserModel> listFromJSON(dynamic listRaw) {
    List<UserModel> list = List();
    for (int i = 0; i < listRaw.length; i++) {
      dynamic raw = listRaw[i];
      list.add(UserModel.fromJSON(raw));
    }
    return list;
  }
}
