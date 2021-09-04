import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  int? getInt(String key);

  Future<bool> setInt(String key, int value);

  List<String>? getStringList(String key);

  Future<bool> setStringList(String key, List<String> value);
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences sharedPreferences;

  LocalStorageImpl(this.sharedPreferences);

  @override
  int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return await sharedPreferences.setInt(key, value);
  }

  @override
  List<String>? getStringList(String key) {
    return sharedPreferences.getStringList(key);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    return await sharedPreferences.setStringList(key, value);
  }
}
