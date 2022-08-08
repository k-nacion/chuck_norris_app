import 'package:chuck_norris_app/chuck_norris/data/local_data_source/joke_local_data_source.dart';
import 'package:chuck_norris_app/chuck_norris/data/remote_data_source/joke_remote_data_source.dart';
import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';
import 'package:chuck_norris_app/chuck_norris/domain/repositories/joke_repository.dart';
import 'package:chuck_norris_app/core/errors/exception.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:chuck_norris_app/core/network/network_info.dart';
import 'package:dartz/dartz.dart';

class JokeRepositoryImpl implements JokeRepository {
  final JokeLocalDataSource localDataSource;
  final JokeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const JokeRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Joke>> getRandomJoke() async {
    try {
      if (!await networkInfo.isConnected()) {
        final localData = await localDataSource.getCachedJoke();
        return Right(localData);
      }

      final remoteData = await remoteDataSource.getRandomJoke();
      localDataSource.cacheJoke(remoteData);
      return Right(remoteData);
    } on NoJokeException {
      return const Left(NoJokeFailure());
    } on ServerException {
      return const Left(ServerFailure());
    } on UnableToCacheException {
      return const Left(UnableToCacheFailure());
    }
  }
}
