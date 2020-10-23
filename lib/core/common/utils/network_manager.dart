import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:injectable/injectable.dart';

@singleton
class NetworkManager {
  final Connectivity connectivity;

  NetworkManager(this.connectivity);

  Future<bool> isConnectAvailable() async {
    var connect = await connectivity.checkConnectivity();
    return connect == ConnectivityResult.mobile ||
        connect == ConnectivityResult.wifi;
  }

  Stream<bool> observeConnectivity() async* {
    await for (ConnectivityResult connect
        in connectivity.onConnectivityChanged) {
      switch (connect) {
        case ConnectivityResult.mobile:
          yield true;
          break;
        case ConnectivityResult.wifi:
          yield true;
          break;
        default:
          yield false;
          break;
      }
    }
  }
}
