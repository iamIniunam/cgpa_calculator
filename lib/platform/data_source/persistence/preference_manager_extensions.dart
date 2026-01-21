import 'package:cgpa_calculator/platform/data_source/persistence/preference_manager.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';

extension PreferenceManagerExtensions on PreferenceManager {
  String? get userId => getPreference(key: AppConstants.userIdKey);
  set userId(String? value) =>
      setPreference(key: AppConstants.userIdKey, value: value ?? '');
}
