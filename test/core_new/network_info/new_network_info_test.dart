import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/network_info/new_network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  final mockConnectivity = MockConnectivity();
  final networkInfo = NewNetworkInfoImpl(mockConnectivity);

  test(
    'isConnected should return true when result is not ConnectivityResult.none',
    () async {
      // arrange
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.wifi,
      );
      // act
      final result = await networkInfo.isConnected;
      // assert
      expect(result, equals(true));
    },
  );

  test(
    'isConnected should return false when result is ConnectivityResult.none',
    () async {
      // arrange
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.none,
      );
      // act
      final result = await networkInfo.isConnected;
      // assert
      expect(result, equals(false));
    },
  );
}
