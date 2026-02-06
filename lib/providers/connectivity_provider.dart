import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool isOnline = false;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((status) {
      isOnline = status != ConnectivityResult.none;
      notifyListeners();
    });
  }
}
