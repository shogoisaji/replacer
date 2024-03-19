import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:replacer/repositories/shared_preferences/shared_preferences_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_repository.g.dart';

@Riverpod(keepAlive: true)
SharedPreferencesRepository sharedPreferencesRepository(
  SharedPreferencesRepositoryRef ref,
) {
  throw UnimplementedError();
}

class SharedPreferencesRepository {
  SharedPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> saveCurrentReservation(SharedPreferencesKey key, String value) async {
    return _prefs.setString(key.value, value);
  }

  String? fetchCurrentReservation(
    SharedPreferencesKey key,
  ) {
    return _prefs.getString(key.value);
  }

  Future<bool> remove(SharedPreferencesKey key) => _prefs.remove(key.value);
}
