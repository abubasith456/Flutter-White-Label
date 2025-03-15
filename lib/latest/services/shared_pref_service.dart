import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _isOnboardPassedKey = "is_onboard_passed";
  
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
}
