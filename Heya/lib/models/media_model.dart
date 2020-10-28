import 'package:flutterapp/models/basic_model.dart';

class MediaModel extends BasicModel {
  String name;
  String path;
  String type;

  MediaModel(
      {this.name,
      this.path,
      this.type,
      int id,
      DateTime createdAt,
      DateTime updatedAt})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static MediaModel fromJSON(dynamic raw) {
    return MediaModel(
      name: raw["name"],
      path: raw["path"],
      type: raw["type"],
      id: raw["id"],
      createdAt:
          raw["createdAt"] != null ? DateTime.parse(raw["createdAt"]) : null,
      updatedAt:
          raw["updatedAt"] != null ? DateTime.parse(raw["updatedAt"]) : null,
    );
  }

  static List<MediaModel> listFromJSON(dynamic listRaw) {
    List<MediaModel> list = List();
    for (int i = 0; i < listRaw.length; i++) {
      dynamic raw = listRaw[i];
      list.add(MediaModel.fromJSON(raw));
    }
    return list;
  }
}
