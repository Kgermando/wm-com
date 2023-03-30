import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_com/src/controllers/network_controller.dart';
import 'package:wm_com/src/global/api/mails/mails_notify_api.dart'; 
import 'package:wm_com/src/global/store/commercial/cart_store.dart';
import 'package:wm_com/src/global/store/marketing/agenda_store.dart';
import 'package:wm_com/src/global/store/marketing/annuaire_store.dart';
import 'package:wm_com/src/models/notify/notify_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class DepartementNotifyCOntroller extends GetxController {
  Timer? timerCommercial;
  final getStorge = GetStorage();
  final ProfilController profilController = Get.put(ProfilController());
  final NetworkController networkController = Get.put(NetworkController());

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Header
  CartStore cartStore = CartStore();
  MailsNotifyApi mailsNotifyApi = MailsNotifyApi();
  AgendaStore agendaStore = AgendaStore();
  AnnuaireStore annuaireStore = AnnuaireStore();

  // Header
  final _cartItemCount = 0.obs;
  int get cartItemCount => _cartItemCount.value;

  final _mailsItemCount = 0.obs;
  int get mailsItemCount => _mailsItemCount.value;

  final _agendaItemCount = 0.obs;
  int get agendaItemCount => _agendaItemCount.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    getDataNotify();
  }

  @override
  void dispose() {
    timerCommercial!.cancel();
    super.dispose();
  }

  void getDataNotify() async {
    String? idToken = getStorge.read(InfoSystem.keyIdToken);
    if (idToken != null) {
      timerCommercial = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (kDebugMode) {
          print("notify Commercial");
        }
        getCountMail();
        getCountAgenda();
        getCountCart();
      });
    }
  }

  // Header
  void getCountCart() async {
    int count = await cartStore.getCount(profilController.user.matricule);
    _cartItemCount.value = count;
    update();
  }

  void getCountMail() async {
    if (!GetPlatform.isWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        NotifyModel notifySum =
            await mailsNotifyApi.getCount(profilController.user.matricule);
        _mailsItemCount.value = notifySum.count;
      } else {
        NotifyModel notifySum = const NotifyModel(count: 0);
         _mailsItemCount.value = notifySum.count;
      }
    }
    if (!GetPlatform.isWeb) {
      NotifyModel notifySum =
          await mailsNotifyApi.getCount(profilController.user.matricule);
      _mailsItemCount.value = notifySum.count;
    }

    update();
  }

  void getCountAgenda() async {
    int count = await agendaStore.getCount(profilController.user.matricule);
    _agendaItemCount.value = count;
    update();
  }

  void syncData() async {
    if (!GetPlatform.isWeb) {
      _isLoading.value = true;
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        print("hasConnection $result");
        String? idToken = getStorge.read(InfoSystem.keyIdToken);
        if (idToken != null) {
          print("idToken $idToken");

          _isLoading.value = false;
        }
      } else {
        print('No internet :( Reason:');
        // print(InternetConnectionChecker().lastTryResults);
      }
    }
  }
}
