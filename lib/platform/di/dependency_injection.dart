import 'package:cgpa_calculator/ux/view_models/theme_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDi {
  const AppDi._();

  static GetIt getIt = GetIt.instance;

  static Future<void> init(
      {required SharedPreferences sharedPreferences}) async {
    // Register SharedPreferences
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    getIt.registerLazySingleton<ThemeViewModel>(() => ThemeViewModel());
  }
}
