import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  static const _usernameKey = 'username';
  static const _userEmailKey = 'userEmail';
  static const _userIdKey = 'userId';
  static const _userContactKey = 'userContact';
  static const _userCreatedAtKey = 'userCreatedAt';
  static const _userLoggedInKey = 'userLoggedIn';

  static SharedPreferences get _prefs => GetIt.instance<SharedPreferences>();

  static Future<void> setUsername(String username) async {
    await _prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    return _prefs.getString(_usernameKey);
  }

  static Future<void> setUserEmail(String email) async {
    await _prefs.setString(_userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    return _prefs.getString(_userEmailKey);
  }

  static Future<void> setUserId(String id) async {
    await _prefs.setString(_userIdKey, id);
  }

  static String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  static Future<void> setUserContact(String contact) async {
    await _prefs.setString(_userContactKey, contact);
  }

  static Future<String?> getUserContact() async {
    return _prefs.getString(_userContactKey);
  }

  static Future<void> setUserCreatedAt(DateTime createdAt) async {
    await _prefs.setString(_userCreatedAtKey, createdAt.toIso8601String());
  }

  static Future<DateTime?> getUserCreatedAt() async {
    final dateString = _prefs.getString(_userCreatedAtKey);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static Future<void> setUserLoggedIn(bool loggedIn) async {
    await _prefs.setBool(_userLoggedInKey, loggedIn);
  }

  static Future<bool> getUserLoggedIn() async {
    return _prefs.getBool(_userLoggedInKey) ?? false;
  }
}
