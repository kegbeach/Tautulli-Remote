import 'dart:io';

String fixture(String name) => File(
      'test/fixtures_new/$name',
    ).readAsStringSync();
