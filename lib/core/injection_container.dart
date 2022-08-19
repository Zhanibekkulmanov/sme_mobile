import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'const/environment_config.dart';
import 'utils/dio/dio_interceptor.dart';
import 'utils/dio/dio_wrapper.dart';

var sl = GetIt.instance;

void initGetIt() async {
  Box tokensBox = Hive.box('tokens');
  // DIO RELATED STAFF
  sl.registerFactory<Dio>(
      () => Dio(BaseOptions(baseUrl: EnvironmentConfig.url)));

  sl.registerLazySingleton<DioInterceptor>(
      () => DioInterceptor(tokens: tokensBox, dio: sl()));

  sl.registerFactory<DioWrapper>(() => DioWrapper(sl(), sl()));

  // ///Auth
  // sl.registerLazySingleton<AuthDataSource>(
  //     () => AuthDataSourceImpl(dioWrapper: sl()));
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  // sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
}
