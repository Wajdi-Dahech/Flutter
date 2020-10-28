import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'comment.dart';

@JsonSerializable()
class Post {
  AssetImage image;
  String description;
  User user;
  List<User> likes;
  List<CommentModel> comments;
  DateTime date;
  bool isLiked;
  bool isSaved;

  Post(this.image, this.user, this.description, this.date, this.likes,
      this.comments, this.isLiked, this.isSaved);
}
