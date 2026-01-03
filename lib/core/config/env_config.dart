// Environment configuration
class EnvConfig {
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const bool isProduction = environment == 'prod';
}
