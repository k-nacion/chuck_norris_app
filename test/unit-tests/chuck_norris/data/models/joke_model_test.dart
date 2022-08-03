import 'dart:convert';

import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  group('JokeModel', () {
    final tSerializedJoke = jsonDecode(fixture(Fixture.response_api));
    final tMapJoke = {
      'id': 'testId',
      'url': '',
      'value': 'test joke',
    };
    const tJoke = JokeModel(id: 'testId', url: '', value: 'test joke');

    group('toMap', () {
      test(
        'should return a map ',
        () async {
          final actual = tJoke.toMap();

          expect(actual, tMapJoke);
        },
      );
    });

    group('fromMap', () {
      test(
        'should return a JokeModel from a factory constructor',
        () async {
          final actual = JokeModel.fromMap(tSerializedJoke);

          expect(actual, tJoke);
        },
      );
    });
  });
}
