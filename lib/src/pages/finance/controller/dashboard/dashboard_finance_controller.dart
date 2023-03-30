import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_com/src/global/api/finance/caisse_api.dart';

class DashboardFinanceController extends GetxController {
  final CaisseApi caisseApi = Get.put(CaisseApi());

  // Caisse
  final _recetteCaisse = 0.0.obs;
  double get recetteCaisse => _recetteCaisse.value;
  final _depensesCaisse = 0.0.obs;
  double get depensesCaisse => _depensesCaisse.value;
  final _soldeCaisse = 0.0.obs;
  double get soldeCaisse => _soldeCaisse.value;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    if (!GetPlatform.isWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        var dataCaisseList = await caisseApi.getAllData();

        // Caisse
        var recetteCaisseList = dataCaisseList
            .where((element) => element.typeOperation == "Encaissement")
            .toList();
        var depensesCaisseList = dataCaisseList
            .where((element) => element.typeOperation == "Decaissement")
            .toList();

        for (var item in recetteCaisseList) {
          _recetteCaisse.value += double.parse(item.montantEncaissement);
        }
        for (var item in depensesCaisseList) {
          _depensesCaisse.value += double.parse(item.montantDecaissement);
        }

        _soldeCaisse.value = recetteCaisse - depensesCaisse;
      }
    }

    if (GetPlatform.isWeb) {
      var dataCaisseList = await caisseApi.getAllData();

      // Caisse
      var recetteCaisseList = dataCaisseList
          .where((element) => element.typeOperation == "Encaissement")
          .toList();
      var depensesCaisseList = dataCaisseList
          .where((element) => element.typeOperation == "Decaissement")
          .toList();

      for (var item in recetteCaisseList) {
        _recetteCaisse.value += double.parse(item.montantEncaissement);
      }
      for (var item in depensesCaisseList) {
        _depensesCaisse.value += double.parse(item.montantDecaissement);
      }

      _soldeCaisse.value = recetteCaisse - depensesCaisse;
    }
    update();
  }
}
