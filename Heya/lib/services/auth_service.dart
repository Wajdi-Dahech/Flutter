abstract class AuthService {
  void resetAuthService();

  Future<Map> checkLogin(String email, String password);

  Future<dynamic> getProfile(int id);

  Future<dynamic> getMyProfile();

  Future<dynamic> getDiscoverUsers(int page, int limit);

  Future<void> setLocalStorage(
      String username, String avatar, String accessToken, int id, int role);

  Future<void> clearLocalStorage();

  Future<void> registerUser(Map<String, String> body);

  Future<void> rateUser(int rate, int ownerID, String content);

  Future<void> getRateUser(int userID);
}
