import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _usernameKey = "username";
  static const String _emailKey = "email";
  static const String _phoneKey = "phone";
  static const String _addressKey = "address";
  static const String _profilePicKey = "profile_pic";

  final SharedPreferences _prefs;

  ProfileService(this._prefs);

  Future<void> saveProfile({
    required String username,
    required String email,
    required String phone,
    required String address,
    required String profilePicUrl,
  }) async {
    await _prefs.setString(_usernameKey, username);
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_phoneKey, phone);
    await _prefs.setString(_addressKey, address);
    await _prefs.setString(_profilePicKey, profilePicUrl);
  }

  Map<String, String> getProfile() {
    return {
      "username": _prefs.getString(_usernameKey) ?? "",
      "email": _prefs.getString(_emailKey) ?? "",
      "phone": _prefs.getString(_phoneKey) ?? "",
      "address": _prefs.getString(_addressKey) ?? "",
      "profilePicUrl": _prefs.getString(_profilePicKey) ?? "",
    };
  }
}
