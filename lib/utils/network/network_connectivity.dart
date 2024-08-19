import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gemini_app/screen/home/controller/home_controller.dart';
import 'package:get/get.dart';

class NetworkConnection {
  HomeController controller = Get.put(HomeController());
  Connectivity networkConnectivity = Connectivity();

  void checkConnection() async {
    List<ConnectivityResult> result =
    await networkConnectivity.checkConnectivity();
    checkStatus(result);
    networkConnectivity.onConnectivityChanged.listen((event) {
      checkStatus(event);
    });
  }

  void checkStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      controller.changeStatus(true);
    } else {
      controller.changeStatus(false);
    }
  }
}