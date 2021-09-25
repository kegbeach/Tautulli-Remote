import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NewNetworkInfo {
  Future<bool> get isConnected;
}

class NewNetworkInfoImpl implements NewNetworkInfo {
  final Connectivity connectivity;

  NewNetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connection = await connectivity.checkConnectivity();

    if (connection != ConnectivityResult.none) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
