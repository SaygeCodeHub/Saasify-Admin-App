import 'package:shared_preferences/shared_preferences.dart';

class CustomerCache {
  static SharedPreferences? _preferences;

  static const _keyUserLoggedIn = 'isLoggedIn';
  static const _keyUserId = 'userId';
  static const _keyUserName = 'userName';
  static const _keyUserEmail = 'userEmail';
  static const _keyUserCreatedAt = 'userCreatedAt';
  static const _keyUserCompany = 'userCompany';
  static const _keyUserContact = 'userContact';
  static const _keyUserAddress = 'userAddress';
  static const _keyCompanyGstNo = 'userCompanyGstNo';
  static const _keyCompanyLicenseNo = 'companyLicenseNo';

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

  static Future setCompanyId(String companyId) async =>
      await _preferences?.setString(_keyUserCompany, companyId);

  static Future userContact(String userContact) async =>
      await _preferences?.setString(_keyUserContact, userContact);

  static String? getUserContact() => _preferences?.getString(_keyUserContact);

  static Future userAddress(String userAddress) async =>
      await _preferences?.setString(_keyUserAddress, userAddress);

  static String? getUserAddress() => _preferences?.getString(_keyUserAddress);

  static Future companyGstNo(String userCompanyGst) async =>
      await _preferences?.setString(_keyCompanyGstNo, userCompanyGst);

  static String? getCompanyGstNo() => _preferences?.getString(_keyCompanyGstNo);

  static String? getUserCompany() => _preferences?.getString(_keyUserCompany);

  static Future setCompanyLicenseNo(String licenseNo) async =>
      await _preferences?.setString(_keyCompanyLicenseNo, licenseNo);

  static String? getCompanyLicenseNo() =>
      _preferences?.getString(_keyCompanyLicenseNo);

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
