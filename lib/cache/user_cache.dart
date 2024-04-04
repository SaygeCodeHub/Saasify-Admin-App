import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  static const _usernameKey = 'username';
  static const _userEmailKey = 'userEmail';
  static const _userIdKey = 'userId';
  static const _userContactKey = 'userContact';
  static const _userCreatedAtKey = 'userCreatedAt';
  static const _userLoggedInKey = 'userLoggedIn';

  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> setUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> setUserContact(String contact) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userContactKey, contact);
  }

  static Future<String?> getUserContact() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userContactKey);
  }

  static Future<void> setUserCreatedAt(DateTime createdAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userCreatedAtKey, createdAt.toIso8601String());
  }

  static Future<DateTime?> getUserCreatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_userCreatedAtKey);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static Future<void> setUserLoggedIn(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userLoggedInKey, loggedIn);
  }

  static Future<bool> getUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userLoggedInKey) ??
        false; // Assuming false as default
  }
}
