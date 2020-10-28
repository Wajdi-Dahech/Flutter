import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:chopper/chopper.dart';
import 'package:flutterapp/models/user.dart';
import 'package:http/http.dart' as http;

abstract class PostService {
  Future<List<PostModel>> getFollowersPosts(int page, int limit);

  Future<List<PostModel>> getPosts();

  Future<List<PostModel>> getAllPosts();

  Future<List<PostModel>> getPostsByUser(UserModel user, int page, int limit);

  Future<Response> unFollowUser(int id);

  Future<Response> followUser(int id);

  Future<http.Response> registerPost(String content, List<String> medias);

  Future<Response> likePost(int id);

  Future<Response> disLikePost(int id);

  Future<List<CommentModel>> getCommentsByPost(int id);

  Future<Response> addComment(CreateCommentModel model);

  Future<Response> deleteComment(int commentId);

  void resetPostService();
}
