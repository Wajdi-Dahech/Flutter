import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/component/post_widget.dart';
import 'package:flutterapp/component/shared_components.dart';
import 'package:flutterapp/component/stories_component.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:flutterapp/services/post_service_imp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:flutterapp/services/service_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> posts;
  PostServiceImp postService;
  ServiceProvider serviceProvider;
  RefreshController _refreshController;
  bool postLoaded = false;
  int page = 1;
  int limit = 4;

  @override
  void initState() {
    super.initState();
    postService = getIt<PostServiceImp>();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    page = 1;
    posts = null;
    _refreshController.resetNoData();
    if (mounted) setState(() {});
    await loadData();
    if (mounted) setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    int nb = await loadData();
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
    if (nb == 0) {
      _refreshController.loadNoData();
    }
    if (mounted) setState(() {});
  }

  Future<int> loadData() async {
    int nb = 0;
    List<PostModel> list = await postService.getFollowersPosts(page, limit);
    if (posts == null) {
      posts = List();
    }
    posts.addAll(list);
    if (list.length > 0) {
      page++;
    }
    nb = list.length;
    return nb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage('lib/assets/heyya_logo_white.png'),
          width: 100,
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SmartRefresher(
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.redAccent,
          color: Colors.white,
        ),
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed! Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else if (mode == LoadStatus.noMore) {
              body = posts != null && posts.length > 0
                  ? Text("No more Posts")
                  : Text('');
            } else {
              body = Text("");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: ListView(children: getNewPosts(context)),
      ),
    );
  }

  List<Widget> getNewPosts(BuildContext context) {
    List<Widget> widgets = List();
    int index = 0;
    widgets.add(Container(
      height: 80,
      child: getStories(context),
    ));
    if (posts == null) {
      posts = List();
    }
    for (PostModel post in posts) {
      widgets.add(getNewPost(context, index));
      index++;
    }
    return widgets;
  }

  getMessage(String message) {
    return [
      Container(
          margin: EdgeInsets.symmetric(vertical: 50),
          child: new Center(child: Text(message)))
    ];
  }

  Widget getNewPost(BuildContext context, int index) {
    return PostWidget(
      index: index,
      posts: posts,
      onLikeDislike: liking,
    );
  }

  liking(PostModel post) {
    post.liked > 0
        ? postService.disLikePost(post.id)
        : postService.likePost(post.id);
    post.liked > 0 ? post.likes-- : post.likes++;
    post.liked = post.liked > 0 ? 0 : 1;
    setState(() {});
  }
}
