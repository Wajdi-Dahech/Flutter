import 'package:chopper/chopper.dart';
part 'user_api_service.chopper.dart';

@ChopperApi(baseUrl: '/users')
abstract class UserApiService extends ChopperService {
  static UserApiService create() {
    final client = ChopperClient(
        services: [_$UserApiService()], converter: JsonConverter());
    return _$UserApiService(client);
  }

  @Get(path: '/get/{id}')
  Future<Response> getProfile(@Path('id') int id);

  @Get(path: '/discover')
  Future<Response> discoverUsers(@Query() int page, @Query() int limit);

  @Get(path: '/profile')
  Future<Response> getMyProfile();

  @Post(path: '/')
  Future<Response> registerUser(@Body() Map<String, String> body);
}
