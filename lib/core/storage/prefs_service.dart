import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  PrefsService._();

  static const String _onboardingKey = 'onboarding_seen';

  static Future<void> setOnboardingSeen(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, seen);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> clearOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
  }
}