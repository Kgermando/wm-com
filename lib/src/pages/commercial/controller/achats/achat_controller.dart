import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/achat_api.dart';
import 'package:wm_com/src/global/store/commercial/cart_store.dart';
import 'package:wm_com/src/global/store/commercial/stock_store.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class AchatController extends GetxController with StateMixin<List<AchatModel>> {
  final StockStore stockStore = StockStore();
  final AchatApi achatApi = AchatApi();
  final CartStore cartStore = CartStore();

  final ProfilController profilController = Get.put(ProfilController());
  final ProduitModelController produitModelController =
      Get.put(ProduitModelController());

  var achatList = <AchatModel>[].obs;
  var venteFilterQtyList = <AchatModel>[].obs;

  final Rx<List<AchatModel>> _venteList = Rx<List<AchatModel>>([]);
  List<AchatModel> get venteList => _venteList.value; // For filter

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController filterController = TextEditingController();

  String? idProduct;
  String quantityAchat = '0';
  String priceAchatUnit = '0';
  double prixVenteUnit = 0;
  double remise = 0;
  double qtyRemise = 0;
  double tva = 0;

  @override
  void onInit() {
    super.onInit();
    getList();
    onSearchText('');
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  void clear() {
    idProduct = null;
  }

  void getList() async {
    await stockStore.getAllData().then((response) async {
      achatList.clear();
      venteFilterQtyList.clear();
      achatList.addAll(response
          .where((element) =>
              element.succursale == profilController.user.succursale)
          .toList());
      venteFilterQtyList.addAll(response
          .where((element) =>
              double.parse(element.quantity) > 0 &&
              element.succursale == profilController.user.succursale)
          .toList());
      achatList.refresh();
      venteFilterQtyList.refresh();

      change(achatList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void onSearchText(String text) async {
    List<AchatModel> results = [];
    if (text.isEmpty) {
      results = venteFilterQtyList;
    } else {
      results = venteFilterQtyList
          .where((element) => element.idProduct
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    }
    _venteList.value = results;
  }

  detailView(int id) async {
    final data = await stockStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await stockStore.deleteData(id).then((value) {
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
      var uniteProd = idProduct!.split('-');
      var unite = uniteProd.last;
      var remisePourcent = (prixVenteUnit * remise) / 100;
      var remisePourcentToMontant = prixVenteUnit - remisePourcent;

      final dataItem = AchatModel(
          idProduct: idProduct.toString(),
          quantity: quantityAchat.toString(),
          quantityAchat: quantityAchat.toString(),
          priceAchatUnit: priceAchatUnit.toString(),
          prixVenteUnit: prixVenteUnit.toString(),
          unite: unite.toString(),
          tva: tva.toString(),
          remise: remisePourcentToMontant.toString(),
          qtyRemise: qtyRemise.toString(),
          qtyLivre: quantityAchat.toString(),
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await stockStore.insertData(dataItem).then((value) {
        clear();
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

  void submitUpdate(AchatModel data) async {
    try {
      _isLoading.value = true;
      var uniteProd = idProduct!.split('-');
      var unite = uniteProd.last;
      var remisePourcent = (prixVenteUnit * remise) / 100;
      var remisePourcentToMontant = prixVenteUnit - remisePourcent;

      final dataItem = AchatModel(
        id: data.id,
        idProduct: idProduct.toString(),
        quantity: quantityAchat.toString(),
        quantityAchat: quantityAchat.toString(),
        priceAchatUnit: priceAchatUnit.toString(),
        prixVenteUnit: prixVenteUnit.toString(),
        unite: unite.toString(),
        tva: tva.toString(),
        remise: remisePourcentToMontant.toString(),
        qtyRemise: qtyRemise.toString(),
        qtyLivre: quantityAchat.toString(),
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: data.created,
        business: data.business,
        sync: "update",
        async: "update",
      );
      await stockStore.updateData(dataItem).then((value) {
        clear();
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

  // void syncDataDown() async {
  //   try {
  //     _isLoading.value = true;
  //     var dataCloudList = await achatApi.getAllData();
  //     print("dataCloudList $dataCloudList");
  //     dataCloudList.map((e) async {
  //       var dataLocalList =
  //           achatList.where((p0) => p0.idProduct == e.idProduct).toList();
  //       print("dataLocalList $dataLocalList");

  //       if (!achatList.contains(e)) {
  //         if (dataCloudList.isNotEmpty) {
  //           final dataItem = AchatModel(
  //             idProduct: e.idProduct,
  //             quantity: e.quantity,
  //             quantityAchat: e.quantityAchat,
  //             priceAchatUnit: e.priceAchatUnit,
  //             prixVenteUnit: e.prixVenteUnit,
  //             unite: e.unite,
  //             tva: e.tva,
  //             remise: e.remise,
  //             qtyRemise: e.qtyRemise,
  //             qtyLivre: e.qtyLivre,
  //             succursale: e.succursale,
  //             signature: e.signature,
  //             created: e.created,
  //             business: e.business,
  //             sync: e.sync,
  //             async: 'saved',
  //           );
  //           await stockStore.insertData(dataItem).then((value) {
  //             getList();
  //             if (kDebugMode) {
  //               print('Sync Down succursale ok');
  //             }
  //           });
  //         }
  //       }
  //       if (achatList.contains(e)) {
  //         if (dataCloudList.isNotEmpty) {
  //           for (var element in achatList) {
  //             if (e.idProduct == element.idProduct) {
  //               double qty =
  //                   double.parse(element.quantity) + double.parse(e.quantity);
  //               final dataItem = AchatModel(
  //                 id: e.id,
  //                 idProduct: e.idProduct,
  //                 quantity: qty.toString(),
  //                 quantityAchat: e.quantityAchat,
  //                 priceAchatUnit: e.priceAchatUnit,
  //                 prixVenteUnit: e.prixVenteUnit,
  //                 unite: e.unite,
  //                 tva: e.tva,
  //                 remise: e.remise,
  //                 qtyRemise: e.qtyRemise,
  //                 qtyLivre: e.qtyLivre,
  //                 succursale: e.succursale,
  //                 signature: e.signature,
  //                 created: e.created,
  //                 business: e.business,
  //                 sync: e.sync,
  //                 async: 'saved',
  //               );
  //               await stockStore.updateData(dataItem).then((value) {
  //                 getList();
  //                 if (kDebugMode) {
  //                   print('Sync Down stock ok');
  //                 }
  //               });
  //             }
  //           }
  //         }
  //       }
  //     }).toList();
  //     _isLoading.value = false;
  //   } catch (e) {
  //     _isLoading.value = false;
  //     Get.snackbar("Erreur de la synchronisation", "$e",
  //         backgroundColor: Colors.red,
  //         icon: const Icon(Icons.check),
  //         snackPosition: SnackPosition.TOP);
  //   }
  // }

  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await achatApi.getAllData();
      var dataList = achatList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          achatList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = AchatModel(
              idProduct: element.idProduct,
              quantity: element.quantity,
              quantityAchat: element.quantityAchat,
              priceAchatUnit: element.priceAchatUnit,
              prixVenteUnit: element.prixVenteUnit,
              unite: element.unite,
              tva: element.tva,
              remise: element.remise,
              qtyRemise: element.qtyRemise,
              qtyLivre: element.qtyLivre,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await achatApi.insertData(dataItem).then((value) async {
              AchatModel achatModel =
                  achatList.where((p0) => p0.idProduct == value.idProduct).last;
              final dataItem = AchatModel(
                id: achatModel.id,
                idProduct: achatModel.idProduct,
                quantity: achatModel.quantity,
                quantityAchat: achatModel.quantityAchat,
                priceAchatUnit: achatModel.priceAchatUnit,
                prixVenteUnit: achatModel.prixVenteUnit,
                unite: achatModel.unite,
                tva: achatModel.tva,
                remise: achatModel.remise,
                qtyRemise: achatModel.qtyRemise,
                qtyLivre: achatModel.qtyLivre,
                succursale: achatModel.succursale,
                signature: achatModel.signature,
                created: achatModel.created,
                business: achatModel.business,
                sync: "sync",
                async: achatModel.async,
              );
              await stockStore.updateData(dataItem).then((value) {
                achatList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up stock ok');
                }
              });
            });
          }
        }
      } else {
        print('Sync up dataUpdateList $dataUpdateList');
        if (achatList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = AchatModel(
              idProduct: element.idProduct,
              quantity: element.quantity,
              quantityAchat: element.quantityAchat,
              priceAchatUnit: element.priceAchatUnit,
              prixVenteUnit: element.prixVenteUnit,
              unite: element.unite,
              tva: element.tva,
              remise: element.remise,
              qtyRemise: element.qtyRemise,
              qtyLivre: element.qtyLivre,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await stockStore.insertData(dataItem).then((value) {
              print("download stock ok");
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                print('Sync up stock ${element.sync}');
                if (e.idProduct == element.idProduct) {
                  double qtyLocalVendus =
                      double.parse(e.quantity) - double.parse(element.quantity);
                  double qtyDispCloud = double.parse(e.quantity) - qtyLocalVendus;
                  double qtyAchatCloud = double.parse(e.quantityAchat) + double.parse(element.quantityAchat);
                  // {
                  //   "id" : 73,
                  //   "idProduct": "CIMENT-CILU-SACS",
                  //   "quantity": "500",
                  //   "quantityAchat": "1400",
                  //   "priceAchatUnit": "8",
                  //   "prixVenteUnit": "10",
                  //   "unite": "SACS",
                  //   "tva": "0.0",
                  //   "remise": "10",
                  //   "qtyRemise": "0",
                  //   "qtyLivre": "700",
                  //   "succursale": "maison 1",
                  //   "signature": "admin",
                  //   "created": "2023-04-03 14:19:55.501644",
                  //   "business": "commercial",
                  //   "sync": "sync",
                  //   "async": "async"
                  // }
                  final dataItem = AchatModel(
                    id: e.id,
                    idProduct: e.idProduct,
                    quantity: qtyDispCloud.toString(),
                    quantityAchat: qtyAchatCloud.toString(),
                    priceAchatUnit: element.priceAchatUnit,
                    prixVenteUnit: element.prixVenteUnit,
                    unite: element.unite,
                    tva: element.tva,
                    remise: element.remise,
                    qtyRemise: element.qtyRemise,
                    qtyLivre: element.qtyLivre,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  print('Sync up e.id ${e.id}');
                  print('Sync up e.id ${e.idProduct}');
                  print('Sync up e.id ${qtyDispCloud}');
                  print('Sync up e.id ${qtyAchatCloud}');
                  print('Sync up e.id ${element.priceAchatUnit}');
                  print('Sync up e.id ${element.prixVenteUnit}');
                  print('Sync up e.id ${element.unite}');
                  print('Sync up e.id ${element.tva}');
                  print('Sync up e.id ${element.remise}');
                  print('Sync up e.id ${element.qtyRemise}');
                  print('Sync up e.id ${element.qtyLivre}');
                  print('Sync up e.id ${element.succursale}');
                  print('Sync up e.id ${element.signature}');
                  print('Sync up e.id ${element.created}');
                  print('Sync up e.id ${element.business}'); 
                  print('Sync up e.id ${element.async}');
                  await achatApi.updateData(dataItem).then((value) async {
                    AchatModel achatModel = achatList
                        .where((p0) => p0.idProduct == value.idProduct)
                        .last;
                    print('Sync ${achatModel.sync}');
                    final dataItem = AchatModel(
                      id: achatModel.id,
                      idProduct: achatModel.idProduct,
                      quantity: achatModel.quantity,
                      quantityAchat: achatModel.quantityAchat,
                      priceAchatUnit: achatModel.priceAchatUnit,
                      prixVenteUnit: achatModel.prixVenteUnit,
                      unite: achatModel.unite,
                      tva: achatModel.tva,
                      remise: achatModel.remise,
                      qtyRemise: achatModel.qtyRemise,
                      qtyLivre: achatModel.qtyLivre,
                      succursale: achatModel.succursale,
                      signature: achatModel.signature,
                      created: achatModel.created,
                      business: achatModel.business,
                      sync: "sync",
                      async: achatModel.async,
                    );
                    await stockStore.updateData(dataItem).then((value) {
                      achatList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up stock ok');
                      }
                    });
                  });
                }  
                // else {
                //   final dataItem = AchatModel(
                //     idProduct: element.idProduct,
                //     quantity: element.quantity,
                //     quantityAchat: element.quantityAchat,
                //     priceAchatUnit: element.priceAchatUnit,
                //     prixVenteUnit: element.prixVenteUnit,
                //     unite: element.unite,
                //     tva: element.tva,
                //     remise: element.remise,
                //     qtyRemise: element.qtyRemise,
                //     qtyLivre: element.qtyLivre,
                //     succursale: element.succursale,
                //     signature: element.signature,
                //     created: element.created,
                //     business: element.business,
                //     sync: "sync",
                //     async: element.async,
                //   );
                //   await achatApi.insertData(dataItem).then((value) async {
                //     AchatModel achatModel = achatList
                //         .where((p0) => p0.idProduct == value.idProduct)
                //         .last;
                //     final dataItem = AchatModel(
                //       id: achatModel.id,
                //       idProduct: achatModel.idProduct,
                //       quantity: achatModel.quantity,
                //       quantityAchat: achatModel.quantityAchat,
                //       priceAchatUnit: achatModel.priceAchatUnit,
                //       prixVenteUnit: achatModel.prixVenteUnit,
                //       unite: achatModel.unite,
                //       tva: achatModel.tva,
                //       remise: achatModel.remise,
                //       qtyRemise: achatModel.qtyRemise,
                //       qtyLivre: achatModel.qtyLivre,
                //       succursale: achatModel.succursale,
                //       signature: achatModel.signature,
                //       created: achatModel.created,
                //       business: achatModel.business,
                //       sync: "sync",
                //       async: achatModel.async,
                //     );
                //     await stockStore.updateData(dataItem).then((value) {
                //       achatList.clear();
                //       getList();
                //       if (kDebugMode) {
                //         print('Sync up stock ok');
                //       }
                //     });
                //   });
                // }
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
