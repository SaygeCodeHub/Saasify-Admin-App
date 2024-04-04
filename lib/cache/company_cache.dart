import 'package:shared_preferences/shared_preferences.dart';

class CompanyCache {
  static const _companyIdKey = 'companyId';
  static const _userAddressKey = 'userAddress';
  static const _userContactKey = 'userContact';
  static const _companyGstNoKey = 'companyGstNo';
  static const _companyLicenseNoKey = 'companyLicenseNo';
  static const _currencyKey = 'currency';
  static const _industryKey = 'industry';
  static const _companyLogoUrlKey = 'companyLogoUrl';

  static Future<void> setCompanyId(String companyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_companyIdKey, companyId);
  }

  static Future<String?> getCompanyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_companyIdKey);
  }

  static Future<void> setUserAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userAddressKey, address);
  }

  static Future<String?> getUserAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userAddressKey);
  }

  static Future<void> setUserContact(String contactNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userContactKey, contactNumber);
  }

  static Future<String?> getUserContact() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userContactKey);
  }

  static Future<void> setCompanyGstNo(String gstNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_companyGstNoKey, gstNo);
  }

  static Future<String?> getCompanyGstNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_companyGstNoKey);
  }

  static Future<void> setCompanyLicenseNo(String licenseNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_companyLicenseNoKey, licenseNo);
  }

  static Future<String?> getCompanyLicenseNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_companyLicenseNoKey);
  }

  static Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  static Future<String?> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }

  static Future<void> setIndustry(String industry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_industryKey, industry);
  }

  static Future<String?> getIndustry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_industryKey);
  }

  static Future<void> setCompanyLogoUrl(String logoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_companyLogoUrlKey, logoUrl);
  }

  static Future<String?> getCompanyLogoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_companyLogoUrlKey);
  }
}
