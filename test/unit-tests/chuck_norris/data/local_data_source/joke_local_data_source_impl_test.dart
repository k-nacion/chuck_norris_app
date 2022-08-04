import 'dart:convert';

import 'package:chuck_norris_app/chuck_norris/data/local_data_source/joke_local_data_source.dart';
import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';
import 'package:chuck_norris_app/core/errors/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class FakeJokeModel extends Fake implements JokeModel {}

void main() {
  group('$JokeLocalDataSourceImpl class', () {
    late MockSharedPreferences mockSharedPreferences;
    late JokeLocalDataSourceImpl sut;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      sut = JokeLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
    });

    setUpAll(() => registerFallbackValue(FakeJokeModel()));

    const tJokeModel = JokeModel(value: 'test joke', url: '', id: 'test id');
    final tSerializedJokeModel = jsonEncode(tJokeModel.toMap());

    group('cacheJoke()', () {
      test(
        'should serialized the joke then cache it successfully.',
        () async {
          when(() => mockSharedPreferences.setString(CACHE_JOKE_KEY, tSerializedJokeModel))
              .thenAnswer((_) async => true);

          await sut.cacheJoke(tJokeModel);

          verify(() => mockSharedPreferences.setString(CACHE_JOKE_KEY, tSerializedJokeModel));
        },
      );

      test(
        'should throw CacheException when SharedPreferences.setString() returns false',
        () async {
          when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => false);

          void function() async => await sut.cacheJoke(tJokeModel);

          expect(function, throwsA(isA<CacheException>()));
          verify(() => mockSharedPreferences.setString(any(), any()));
        },
      );
    });

    group('getCachedJoke()', () {
      test(
        'should be able to fetch the last cached data.',
        () async {
          when(() => mockSharedPreferences.getString(CACHE_JOKE_KEY)).thenReturn(tSerializedJokeModel);

          final actual = await sut.getCachedJoke();

          expect(actual, tJokeModel);
          expect(mockSharedPreferences.getString(CACHE_JOKE_KEY), tSerializedJokeModel);
          verify(() => mockSharedPreferences.getString(CACHE_JOKE_KEY));
        },
      );

      test(
        'should be able to throw CacheException when SharedPreference.getString returns null',
        () async {
          when(() => mockSharedPreferences.getString(CACHE_JOKE_KEY)).thenReturn(null);

          void functionToTest() async => await sut.getCachedJoke();

          expect(functionToTest, throwsA(isA<CacheException>()));
          expect(mockSharedPreferences.getString(CACHE_JOKE_KEY), isNull);
          verify(() => mockSharedPreferences.getString(CACHE_JOKE_KEY));
        },
      );
    });
  });
}
