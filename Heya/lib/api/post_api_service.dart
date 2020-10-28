import 'package:chopper/chopper.dart';
import 'package:flutterapp/models/comment.dart';
part 'post_api_service.chopper.dart';

@ChopperApi()
abstract class PostApiService extends ChopperService {
  static PostApiService create() {
    final client = ChopperClient(
        services: [_$PostApiService()], converter: JsonConverter());
    return _$PostApiService(client);
  }

  @Post(path: 'posts/register')
  Future<Response> createPost(@Body() Map<String, dynamic> body);

  @Get(path: 'posts')
  Future<Response> getPosts();

  @Get(path: 'posts/user/{id}')
  Future<Response> getPostsByUser(
      @Path() int id, @Query() int page, @Query() int limit);

  @Get(path: 'posts/myPosts')
  Future<Response> getMyPosts();

  @Get(path: 'posts/public')
  Future<Response> getAllPosts();

  @Get(path: 'posts/followers')
  Future<Response> getFollowersPosts(@Query() int page, @Query() int limit);

  @Get(path: 'posts/like/{id}')
  Future<Response> likePost(@Path() int id);

  @Get(path: 'posts/dislike/{id}')
  Future<Response> disLikePost(@Path() int id);

  @Delete(path: 'follows/remove/{id}')
  Future<Response> unFollowUser(@Path('id') int id);

  @Get(path: 'follows/add/{id}')
  Future<Response> followUser(@Path('id') int id);

  @Get(path: 'comments/{id}')
  Future<Response> getCommentsByPost(@Path('id') int id);

  @Post(path: 'comments')
  Future<Response> addComment(@Body() Map<String, String> body);

  @Delete(path: 'comments/{id}')
  Future<Response> removeComment(@Path('id') int id);
}
