/// Backend API configuration.
class ApiConfig {
  ApiConfig._();

  /// Deployed Node.js backend on Railway.
  static const String productionBackendUrl =
      'https://yt-backend-production-07f3.up.railway.app';

  /// Override for local development:
  /// `flutter run --dart-define=BACKEND_URL=http://10.0.2.2:3000`
  static const String _envBackendUrl = String.fromEnvironment('BACKEND_URL');

  static String get backendBaseUrl =>
      _envBackendUrl.isNotEmpty ? _envBackendUrl : productionBackendUrl;
}
