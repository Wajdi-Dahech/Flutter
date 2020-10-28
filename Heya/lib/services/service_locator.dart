import 'package:flutterapp/services/service_firebase.dart';
import 'package:flutterapp/services/service_provider.dart';

import 'post_service_imp.dart';
import 'package:get_it/get_it.dart';
import 'package:flutterapp/services/auth_service_imp.dart';

final getIt = GetIt.instance;

void setup() {
  GetIt.I.registerLazySingleton<PostServiceImp>(() => PostServiceImp());
  GetIt.I.registerLazySingleton<AuthServiceImp>(() => AuthServiceImp());
  GetIt.I.registerLazySingleton<ServiceProvider>(() => ServiceProvider());
  GetIt.I.registerLazySingleton<FireBaseService>(() => FireBaseService());
}
