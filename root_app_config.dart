class RootAppConfig {
  static const ProjectEnvironment environment = ProjectEnvironment.dev;
  static const String appVersion = '0.0.1';
  static const String devHost = '';
  static const String prodHost = '';
}

enum ProjectEnvironment {
  dev,
  prod,
  test,
}