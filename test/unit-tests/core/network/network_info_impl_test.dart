import 'package:chuck_norris_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  group('NetworkInfoImpl class', () {
    late MockInternetConnectionChecker mockInternetConnectionChecker;
    late NetworkInfoImpl sut;

    setUp(() {
      mockInternetConnectionChecker = MockInternetConnectionChecker();
      sut = NetworkInfoImpl(internetConnectionChecker: mockInternetConnectionChecker);
    });

    group('should delegate the logic to InterConnectionChecker instead.', () {
      test(
        'should return true when there is internet connection',
        () async {
          when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => true);

          final actual = await sut.isConnected();

          expect(actual, isTrue);
          expect(await mockInternetConnectionChecker.hasConnection, true);
          verify(() => mockInternetConnectionChecker.hasConnection);
        },
      );

      test(
        'should return false when there is no internet connection',
        () async {
          when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => false);

          final actual = await sut.isConnected();

          expect(actual, isFalse);
          expect(await mockInternetConnectionChecker.hasConnection, false);
          verify(() => mockInternetConnectionChecker.hasConnection);
        },
      );
    });
  });
}
