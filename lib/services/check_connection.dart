import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Check if the user has internet connection
class CheckConnection {
  static late StreamSubscription<ConnectivityResult> _subscription;
  static bool isDeviceConnected = false;

  static void startMonitoring() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
    });
  }

  static void stopMonitoring() {
    _subscription.cancel();
  }
}
