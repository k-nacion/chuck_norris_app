import 'dart:convert';

import 'package:chuck_norris_app/chuck_norris/data/local_data_source/joke_local_data_source.dart';
import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';
import 'package:chuck_norris_app/chuck_norris/data/remote_data_source/joke_remote_data_source.dart';
import 'package:chuck_norris_app/chuck_norris/data/repositories/joke_repository_impl.dart';
import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';
import 'package:chuck_norris_app/core/errors/exception.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:chuck_norris_app/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockJokeLocalDataSource extends Mock implements JokeLocalDataSource {}

class MockJokeRemoteDataSource extends Mock implements JokeRemoteDataSource {}

class FakeJokeModel extends Fake implements JokeModel {}

void main() {
  group('JokeRepositoryImpl class', () {
    late MockNetworkInfo mockNetworkInfo;
    late MockJokeLocalDataSource mockJokeLocalDataSource;
    late MockJokeRemoteDataSource mockJokeRemoteDataSource;
    late JokeRepositoryImpl sut;

    setUp(() {
      mockNetworkInfo = MockNetworkInfo();
      mockJokeLocalDataSource = MockJokeLocalDataSource();
      mockJokeRemoteDataSource = MockJokeRemoteDataSource();
      sut = JokeRepositoryImpl(
        localDataSource: mockJokeLocalDataSource,
        remoteDataSource: mockJokeRemoteDataSource,
        networkInfo: mockNetworkInfo,
      );
    });

    setUpAll(() => registerFallbackValue(FakeJokeModel()));

    void runOnline(void Function() body) => group('device is ONLINE', () {
          setUp(() => when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true));
          body();
        });

    void runOffline(void Function() body) => group('device is OFFLINE', () {
          setUp(() => when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => false));
          body();
        });

    final tJokeModel = JokeModel.fromMap(jsonDecode(fixture(Fixture.response_api)));
    final Either<Failure, Joke> tJoke = Right(tJokeModel);

    group('getRandomJoke()', () {
      runOnline(() {
        test(
          'should be able to check if there is an internet connection first',
          () async {
            when(() => mockJokeRemoteDataSource.getRandomJoke()).thenAnswer((_) async => tJokeModel);
            when(() => mockJokeLocalDataSource.cacheJoke(tJokeModel)).thenAnswer((_) async {});

            await sut.getRandomJoke();

            expect(await mockNetworkInfo.isConnected(), true);
            verify(() => mockNetworkInfo.isConnected());
          },
        );

        test(
          'should be able to fetch data when successfully when there is internet connection',
          () async {
            when(() => mockJokeRemoteDataSource.getRandomJoke()).thenAnswer((_) async => tJokeModel);
            when(() => mockJokeLocalDataSource.cacheJoke(tJokeModel)).thenAnswer((_) async {});

            final actual = await sut.getRandomJoke();

            expect(actual, tJoke);
            expect(await mockNetworkInfo.isConnected(), true);
            verifyNever(() => mockJokeLocalDataSource.getCachedJoke());
            verify(() => mockNetworkInfo.isConnected());
          },
        );

        test(
          'should be able to cache the data after fetching the data successfully.',
          () async {
            when(() => mockJokeRemoteDataSource.getRandomJoke()).thenAnswer((_) async => tJokeModel);
            when(() => mockJokeLocalDataSource.cacheJoke(tJokeModel)).thenAnswer((_) async {});

            final actual = await sut.getRandomJoke();

            expect(actual, tJoke);
            verify(() => mockNetworkInfo.isConnected());
            verify(() => mockJokeRemoteDataSource.getRandomJoke());
            verify(() => mockJokeLocalDataSource.cacheJoke(any()));
            verifyNever(() => mockJokeLocalDataSource.getCachedJoke());
          },
        );

        test(
          'should return a ServerFailure when there is a failure in the server',
          () async {
            when(() => mockJokeRemoteDataSource.getRandomJoke()).thenThrow(ServerException());

            final actual = await sut.getRandomJoke();

            expect(actual, const Left(ServerFailure()));
            expect(await mockNetworkInfo.isConnected(), true);
            verify(() => mockNetworkInfo.isConnected());
            verify(() => mockJokeRemoteDataSource.getRandomJoke());
            verifyZeroInteractions(mockJokeLocalDataSource);
          },
        );

        test(
          'should return a CacheFailure when unable to cache the current joke',
          () async {
            when(() => mockJokeLocalDataSource.cacheJoke(any())).thenThrow(CacheException());
            when(() => mockJokeRemoteDataSource.getRandomJoke()).thenAnswer((_) async => tJokeModel);

            final actual = await sut.getRandomJoke();

            expect(actual, const Left(CacheFailure()));
            expect(await mockNetworkInfo.isConnected(), true);
            verify(() => mockNetworkInfo.isConnected());
            verify(() => mockJokeRemoteDataSource.getRandomJoke());
            verify(() => mockJokeLocalDataSource.cacheJoke(any()));
            verifyNever(() => mockJokeLocalDataSource.getCachedJoke());
          },
        );
      });

      runOffline(() {
        test(
          'should be return the last cached joke when there is no internet connection',
          () async {
            when(() => mockJokeLocalDataSource.getCachedJoke()).thenAnswer((_) async => tJokeModel);
            when(() => mockJokeRemoteDataSource.getRandomJoke()).thenAnswer((_) async => tJokeModel);

            final actual = await sut.getRandomJoke();

            expect(actual, tJoke);
            expect(await mockNetworkInfo.isConnected(), false);
            verify(() => mockNetworkInfo.isConnected());
            verifyZeroInteractions(mockJokeRemoteDataSource);
            verifyNever(() => mockJokeRemoteDataSource.getRandomJoke());
            verifyNever(() => mockJokeLocalDataSource.cacheJoke(any()));
          },
        );

        test(
          'should return the a CacheFailure when fetching the last cache data has error in process',
          () async {
            when(() => mockJokeLocalDataSource.getCachedJoke()).thenThrow(CacheException());

            final actual = await sut.getRandomJoke();

            expect(actual, const Left(CacheFailure()));
            expect(await mockNetworkInfo.isConnected(), false);
            verify(() => mockNetworkInfo.isConnected());
            verify(() => mockJokeLocalDataSource.getCachedJoke());
            verifyZeroInteractions(mockJokeRemoteDataSource);
            verifyNever(() => mockJokeLocalDataSource.getCachedJoke());
          },
        );
      });
    });
  });
}
