import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';
import 'package:chuck_norris_app/chuck_norris/domain/repositories/joke_repository.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:chuck_norris_app/core/use_cases/use_case.dart';
import 'package:dartz/dartz.dart';

class GetRandomJokeUseCase extends UseCase<Joke, void> {
  final JokeRepository _repository;

  const GetRandomJokeUseCase({
    required JokeRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, Joke>> call([void param]) async {
    return await _repository.getRandomJoke();
  }
}
