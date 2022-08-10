import 'package:chuck_norris_app/chuck_norris/data/local_data_source/joke_local_data_source.dart';
import 'package:chuck_norris_app/chuck_norris/data/remote_data_source/joke_remote_data_source.dart';
import 'package:chuck_norris_app/chuck_norris/data/repositories/joke_repository_impl.dart';
import 'package:chuck_norris_app/chuck_norris/domain/repositories/joke_repository.dart';
import 'package:chuck_norris_app/chuck_norris/domain/use_cases/get_random_joke_use_case.dart';
import 'package:chuck_norris_app/chuck_norris/presentation/bloc/chuck_norris/chuck_norris_bloc.dart';
import 'package:chuck_norris_app/core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future initDependency() async {
  //bloc
  sl.registerFactory<ChuckNorrisBloc>(() => ChuckNorrisBloc(getRandomJokeUseCase: sl()));

  //usecase
  sl.registerLazySingleton<GetRandomJokeUseCase>(() => GetRandomJokeUseCase(repository: sl()));

  //repositories
  sl.registerLazySingleton<JokeRepository>(
    () => JokeRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<JokeRemoteDataSource>(() => JokeRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<JokeLocalDataSource>(() => JokeLocalDataSourceImpl(sharedPreferences: sl()));

  //boundary classes
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnectionChecker: sl()));

  //3rd party library
  sl.registerLazySingleton<Client>(() => Client());
  sl.registerLazySingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}
