import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/component/comments_component.dart';
import 'package:flutterapp/component/full_photo.dart';
import 'package:flutterapp/config/slide_animations.dart';
import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/global.dart';
import 'package:flutterapp/models/media_model.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:flutterapp/pages/profile_public.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:logging/logging.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PostDetail extends StatefulWidget {
  final int index;
  final List<PostModel> posts;

  PostDetail({this.posts, this.index});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  ScrollController _controller;
  ChewieController _chewieController;
  VideoPlayerController _videoController;
  final textComment = TextEditingController();
  Color bgColor = Color.fromRGBO(0, 0, 0, 1);
  PostServiceImp postService;
  List<CommentModel> postComments;
  PostModel post;

  _PostDetailState();

  @override
  void initState() {
    super.initState();
    post = widget.posts[widget.index];
    postService = getIt<PostServiceImp>();
    _controller = ScrollController();
    if (post.type > 1) {
      _initPlayer();
    }
    _controller.addListener(() {});
    _loadComments();
  }

  void _loadComments() async {
    postComments = await postService.getCommentsByPost(post.id);
    post.comments = postComments.length;
    setState(() {});
  }

  void _initPlayer() async {
    _videoController = VideoPlayerController.network(post.medias[0].path);
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      // Try playing around with some of these other options:
      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.black,
        handleColor: Colors.black,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController != null ? _videoController.dispose() : {};
    _chewieController != null ? _chewieController.dispose() : {};
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity.compareTo(0) == -1) {
      goNextPage(widget.index + 1, true);
    } else {
      goNextPage(widget.index - 1, false);
    }
  }

  goNextPage(index, bool position) {
    if (index < 0 || index >= widget.posts.length) {
      return;
    }
    Navigator.pushReplacement(
      context,
      FadeRoute(
        page: PostDetail(posts: widget.posts, index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) =>
          _onHorizontalDrag(details),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Container(
          color: bgColor,
          child: ListView(
            controller: _controller,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
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
                              margin: EdgeInsets.only(right: 10),
                              height: 40,
                              child: CachedNetworkImage(
                                imageUrl: post.user.picture,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => AspectRatio(
                                  aspectRatio: 0.8,
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Image.asset('lib/assets/notfound.png'),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                post.user.username,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                post.createdAt != null
                                    ? formattingDate(post.createdAt)
                                    : '',
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.times,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, post);
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  post.content,
                  style: whiteText,
                ),
              ),
              Column(
                children: post.type == 1 ? getPhotos() : [getVideoPlayer()],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: FaIcon(
                      post.liked > 0
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      size: 25,
                    ),
                    color: post.liked > 0 ? Colors.red : Colors.white,
                    iconSize: 20,
                    onPressed: () {
                      liking();
                    },
                  ),
                  Text(post.likes.toString(), style: whiteText),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.comment,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      //openComments();
                    },
                  ),
                  Text(
                    post.comments.toString(),
                    style: whiteText,
                  )
                ],
              ),
              Divider(),
              Column(
                children: getComments(context, postComments, onDeleteComment),
              ),
              writeCommentWidget(),
            ],
          ),
        ),
      ),
    );
  }

  liking() {
    post.liked > 0
        ? postService.disLikePost(post.id)
        : postService.likePost(post.id);
    post.liked > 0 ? post.likes-- : post.likes++;
    post.liked = post.liked > 0 ? 0 : 1;
    if (this.mounted) {
      setState(() {});
    }
  }

  Widget writeCommentWidget() {
    return Container(
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            width: 300,
            child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: false,
                controller: textComment,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    border: new OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                    ),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    fillColor: Colors.grey[200],
                    hintText: '  Write your comment',
                    labelStyle: whiteText)),
          ),
          IconButton(
            onPressed: () {
              onAddComment();
            },
            icon: FaIcon(
              FontAwesomeIcons.arrowCircleRight,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  onAddComment() async {
    String content = textComment.text.trim();
    FocusScope.of(context).requestFocus(FocusNode());
    textComment.clear();
    await postService
        .addComment(CreateCommentModel(content: "$content", post: post.id));
    await _loadComments();
  }

  onDeleteComment(int id) async {
    postService.deleteComment(id);
    _loadComments();
    setState(() {});
  }

  Widget getPhoto(MediaModel media) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPhoto(url: media.path),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: media.path,
            placeholder: (context, url) => const AspectRatio(
              aspectRatio: 1.6,
              child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
            ),
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                Image.asset('lib/assets/notfound.png'),
          ),
        ),
      ),
    );
  }

  List<Widget> getPhotos() {
    List<Widget> medias = List();
    post.medias.forEach((element) {
      medias.add(getPhoto(element));
    });
    return medias;
  }

  getVideoPlayer() {
    if (this.mounted) {
      return Chewie(
        controller: _chewieController,
      );
    }
    return SizedBox();
  }

  onToggleVideo() {
    _videoController.value.isPlaying
        ? _videoController.pause()
        : _videoController.play();
    if (this.mounted) {
      setState(() {});
    }
  }
}
