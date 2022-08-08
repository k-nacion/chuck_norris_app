import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';
import 'package:chuck_norris_app/chuck_norris/domain/repositories/joke_repository.dart';
import 'package:chuck_norris_app/chuck_norris/domain/use_cases/get_random_joke_use_case.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockJokeRepository extends Mock implements JokeRepository {}

void main() {
  group('GetRandomJokeUseCase', () {
    late MockJokeRepository mockJokeRepository;
    late GetRandomJokeUseCase useCaseSUT;

    setUp(() {
      mockJokeRepository = MockJokeRepository();
      useCaseSUT = GetRandomJokeUseCase(repository: mockJokeRepository);
    });

    group('call()', () {
      const Either<Failure, Joke> tSuccess = Right(Joke(id: 'test', url: 'test', value: 'test'));
      const Either<Failure, Joke> tServerFailed = Left(ServerFailure());
      const Either<Failure, Joke> tNoJokeFailed = Left(NoJokeFailure());
      const Either<Failure, Joke> tUnableToCachedFailed = Left(UnableToCacheFailure());

      test(
        'should call the repository  and only call getRandomJoke from it. ',
        () async {
          when(() => mockJokeRepository.getRandomJoke()).thenAnswer((_) async => tSuccess);

          final actual = await useCaseSUT.call();

          expect(actual, tSuccess);
          verify(() => mockJokeRepository.getRandomJoke());
        },
      );

      test(
        'should return right of either class indicating the it was a success',
        () async {
          when(() => mockJokeRepository.getRandomJoke()).thenAnswer((_) async => tSuccess);

          expect(await useCaseSUT.call(), tSuccess);
          verify(() => mockJokeRepository.getRandomJoke());
        },
      );

      test(
        'should return left side of either indicating that it failed something on the server',
        () async {
          when(() => mockJokeRepository.getRandomJoke()).thenAnswer((_) async => tServerFailed);

          final actual = await useCaseSUT.call();

          expect(actual, tServerFailed);
          verify(() => mockJokeRepository.getRandomJoke());
        },
      );

      test(
        'should return NoJokeFailure when failed fetching data',
        () async {
          when(() => mockJokeRepository.getRandomJoke()).thenAnswer((_) async => tNoJokeFailed);

          final actual = await useCaseSUT.call();

          expect(actual, tNoJokeFailed);
          verify(() => mockJokeRepository.getRandomJoke());
        },
      );

      test(
        'should return UnableToCacheFailure when storing of data locally failed',
        () async {
          when(() => mockJokeRepository.getRandomJoke()).thenAnswer((_) async => tUnableToCachedFailed);
        },
      );
    });
  });
}
