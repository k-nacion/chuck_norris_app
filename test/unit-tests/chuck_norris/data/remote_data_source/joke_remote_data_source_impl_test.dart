import 'dart:convert';

import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';
import 'package:chuck_norris_app/chuck_norris/data/remote_data_source/joke_remote_data_source.dart';
import 'package:chuck_norris_app/core/errors/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class FakeUri extends Fake implements Uri {}

class MockClient extends Mock implements Client {}

void main() {
  group('JokeRemoteDataSourceImpl class', () {
    late MockClient mockClient;
    late JokeRemoteDataSourceImpl sut;

    setUp(() {
      mockClient = MockClient();
      sut = JokeRemoteDataSourceImpl(client: mockClient);
    });

    setUpAll(() => registerFallbackValue(FakeUri()));

    final tFixture = fixture(Fixture.response_api);
    final tJokeModel = JokeModel.fromMap(jsonDecode(tFixture));

    group('getRandomJoke()', () {
      test(
        'should be able to fetch data from client successfully without errors',
        () async {
          when(() => mockClient.read(Uri.https(CHUCK_NORRIS_AUTHORITY, CHUCK_NORRIS_UNENCODED_PATH)))
              .thenAnswer((_) async => tFixture);

          final actual = await sut.getRandomJoke();

          expect(actual, tJokeModel);
          verify(() => mockClient.read(Uri.https(CHUCK_NORRIS_AUTHORITY, CHUCK_NORRIS_UNENCODED_PATH)));
        },
      );

      test(
        'should throw ServerException when Client throws ClientException',
        () async {
          when(() => mockClient.read(any())).thenThrow(ClientException(''));

          void functionToTest() async => await sut.getRandomJoke();

          expect(functionToTest, throwsA(isA<ServerException>()));
          verify(() => mockClient.read(any()));
        },
      );
    });
  });
}
