import 'package:cgpa_calculator/platform/data_source/persistence/preference_manager.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/shared/view_models/theme_view_model.dart';
import 'package:cgpa_calculator/ux/views/settings/view_models/cgpa_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDI {
  const AppDI._();

  static GetIt getIt = GetIt.instance;

  static Future<void> init(
      {required SharedPreferences sharedPreferences}) async {
    final manager = PreferenceManager(sharedPreferences);

    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerLazySingleton<PreferenceManager>(() => manager);

    getIt.registerLazySingleton<ThemeViewModel>(() => ThemeViewModel());
    getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
    getIt.registerLazySingleton<CGPAViewModel>(() => CGPAViewModel());
  }
}
