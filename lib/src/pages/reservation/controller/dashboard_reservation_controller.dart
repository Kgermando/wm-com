import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_com/src/global/api/reservation/paiement_reservation_api.dart';
import 'package:wm_com/src/global/api/reservation/reservation_api.dart';
import 'package:wm_com/src/models/rh/agent_count_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class DashboardReservationController extends GetxController {
  ReservationApi reservationApi = ReservationApi();
  PaiementReservationApi paiementReservationApi = PaiementReservationApi();
  final ProfilController profilController = Get.find();

  var reservationPieChartList = <ReservationPieChartModel>[].obs;

  final _montantPayE = 0.0.obs;
  double get montantPayE => _montantPayE.value;

  final _montantNonPayE = 0.0.obs;
  double get montantNonPayE => _montantNonPayE.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void getList() async {
    if (!GetPlatform.isWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        await reservationApi.getChartPie().then((response) {
          reservationPieChartList.clear();
          reservationPieChartList.addAll(response);
        });

        await reservationApi.getAllData().then((response) {
          for (var element in response) {
            _montantPayE.value += double.parse(element.montant);
          }
        });

        await paiementReservationApi.getAllData().then((response) {
          for (var element in response) {
            _montantNonPayE.value += double.parse(element.montant);
          }
        });
      }
    }

    if (GetPlatform.isWeb) {
      await reservationApi.getChartPie().then((response) {
        reservationPieChartList.clear();
        reservationPieChartList.addAll(response);
      });

      await reservationApi.getAllData().then((response) {
        for (var element in response) {
          _montantPayE.value += double.parse(element.montant);
        }
      });

      await paiementReservationApi.getAllData().then((response) {
        for (var element in response) {
          _montantNonPayE.value += double.parse(element.montant);
        }
      });
    }
    update();
  }
}
