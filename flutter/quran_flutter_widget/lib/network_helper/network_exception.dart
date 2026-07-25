import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;

  NetworkInfoImpl(this.internetConnectionChecker);

  @override
  Future<bool> get isConnected async =>
      await internetConnectionChecker.hasConnection;
}

class NetworkConnectionException implements Exception {}

class NetworkConnectionExceptionOnTocken implements Exception {}

isNetwordConnected() async {
  var networkInfo = NetworkInfoImpl(InternetConnectionChecker());
  if (await networkInfo.isConnected) {
    return true;
  } else {
    throw NetworkConnectionException();
  }
}
