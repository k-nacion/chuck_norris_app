import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class JokeRepository {
  ///Fetches a random Chuck Norris joke.
  ///
  /// Returns [ServerFailure] if connection in the internet failed.
  ///
  /// Returns [CacheFailure] if unsuccessful on caching or retrieving cached data.
  ///
  /// Returns [Joke] if successful.
  Future<Either<Failure, Joke>> getRandomJoke();
}
