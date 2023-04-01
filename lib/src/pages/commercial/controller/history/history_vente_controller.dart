import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/vente_cart_api.dart';
import 'package:wm_com/src/global/store/commercial/vente_effectue_store.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class VenteCartController extends GetxController
    with StateMixin<List<VenteCartModel>> {
  final VenteEffectueStore venteEffectueStore = VenteEffectueStore();
  final VenteCartApi venteCartApi = VenteCartApi();
  final ProfilController profilController = Get.find();

  List<VenteCartModel> venteCartList = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  void getList() async {
    await venteEffectueStore.getAllData().then((response) {
      venteCartList.clear();
      venteCartList.addAll(response);
      change(venteCartList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await venteEffectueStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await venteEffectueStore.deleteData(id).then((value) {
        venteCartList.clear();
        getList();
        Get.back();
        Get.snackbar("Supprimé avec succès!", "Cet élément a bien été supprimé",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void syncDataDown() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await venteCartApi.getAllData();
      dataCloudList.map((e) async {
        if (!venteCartList.contains(e)) {
          if (dataCloudList.isNotEmpty) {
            final dataItem = VenteCartModel(
              idProductCart: e.idProductCart,
              quantityCart: e.quantityCart,
              priceTotalCart: e.priceTotalCart,
              unite: e.unite,
              tva: e.tva,
              remise: e.remise,
              qtyRemise: e.qtyRemise,
              succursale: e.succursale,
              signature: e.signature,
              created: e.created,
              createdAt: e.createdAt,
              business: e.business,
              sync: e.sync,
              async: 'saved',
            );
            await venteEffectueStore.insertData(dataItem).then((value) {
              getList();
              if (kDebugMode) {
                print('Sync Down venteEffectue ok');
              }
            });
          }
        }
      }).toList();
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de la synchronisation", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
    
  }
}
