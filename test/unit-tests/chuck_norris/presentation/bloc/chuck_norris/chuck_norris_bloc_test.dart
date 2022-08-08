import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';
import 'package:chuck_norris_app/chuck_norris/domain/use_cases/get_random_joke_use_case.dart';
import 'package:chuck_norris_app/chuck_norris/presentation/bloc/chuck_norris/chuck_norris_bloc.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRandomJokeUseCase extends Mock implements GetRandomJokeUseCase {}

void main() {
  group('ChuckNorrisBloc', () {
    late MockGetRandomJokeUseCase mockGetRandomJokeUseCase;
    late ChuckNorrisBloc bloc_sut;

    setUp(() {
      mockGetRandomJokeUseCase = MockGetRandomJokeUseCase();
      bloc_sut = ChuckNorrisBloc(getRandomJokeUseCase: mockGetRandomJokeUseCase);
    });

    test(
      'initial state should be the loading state ',
      () async {
        expect(bloc_sut.state, const ChuckNorrisState_Empty());
      },
    );

    group('on ChuckNorrisEvent_FetchData', () {
      const Either<Failure, Joke> tJokeSuccess = Right(Joke(id: 'id', url: 'url', value: 'value'));
      const Either<Failure, Joke> tNoJokeFailure = Left(NoJokeFailure());
      const Either<Failure, Joke> tUnableToCache = Left(UnableToCacheFailure());

      test(
        'should emit Loaded state for successful',
        () async {
          when(() => mockGetRandomJokeUseCase()).thenAnswer((_) async => tJokeSuccess);

          bloc_sut.add(ChuckNorrisEvent_FetchData());

          const expected = [
            ChuckNorrisState_Loading(),
            ChuckNorrisState_Loaded(joke: 'value'),
          ];

          expect(bloc_sut.stream.asBroadcastStream(), emitsInOrder(expected));
          await untilCalled(() => mockGetRandomJokeUseCase.call());
          verify(() => mockGetRandomJokeUseCase());
        },
      );

      test(
        'should emit [Loading -> Error] due to No Joke Exception',
        () async {
          when(() => mockGetRandomJokeUseCase.call()).thenAnswer((_) async => tNoJokeFailure);

          bloc_sut.add(ChuckNorrisEvent_FetchData());

          const expected = [ChuckNorrisState_Loading(), ChuckNorrisState_Error(message: 'No joke yet.')];

          expect(bloc_sut.stream.asBroadcastStream(), emitsInOrder(expected));
          await untilCalled(() => mockGetRandomJokeUseCase());
          verify(() => mockGetRandomJokeUseCase());
        },
      );

      test(
        'should emit [Loading -> Error] due to unable to cache the joke.',
        () async {
          when(() => mockGetRandomJokeUseCase()).thenAnswer((_) async => tUnableToCache);

          bloc_sut.add(ChuckNorrisEvent_FetchData());

          const expected = [
            ChuckNorrisState_Loading(),
            ChuckNorrisState_Error(message: 'Unable to save joke offline.')
          ];

          expect(bloc_sut.stream.asBroadcastStream(), emitsInOrder(expected));
          await untilCalled(() => mockGetRandomJokeUseCase());
          verify(() => mockGetRandomJokeUseCase());
        },
      );
    });
  });
}
