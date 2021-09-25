import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautulli_remote/rewrite/core_new/local_storage/local_storage.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final localStorage = LocalStorageImpl(mockSharedPreferences);

  test(
    'getInt should call Shared Preferences getInt',
    () async {
      // act
      await localStorage.getInt('GET_INT');
      // assert
      verify(() => mockSharedPreferences.getInt('GET_INT')).called(1);
    },
  );

  test(
    'setInt should call Shared Preferences setInt',
    () async {
      // arrange
      when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await localStorage.setInt('SET_INT', 1);
      // assert
      verify(() => mockSharedPreferences.setInt('SET_INT', 1)).called(1);
    },
  );

  test(
    'getStringList should call Shared Preferences getStringList',
    () async {
      // act
      await localStorage.getStringList('GET_STRING_LIST');
      // assert
      verify(() => mockSharedPreferences.getStringList('GET_STRING_LIST'))
          .called(1);
    },
  );

  test(
    'setStringList should call Shared Preferences setStringList',
    () async {
      // arrange
      when(() => mockSharedPreferences.setStringList(any(), any())).thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await localStorage.setStringList('SET_STRING_LIST', ['1']);
      // assert
      verify(() =>
              mockSharedPreferences.setStringList('SET_STRING_LIST', ['1']))
          .called(1);
    },
  );
}
