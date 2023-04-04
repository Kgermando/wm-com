import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/produit_model_api.dart';
import 'package:wm_com/src/global/store/commercial/produit_model_store.dart';
import 'package:wm_com/src/global/store/commercial/stock_store.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class ProduitModelController extends GetxController
    with StateMixin<List<ProductModel>> {
  final ProduitModelStore produitModelStore = ProduitModelStore();
  final ProduitModelApi produitModelApi = ProduitModelApi();
  final StockStore stockStore = StockStore();
  final ProfilController profilController = Get.find();

  var produitModelList = <ProductModel>[].obs;
  var achatList = <AchatModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController identifiantController = TextEditingController();
  TextEditingController uniteController = TextEditingController();
  TextEditingController priceController = TextEditingController();

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

  @override
  void dispose() {
    identifiantController.dispose();
    uniteController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void clear() {
    identifiantController.clear();
    uniteController.clear();
    priceController.clear();
  }

  void getList() async {
    achatList.value = await stockStore.getAllData();
    await produitModelStore.getAllData().then((response) {
      produitModelList.clear();
      produitModelList
          .addAll(response.where((element) => element.service == 'commercial'));
      produitModelList.refresh();
      change(produitModelList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await produitModelStore.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await produitModelStore.deleteData(id).then((value) {
        clear();
        produitModelList.clear();
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

  void submit() async {
    try {
      _isLoading.value = true;
      final idProductform =
          "${identifiantController.text.trim()}-${uniteController.text.trim()}";
      final dataItem = ProductModel(
          service: 'commercial',
          identifiant: (identifiantController.text == "")
              ? '-'
              : identifiantController.text.trim(),
          unite:
              (uniteController.text == "") ? '-' : uniteController.text.trim(),
          price:
              (priceController.text == "") ? '0' : priceController.text.trim(),
          idProduct: idProductform.replaceAll(' ', '').toUpperCase(),
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await produitModelStore.insertData(dataItem).then((value) {
        clear();
        produitModelList.clear();
        getList();
        Get.back();
        Get.snackbar("Soumission effectuée avec succès!",
            "Le document a bien été sauvegadé",
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

  void submitUpdate(ProductModel data) async {
    try {
      _isLoading.value = true;
      String price = (priceController.text == '0') ? '' : priceController.text;
      final idProductform =
          "${identifiantController.text.trim()}-${uniteController.text.trim()} $price";
      final dataItem = ProductModel(
          id: data.id,
          service: data.service,
          identifiant: (identifiantController.text == "")
              ? data.identifiant
              : identifiantController.text.trim(),
          unite: (uniteController.text == "")
              ? data.unite
              : uniteController.text.trim(),
          price: (priceController.text == "")
              ? data.price
              : priceController.text.trim(),
          idProduct: idProductform.replaceAll(' ', '').toUpperCase(),
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: data.business,
          sync: "update",
          async: "new");
      await produitModelStore.updateData(dataItem).then((value) {
        clear();
        produitModelList.clear();
        getList();
        Get.back();
        Get.snackbar("Soumission effectuée avec succès!",
            "Le document a bien été sauvegadé",
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

  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await produitModelApi.getAllData();
      var dataList = produitModelList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          produitModelList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = ProductModel(
              service: element.service,
              identifiant: element.identifiant,
              unite: element.unite,
              price: element.price,
              idProduct: element.idProduct,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await produitModelApi.insertData(dataItem).then((value) async {
              ProductModel dataModel = dataList
                  .where((p0) => p0.idProduct == value.idProduct)
                  .first;
              final dataItem = ProductModel(
                id: dataModel.id,
                service: dataModel.service,
                identifiant: dataModel.identifiant,
                unite: dataModel.unite,
                price: dataModel.price,
                idProduct: dataModel.idProduct,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              ); 
              await produitModelStore.updateData(dataItem).then((value) {
                produitModelList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up produitModelList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (produitModelList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = ProductModel(
              service: element.service,
              identifiant: element.identifiant,
              unite: element.unite,
              price: element.price,
              idProduct: element.idProduct,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await produitModelStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download produitModelList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.idProduct == element.idProduct) {
                  final dataItem = ProductModel(
                    id: e.id,
                    service: element.service,
                    identifiant: element.identifiant,
                    unite: element.unite,
                    price: element.price,
                    idProduct: element.idProduct,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  ); 
                  await produitModelApi
                      .updateData(dataItem)
                      .then((value) async {
                    ProductModel dataModel = dataUpdateList
                        .where((p0) => p0.idProduct == value.idProduct)
                        .first;
                    final dataItem = ProductModel(
                      id: dataModel.id,
                      service: dataModel.service,
                      identifiant: dataModel.identifiant,
                      unite: dataModel.unite,
                      price: dataModel.price,
                      idProduct: dataModel.idProduct,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await produitModelStore.updateData(dataItem).then((value) {
                      produitModelList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up produitModelList ok');
                      }
                    });
                  });
                }
              }
            }
          }).toList();
        }

        _isLoading.value = false;
      }
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de la synchronisation", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
