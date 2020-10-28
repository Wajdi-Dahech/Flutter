import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/component/video_thumbnail.dart';
import 'package:flutterapp/models/global.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutterapp/pages/post_detail.dart';
import 'package:flutterapp/pages/profile_public.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostWidget extends StatefulWidget {
  final Function onLikeDislike;
  final int index;
  final List<PostModel> posts;

  PostWidget({this.index, this.posts, this.onLikeDislike});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String _tempDir;
  String filePath;
  GenThumbnailImage _futreImage;
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 40;
  int _sizeH = 250;
  int _timeMs = 0;
  PostModel post;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    post = widget.posts[widget.index];
    if (post.type > 1) {
      _futreImage = GenThumbnailImage(
          thumbnailRequest: ThumbnailRequest(
              video: post.medias[0].path,
              thumbnailPath: _tempDir,
              imageFormat: _format,
              maxHeight: _sizeH,
              timeMs: _timeMs,
              quality: _quality));
    }
  }

  onLikeDislikePost() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey, blurRadius: 0.5, offset: Offset(0.0, 0.1))
        ], color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PublicProfilePage(post.user),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 40,
                          child: CachedNetworkImage(
                            imageUrl: post.user.picture,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => AspectRatio(
                              aspectRatio: 0.8,
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                Image.asset('lib/assets/notfound.png'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              post.user.username,
                              style: textStyleBold,
                            ),
                            Text(
                              post.createdAt != null
                                  ? formattingDate(post.createdAt)
                                  : '',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () async {
                      setState(() {
                        print('getting image vide');
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              //constraints: BoxConstraints.expand(height: 1),
              padding: EdgeInsets.all(10),
              child: Text(
                post.content.length < 100
                    ? post.content
                    : post.content.substring(0, 100) + '...',
              ),
            ),
            getPhoto(),
            Row(
              children: <Widget>[
                IconButton(
                  icon: FaIcon(
                    post.liked > 0
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    size: 25,
                  ),
                  color: post.liked > 0 ? Colors.red : Colors.black,
                  iconSize: 20,
                  onPressed: () {
                    widget.onLikeDislike(post);
                  },
                ),
                Text(post.likes.toString()),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.comment,
                    size: 25,
                  ),
                  onPressed: () {
                    //openComments();
                  },
                ),
                Text(post.comments.toString()),
                post.type == 1
                    ? IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.image,
                          size: 25,
                        ),
                        onPressed: () {
                          //openComments();
                        },
                      )
                    : Container(),
                post.type == 1
                    ? Text(post.medias.length.toString())
                    : Container()
              ],
            ),
            FlatButton(
              child: Text(
                "View all " + post.comments.toString() + " comments",
                style: textStyleLigthGrey,
              ),
              onPressed: () {
                //openComments();
              },
            ),
          ],
        ));
  }

  Widget getPhoto() {
    if (post.medias.length > 0) {
      return InkWell(
        onTap: () async {
          var returned = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PostDetail(
                posts: widget.posts,
                index: widget.index,
              ),
            ),
          );
          print(returned);
          if (returned != null && returned.id != null) {
            post = returned;
            setState(() {});
          }
        },
        child: Center(
          child: Stack(
            alignment: Alignment(0, 0),
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 350,
                    minWidth: MediaQuery.of(context).size.width),
                child: post.type == 1
                    ? CachedNetworkImage(
                        placeholder: (context, url) => const AspectRatio(
                          aspectRatio: 1.6,
                          child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                        ),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Image.asset('lib/assets/notfound.png'),
                        imageUrl: post.medias[0].path,
                      )
                    : (_futreImage != null) ? _futreImage : SizedBox(),
              ),
              post.type == 1
                  ? Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2,
                                  color: Color.fromRGBO(100, 100, 100, 0.3)),
                            ],
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.thList,
                            size: 15,
                            color: Colors.white,
                          )),
                    )
                  : Positioned(
                      child: Container(
                          child: FaIcon(
                        FontAwesomeIcons.play,
                        size: 30,
                        color: Colors.white,
                      )),
                    )
            ],
          ),
          // fit: BoxFit.fill,
        ),
      );
    }
    return SizedBox(height: 10);
  }
}
