class StringUtil {
  factory StringUtil() => _instance;
  StringUtil.internal();
  static final StringUtil _instance = StringUtil.internal();

  static String enumName(String enumToString) {
    final List<String> paths = enumToString.split('.');
    return paths[paths.length - 1];
  }
}