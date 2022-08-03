import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class JokeRepository {
  Future<Either<Failure, Joke>> getRandomJoke();
}
