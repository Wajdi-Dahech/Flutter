import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutterapp/api/post_api_service.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/post_service.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:flutterapp/services/service_provider.dart';
import 'package:http/http.dart' as http;

class PostServiceImp extends PostService {
  PostApiService postApiService;

  PostServiceImp() {
    var chopper = getIt<ServiceProvider>().getChopper();
    postApiService = chopper.getService<PostApiService>();
  }

  void resetPostService() {
    var chopper = getIt<ServiceProvider>().getChopper();
    postApiService = chopper.getService<PostApiService>();
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    List<PostModel> list = List();
    try {
      var response = await postApiService.getAllPosts();
      var body = jsonDecode(response.body);
      list = PostModel.listFromJSON(body["items"], null);
    } catch (e, s) {
      print('Error PostService.getAllPosts : \n $e');
      print('Stack PostService.getAllPosts : \n $s');
    }
    return list;
  }

  @override
  Future<List<PostModel>> getPosts() async {
    List<PostModel> list = List();
    try {
      var response = await postApiService.getPosts();
      var body = jsonDecode(response.body);
      list = PostModel.listFromJSON(body["items"], null);
    } catch (e, s) {
      print('Error PostService.getPosts : \n $e');
      print('Stack PostService.getPosts : \n $s');
    }
    return list;
  }

  @override
  Future<List<PostModel>> getPostsByUser(
      UserModel user, int page, int limit) async {
    List<PostModel> list = List();
    try {
      var response = await postApiService.getPostsByUser(user.id, page, limit);
      var body = jsonDecode(response.body);
      list = PostModel.listFromJSON(body["items"], user);
    } catch (e, s) {
      print('Error PostService.getPostsByUser : \n $e');
      print('Stack PostService.getPostsByUser : \n $s');
    }
    return list;
  }

  @override
  Future<Response> getMyposts() async {
    return postApiService.getMyPosts();
  }

  @override
  Future<List<CommentModel>> getCommentsByPost(int id) async {
    List<CommentModel> list = List();
    try {
      var response = await postApiService.getCommentsByPost(id);
      var body = jsonDecode(response.body);
      list = CommentModel.listFromJSON(body["items"]);
    } catch (e, s) {
      print("Caught PostService.getCommentsByPost : \n $e");
      print("Stack PostService.getCommentsByPost : \n $s");
    }
    return list;
  }

  @override
  Future<List<PostModel>> getFollowersPosts(int page, int limit) async {
    List<PostModel> list = List();
    try {
      var response = await postApiService.getFollowersPosts(page, limit);
      if (response != null && response.body != null) {
        var body = jsonDecode(response.body);
        if (body != null) {
          if (body is Map) list = PostModel.listFromJSON(body["items"], null);
        }
      }
    } catch (e, s) {
      print('Error PostService.getFollowersPosts : \n $e');
      print('Stack PostService.getFollowersPosts : \n $s');
    }
    return list;
  }

  @override
  Future<Response> followUser(int id) {
    print('follow');
    return postApiService.followUser(id);
  }

  @override
  Future<Response> unFollowUser(int id) {
    print('unfollow');
    return postApiService.unFollowUser(id);
  }

  @override
  Future<Response> likePost(int id) async {
    try {
      await postApiService.likePost(id);
      // var body = jsonDecode(response.body);
    } catch (e, s) {
      print('Error PostService.likePost : \n $e');
      print('Stack PostService.likePost : \n $s');
    }
  }

  @override
  Future<Response> disLikePost(int id) async {
    try {
      var response = await postApiService.disLikePost(id);
      print(response);
      //var body = jsonDecode(response.body);
    } catch (e, s) {
      print('Error PostService.likePost : \n $e');
      print('Stack PostService.likePost : \n $s');
    }
  }

  @override
  Future<Response> addComment(CreateCommentModel model) async {
    try {
      Map<String, String> body = Map();
      body.addEntries([
        MapEntry("post", model.post.toString()),
        MapEntry("content", model.content)
      ]);
      await postApiService.addComment(body);
      //var body = jsonDecode(response.body);
    } catch (e, s) {
      print('Error PostService.addComment : \n $e');
      print('Stack PostService.addComment : \n $s');
    }
  }

  @override
  Future<Response> deleteComment(int commentId) async {
    try {
      var res = await postApiService.removeComment(commentId);
      print(res);
      //var body = jsonDecode(response.body);
    } catch (e, s) {
      print('Error PostService.addComment : \n $e');
      print('Stack PostService.addComment : \n $s');
    }
  }

  @override
  Future<http.Response> registerPost(String content, List<String> medias) {
    var data = http.post(
      "${BASE_URL}/posts/register",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${USER_TOKEN}'
      },
      body: jsonEncode(<String, dynamic>{'content': content, 'medias': medias}),
    );
    return data;
  }
}
