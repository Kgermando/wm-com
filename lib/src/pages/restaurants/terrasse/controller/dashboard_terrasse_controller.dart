import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_com/src/global/api/terrasse/vente_effectuee_terrasse_api.dart';
import 'package:wm_com/src/global/api/terrasse/vente_terrasse_api.dart';
import 'package:wm_com/src/global/store/terrasse/terrasse_store.dart';
import 'package:wm_com/src/models/restaurant/courbe_vente_gain_restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/vente_chart_restaurant_model.dart';

class DashboardTerrasseController extends GetxController {
  final VenteTerrasseApi venteApi = VenteTerrasseApi();
  final VenteEffectueTerrasseApi venteEffectueApi = VenteEffectueTerrasseApi();
  final TerrasseStore store = TerrasseStore();

  // 10 produits le plus vendu
  var venteChartList = <VenteChartRestaurantModel>[].obs;

  var venteDayList = <CourbeVenteRestaurantModel>[].obs;

  var venteMouthList = <CourbeVenteRestaurantModel>[].obs;

  var venteYearList = <CourbeVenteRestaurantModel>[].obs;

  final _sumVente = 0.0.obs;
  double get sumVente => _sumVente.value;
  final _sumDCreance = 0.0.obs;
  double get sumDCreance => _sumDCreance.value;

  // Tables
  final _tableCommandeCount = 0.obs;
  int get tableCommandeCount => _tableCommandeCount.value;
  final _tableConsommationCount = 0.obs;
  int get tableConsommationCount => _tableConsommationCount.value;
  final _tableTotalCount = 0.obs;
  int get tableTotalCount => _tableTotalCount.value;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    if (!GetPlatform.isWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        await venteApi.getVenteChart().then((value) {
          venteChartList.value = value;
        });

        await venteApi.getAllDataVenteDay().then((value) {
          venteDayList.value = value;
        });

        await venteApi.getAllDataVenteMouth().then((value) {
          venteMouthList.value = value;
        });
        await venteApi.getAllDataVenteYear().then((value) {
          venteYearList.value = value;
        });

        await venteEffectueApi.getAllData().then((value) {
          // Ventes
          var dataPriceVente = value
              .where((element) => element.created.day == DateTime.now().day)
              .map((e) => double.parse(e.priceTotalCart))
              .toList();
          for (var data in dataPriceVente) {
            _sumVente.value += data;
          }
        });

        await store.getCountCommande().then((value) {
          _tableCommandeCount.value = value;
        });
        await store.getCountConsommation().then((value) {
          _tableConsommationCount.value = value;
        });
        await store.getCount().then((value) {
          _tableTotalCount.value = value;
        });
      }
    }

    if (GetPlatform.isWeb) {
      await venteApi.getVenteChart().then((value) {
        venteChartList.value = value;
      });

      await venteApi.getAllDataVenteDay().then((value) {
        venteDayList.value = value;
      });

      await venteApi.getAllDataVenteMouth().then((value) {
        venteMouthList.value = value;
      });
      await venteApi.getAllDataVenteYear().then((value) {
        venteYearList.value = value;
      });

      await venteEffectueApi.getAllData().then((value) {
        // Ventes
        var dataPriceVente = value
            .where((element) => element.created.day == DateTime.now().day)
            .map((e) => double.parse(e.priceTotalCart))
            .toList();
        for (var data in dataPriceVente) {
          _sumVente.value += data;
        }
      });

      await store.getCountCommande().then((value) {
        _tableCommandeCount.value = value;
      });
      await store.getCountConsommation().then((value) {
        _tableConsommationCount.value = value;
      });
      await store.getCount().then((value) {
        _tableTotalCount.value = value;
      });
    }

    // await creanceFactureApi.getAllData();
    // // Créances
    // for (var item in factureCreance) {
    //   final cartItem = jsonDecode(item.cart) as List;
    //   List<CartModel> cartItemList = [];

    //   for (var element in cartItem) {
    //     cartItemList.add(CartModel.fromJson(element));
    //   }

    //   for (var data in cartItemList) {
    //     if (double.parse(data.quantityCart) >= double.parse(data.qtyRemise)) {
    //       double total =
    //           double.parse(data.remise) * double.parse(data.quantityCart);
    //       _sumDCreance.value += total;
    //     } else {
    //       double total =
    //           double.parse(data.priceCart) * double.parse(data.quantityCart);
    //       _sumDCreance.value += total;
    //     }
    //   }
    // }
    update();
  }
}
