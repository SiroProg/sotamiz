import 'package:shared_preferences/shared_preferences.dart';

enum StorageKeys {
  token('token'),
  notificationId('notificationId'),
  languageCode('languageCode');

  const StorageKeys(this.key);
  final String key;
}

late final SharedPreferences $storage;

class DBService {
  static Future<void> initialize() async {
    $storage = await SharedPreferences.getInstance();
  }

  static String get token {
    return $storage.getString(StorageKeys.token.name) ?? '';
  }

  static set token(String token) {
    $storage.setString(StorageKeys.token.name, token);
  }

  static String get languageCode {
    return $storage.getString(StorageKeys.languageCode.name) ?? 'ru';
  }

  static set languageCode(String code) {
    $storage.setString(StorageKeys.languageCode.name, code);
  }
}
