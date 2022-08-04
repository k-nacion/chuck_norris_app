part of 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _internetConnectionChecker;

  const NetworkInfoImpl({
    required InternetConnectionChecker internetConnectionChecker,
  }) : _internetConnectionChecker = internetConnectionChecker;

  @override
  Future<bool> isConnected() async {
    return await _internetConnectionChecker.hasConnection;
  }
}
