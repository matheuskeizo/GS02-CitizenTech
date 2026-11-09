import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _chaveOnboarding = 'onboarding_visto';

  Future<bool> onboardingVisto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveOnboarding) ?? false;
  }

  Future<void> salvarOnboarding(bool naoMostrarNovamente) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveOnboarding, naoMostrarNovamente);
  }
}
