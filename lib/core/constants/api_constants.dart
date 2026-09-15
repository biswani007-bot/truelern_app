/// Authoritative networking header keys and content types.
abstract final class ApiConstants {
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String applicationJson = 'application/json';

  /// Standard pagination defaults.
  static const int defaultPageLimit = 20;
}
