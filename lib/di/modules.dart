// ignore_for_file: invalid_annotation_target

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testinger/routes/routes.dart';

@module
abstract class AppModule {
  @lazySingleton
  AppRouter get appRouter => AppRouter();

  @lazySingleton
  @preResolve
  Future<SharedPreferences> get sessions => SharedPreferences.getInstance();
}
