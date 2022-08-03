import 'dart:io';

String fixture(Fixture fixture) => File('test/fixtures/${fixture.name}.json').readAsStringSync();

enum Fixture { response_api }
