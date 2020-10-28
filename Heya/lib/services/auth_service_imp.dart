import 'package:flutterapp/api/user_api_service.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/service_locator.dart';
import 'package:flutterapp/services/service_provider.dart';
import 'package:chopper/chopper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'package:flutterapp/config/global_variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthServiceImp extends AuthService {
  UserApiService userApiService;

  AuthServiceImp() {
    var chopper = getIt<ServiceProvider>().getChopper();
    userApiService = chopper.getService<UserApiService>();
  }

  void resetAuthService() {
    var chopper = getIt<ServiceProvider>().getChopper();
    userApiService = chopper.getService<UserApiService>();
  }

  @override
  Future<Map> checkLogin(String email, String password) async {
    var result;
    Map<String, String> body = Map();
    body.addEntries([MapEntry("email", email), MapEntry("password", password)]);
    var url = BASE_URL + '/auth/login';
    try {
      var response = await http.post(url, body: body);
      result = jsonDecode(response.body);
      print(result);
      return result;
    } catch (e, s) {
      print("Error : " + e);
      print("Stack : " + s.toString());
    }
  }

  @override
  Future<Response> getMyProfile() {
    return userApiService.getMyProfile();
  }

  @override
  Future<Response> getProfile(int id) {
    return userApiService.getProfile(id);
  }

  @override
  Future<List<UserModel>> getDiscoverUsers(int page, int limit) async {
    List<UserModel> list = List();
    try {
      var response = await this.userApiService.discoverUsers(page, limit);
      print(response.error);
      if (response.body != null) {
        var body = jsonDecode(response.body);
        list = UserModel.listFromJSON(body["items"]);
      }
    } catch (e, s) {
      print('Error $e');
      print('Stack $s');
    }
    return list;
  }

  @override
  Future<void> setLocalStorage(String username, String avatar,
      String accessToken, int id, int role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(LOGGED, true);
    prefs.setString(USERNAME, username);
    prefs.setString(AVATAR, avatar);
    prefs.setString(ACCESS_TOKEN, accessToken);
    prefs.setInt(ROLE, role);
    prefs.setInt(USERID, id);
    USER_TOKEN = accessToken;
    USER_NAME = username;
    USER_ID = id;
    AVATAR_IMG = avatar;
    USER_ROLE = role;
  }

  @override
  Future<void> getLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    USER_NAME = prefs.getString(USERNAME);
    USER_TOKEN = prefs.getString(ACCESS_TOKEN);
    USER_ID = prefs.getInt(USERID);
    AVATAR_IMG = prefs.getString(AVATAR);
    isLOGGED = prefs.getBool(LOGGED);
    USER_ROLE = prefs.getInt(ROLE);
  }

  Future<void> clearLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(ACCESS_TOKEN);
    prefs.setBool(LOGGED, false);
    prefs.remove(USERID);
    prefs.remove(USERNAME);
    USER_ID = -1;
    USER_ROLE = 2;
    USER_TOKEN = "";
    FULL_NAME = "full name";
    AVATAR_IMG = "";
    isLOGGED = false;
  }

  @override
  Future<http.Response> registerUser(Map<String, dynamic> body) async {
    try {
      var response = await http.post(
        "${BASE_URL}/users",
        headers: getHeader(),
        body: jsonEncode(body),
      );
      return response;
    } catch (e, s) {
      print('Error $e');
      print('Stack $s');
    }
    return null;
  }

  @override
  Future<void> rateUser(int rate, int ownerID, String content) async {
    Map<String, dynamic> body = Map();
    body.addEntries([
      MapEntry("rate", rate),
      MapEntry("ownerID", ownerID),
      MapEntry("content", content),
    ]);
    try {
      var response = await http.post(
        "${BASE_URL}/rating/rate",
        headers: getHeader(),
        body: jsonEncode(body),
      );
      return response;
    } catch (e, s) {
      print('Error $e');
      print('Stack $s');
    }
    return null;
  }

  @override
  Future<dynamic> getRateUser(int userID) async {
    try {
      var response = await http.get(
        "${BASE_URL}/rating/rate/${userID}",
        headers: getHeader(),
      );
      var content = jsonDecode(response.body);
      return content;
    } catch (e, s) {
      print('Error $e');
      print('Stack $s');
    }
    return 0;
  }
}

Map<String, String> getHeader() {
  return <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${USER_TOKEN}'
  };
}
