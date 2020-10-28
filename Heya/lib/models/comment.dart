import 'package:flutterapp/models/basic_model.dart';

import 'user.dart';

class CommentModel extends BasicModel {
  String content;
  UserModel user;
  bool isLiked;
  DateTime createdAt;
  DateTime updatedAt;
  String type;

  CommentModel(
      {this.user,
      this.content,
      this.isLiked,
      this.createdAt,
      this.updatedAt,
      int id,
      this.type})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static CommentModel fromJSON(dynamic raw) {
    return CommentModel(
        id: raw["id"],
        user: raw["user"] != null ? UserModel.fromJSON(raw["user"]) : null,
        content: raw["content"],
        createdAt: DateTime.parse(raw["createdAt"]),
        updatedAt: DateTime.parse(raw["updatedAt"]),
        type: raw["type"],
        isLiked: false);
  }

  static List<CommentModel> listFromJSON(dynamic rawList) {
    List<CommentModel> list = List();
    for (int i = 0; i < rawList.length; i++) {
      CommentModel cm = fromJSON(rawList[i]);
      list.add(cm);
    }
    return list;
  }
}

class CreateCommentModel {
  String content;
  int post;

  CreateCommentModel({this.content, this.post});
}
