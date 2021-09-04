import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features_new/new_activity/data/models/new_geo_ip_mode.dart';
import 'package:tautulli_remote/features_new/new_activity/domain/entities/new_geo_ip.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

void main() {
  final tGeoIpModel = NewGeoIpModel(
    city: 'Toronto',
    code: 'CA',
    country: 'Canada',
    region: 'Ontario',
  );

  test(
    'should be a subclass of NewGeoIp entity',
    () async {
      // assert
      expect(tGeoIpModel, isA<NewGeoIp>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('new_geo_ip_item.json'));
        // act
        final result = NewGeoIpModel.fromJson(jsonMap);
        // assert
        expect(result, tGeoIpModel);
      },
    );
  });
}
