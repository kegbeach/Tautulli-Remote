import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/models/new_geo_ip_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/domain/repositories/new_geo_ip_repository.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/domain/usecases/new_get_geo_ip.dart';

class MockGeoIpRepository extends Mock implements NewGeoIpRepository {}

void main() {
  final mockGetGeoIpRepository = MockGeoIpRepository();
  final usecase = NewGetGeoIp(mockGetGeoIpRepository);

  const tTautulliId = 'jkl';
  const tIpAddress = '10.0.0.1';

  final tGeoIp = NewGeoIpModel(
    city: "Toronto",
    code: "CA",
    country: "Canada",
    region: "Ontario",
  );

  final ApiResponseData tApiResponseData = ApiResponseData(
    data: tGeoIp,
    primaryActive: true,
  );

  test(
    'should get GeoIp from API',
    () async {
      // arrange
      when(() => mockGetGeoIpRepository.getGeoIp(
            tautulliId: any(named: 'tautulliId'),
            ipAddress: any(named: 'ipAddress'),
          )).thenAnswer((_) async => Right(tApiResponseData));
      // act
      final response = await usecase(
        tautulliId: tTautulliId,
        ipAddress: tIpAddress,
      );
      // assert
      expect(response, Right(tApiResponseData));
      verify(() => mockGetGeoIpRepository.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ));
      verifyNoMoreInteractions(mockGetGeoIpRepository);
    },
  );
}
