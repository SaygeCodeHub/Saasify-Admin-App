import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static SharedPreferences? _preferences;

  static const _keyUserLoggedIn = 'isLoggedIn';
  static const _keyUserId = 'userId';
  static const _keyUserName = 'userName';
  static const _keyUserEmail = 'userEmail';
  static const _keyUserCreatedAt = 'userCreatedAt';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserLoggedIn(bool isLoggedIn) async =>
      await _preferences?.setBool(_keyUserLoggedIn, isLoggedIn);
  static bool? getUserLoggedIn() => _preferences?.getBool(_keyUserLoggedIn);

  static Future setUserId(String userId) async =>
      await _preferences?.setString(_keyUserId, userId);
  static String? getUserId() => _preferences?.getString(_keyUserId);

  static Future setUserName(String userName) async =>
      await _preferences?.setString(_keyUserName, userName);
  static String? getUserName() => _preferences?.getString(_keyUserName);

  static Future setUserEmail(String userEmail) async =>
      await _preferences?.setString(_keyUserEmail, userEmail);
  static String? getUserEmail() => _preferences?.getString(_keyUserEmail);

  static Future setUserCreatedAt(String createdAt) async =>
      await _preferences?.setString(_keyUserCreatedAt, createdAt);
  static String? getUserCreatedAt() =>
      _preferences?.getString(_keyUserCreatedAt);
}
