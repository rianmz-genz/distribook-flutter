class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No Internet Connection']);
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Request Timed Out']);
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error']);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized']);
}
