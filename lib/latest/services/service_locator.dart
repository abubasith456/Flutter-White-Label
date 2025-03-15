import 'package:demo_app/latest/services/shared_pref_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize SharedPreferences first
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Now register SharedPrefService AFTER SharedPreferences is ready
  sl.registerLazySingleton<SharedPrefService>(
    () => SharedPrefService(sharedPreferences),
  );
}
