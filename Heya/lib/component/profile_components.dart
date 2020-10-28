import 'package:flutter/material.dart';
import 'package:flutterapp/component/video_thumbnail.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutterapp/pages/post_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

TextStyle titleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18);
TextStyle infoStyle = TextStyle(fontSize: 18);

Widget profileInfoWidget() {
  return Container(
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Name", style: titleStyle),
                Text("Address", style: titleStyle),
                Text("Specialty", style: titleStyle),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Wajdi Dahech", style: infoStyle),
                Text("1km Route sidi toumi", style: infoStyle),
                Text("Developer", style: infoStyle),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget profileAlbum(List<PostModel> posts, ScrollController controller) {
  return CustomScrollView(
    controller: controller,
    slivers: <Widget>[
      SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150.0,
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 3.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            PostModel post = posts[index];
            return Container(
              child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PostDetail(index: index, posts: posts),
                      ),
                    );
                  },
                  child: Stack(children: <Widget>[
                    post.type == 1
                        ? CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => const AspectRatio(
                              aspectRatio: 1,
                              child: BlurHash(
                                  hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                            ),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('lib/assets/notfound.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            imageUrl: post.medias.length > 0
                                ? post.medias[0].path
                                : 'test',
                          )
                        : Container(
                            child: getThumbNail(post),
                          ),
                    Positioned(
                        bottom: 5,
                        left: 5,
                        child: Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.solidHeart,
                              size: 15,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "${post.likes}",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 5),
                          ],
                        )),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2,
                                  color: Color.fromRGBO(100, 100, 100, 0.3)),
                            ],
                          ),
                          child: post.type == 1
                              ? post.medias.length > 1
                                  ? FaIcon(
                                      FontAwesomeIcons.thList,
                                      size: 13,
                                      color: Colors.white,
                                    )
                                  : Container()
                              : FaIcon(
                                  FontAwesomeIcons.video,
                                  size: 13,
                                  color: Colors.white,
                                ),
                        )),
                  ])),
            );
          },
          childCount: posts != null ? posts.length : 0,
        ),
      )
    ],
  );
}

getThumbNail(PostModel post) {
  return Container(
    color: Colors.black87,
    child: BlurHash(hash: 'L7BpnWj]00azofayayj[00ay~qkC'),
  );
  return GenThumbnailImage(
      thumbnailRequest: ThumbnailRequest(
          video: post.medias[0].path,
          thumbnailPath: "",
          imageFormat: ImageFormat.JPEG,
          maxHeight: 250,
          timeMs: 0,
          quality: 40));
}

String getUserRole(int role) {
  switch (role) {
    case 1:
      return 'Admin';
      break;
    case 2:
      return 'Client';
      break;
    case 3:
      return 'Professional';
      break;
    default:
      return 'unknown';
  }
}
