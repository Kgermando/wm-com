import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkController extends GetxController { 

  late StreamSubscription<InternetConnectionStatus> _listener;

  final _connectionStatus = 0.obs;
  int get connectionStatus => _connectionStatus.value;


  @override
  void onInit() {
    super.onInit();
    if (!GetPlatform.isWeb) {
      _listener = InternetConnectionChecker()
          .onStatusChange
          .listen((InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            _connectionStatus.value = 1;
            break;
          case InternetConnectionStatus.disconnected:
            _connectionStatus.value = 0;
            break;
        }
      });
    }
    
  }

  @override
  void onClose() { 
    _listener.cancel();
    super.onClose();
  }
}
