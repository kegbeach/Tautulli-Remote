import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/datasources/new_geo_ip_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/models/new_geo_ip_model.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockGetGeoipLookup extends Mock
    implements tautulli_api.NewGetGeoipLookupImpl {}

void main() {
  final mockGetGeoipLookup = MockGetGeoipLookup();
  final dataSource = NewGeoIpDataSourceImpl(mockGetGeoipLookup);

  const tTautulliId = 'jkl';
  const tIpAddress = '10.0.0.1';

  final tGeoIp = NewGeoIpModel(
    city: "Toronto",
    code: "CA",
    country: "Canada",
    region: "Ontario",
  );

  void setUpSuccess() {
    when(
      () => mockGetGeoipLookup(
        tautulliId: any(named: 'tautulliId'),
        ipAddress: any(named: 'ipAddress'),
      ),
    ).thenAnswer((_) async => {
          'responseData': json.decode(fixture('new_geo_ip.json')),
          'primaryActive': true,
        });
  }

  group('getGeoIp', () {
    test(
      'should call getGeoipLookup from TautulliApi',
      () async {
        // arrange
        setUpSuccess();
        // act
        await dataSource.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        // assert
        verify(
          () => mockGetGeoipLookup(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        );
      },
    );

    test(
      'response.data should contain NewGeoIpModel',
      () async {
        // arrange
        setUpSuccess();
        //act
        final response = await dataSource.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        //assert
        expect(response.data, equals(tGeoIp));
      },
    );
  });
}
