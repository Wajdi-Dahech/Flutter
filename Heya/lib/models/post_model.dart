import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/media_model.dart';
import 'package:flutterapp/models/user.dart';

class PostModel extends BasicModel {
  String content;
  int type;
  int likes;
  int comments;
  int liked;
  List<MediaModel> medias;
  UserModel user;

  PostModel(
      {this.content,
      this.type,
      this.likes,
      this.comments,
      this.liked,
      this.medias,
      int id,
      DateTime createdAt,
      DateTime updatedAt,
      this.user})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static PostModel fromJSON(dynamic raw, UserModel u) {
    return PostModel(
      comments: raw["comments"],
      id: raw["id"],
      likes: raw["likes"],
      createdAt: DateTime.parse(raw["createdAt"]),
      content: raw["content"],
      liked: raw["liked"] != null ? raw["liked"] : 0,
      medias: MediaModel.listFromJSON(raw["medias"]),
      updatedAt: DateTime.parse(raw["updatedAt"]),
      type: raw["type"],
      user: u != null
          ? u
          : raw["user"] != null ? UserModel.fromJSON(raw["user"]) : null,
    );
  }

  static List<PostModel> listFromJSON(dynamic rawList, UserModel u) {
    List<PostModel> list = List();
    for (int i = 0; i < rawList.length; i++) {
      PostModel pm = fromJSON(rawList[i], u);
      list.add(pm);
    }
    return list;
  }
}
