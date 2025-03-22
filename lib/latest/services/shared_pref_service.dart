import 'dart:convert';

import 'package:demo_app/latest/models/api_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _isOnboardPassedKey = "is_onboard_passed";
  static const String _userKey = "user_details";

  final SharedPreferences _prefs;

  // Inject SharedPreferences via constructor
  SharedPrefService(this._prefs);

  // Save onboarding status
  Future<void> setOnboardPassed(bool value) async {
    await _prefs.setBool(_isOnboardPassedKey, value);
  }

  // Retrieve onboarding status
  bool getOnboardPassed() {
    return _prefs.getBool(_isOnboardPassedKey) ?? false;
  }

  Future<void> setUser(User user) async {
    String userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  // Retrieve User details
  User? getUser() {
    String? userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null; // Return null if no user is stored
  }

  // Clear User details
  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
}
