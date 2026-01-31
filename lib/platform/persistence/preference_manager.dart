import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  final SharedPreferences _preference;

  PreferenceManager(this._preference);

  SharedPreferences get sharedPreference => _preference;

  Future<void> setBoolPreference(
      {required String key, required bool value}) async {
    await _preference.setBool(key, value);
  }

  bool? getBoolPreference({required String key}) {
    return _preference.getBool(key);
  }

  Future<void> setPreference(
      {required String key, required String value}) async {
    await _preference.setString(key, value);
  }

  String? getPreference({String? key}) {
    return _preference.getString(key ?? "");
  }

  Future<List<String>> getPreferenceList({String? key}) async {
    return _preference.getStringList(key ?? "") ?? [];
  }

  void setPreferenceList(
      {required String key, required List<String> value}) async {
    await _preference.setStringList(key, value);
  }
}
