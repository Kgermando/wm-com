class ExceptionRoutes {
  static const notFound = "/not-found";
}

class SettingsRoutes {
  static const helps = "/helps";
  static const settings = "/settings";
  static const splash = "/splash";
  static const pageVerrouillage = "/page-verrouillage";
  static const monnaiePage = "/monnaie-page";
}

class UpdateRoutes {
  static const updatePage = "/update-page";
  static const updateAdd = "/update-add";
  static const updateDetail = "/update-detail";
}

class HomeRoutes {
  static const home = "/home";
  static const subHome = "/sub-home";
}

class UserRoutes {
  static const login = "/";
  static const logout = "/login";
  static const profil = "/profil";
  static const forgotPassword = "/forgot-password";
  static const changePassword = "/change-password";
}

class RhRoutes {
  static const rhDashboard = "/rh-dashboard";
  static const rhPersonnelsPage = "/rh-personnels-page";
  static const rhPersonnelsAdd = "/rh-personnelss-add";
  static const rhPersonnelsDetail = "/rh-personnelss-detail";
  static const rhPersonnelsUpdate = "/rh-personnelss-update";
  static const rhdetailUser = "/rh-detail-user";
  static const rhUserActif = "/rh-users-actif";
}

class FinanceRoutes {
  static const transactionsCaisseDashbaord = "/transactions-caisse-dashboard";
  static const transactionsCaisseDetail = "/transactions-caisse-detail";
  static const transactionsCaisseEncaissement =
      "/transactions-caisse-encaissement";
  static const transactionsCaisseDecaissement =
      "/transactions-caisse-decaissement";
}

class MarketingRoutes {
  static const marketingAnnuaire = "/marketing-annuaire";
  static const marketingAnnuaireAdd = "/marketing-annuaire-add";
  static const marketingAnnuaireDetail = "/marketing-annuaire-detail";
  static const marketingAnnuaireEdit = "/marketing-annuaire-edit";
  static const marketingAgenda = "/marketing-agenda";
  static const marketingAgendaAdd = "/marketing-agenda-add";
  static const marketingAgendaDetail = "/marketing-agenda-detail";
  static const marketingAgendaUpdate = "/marketing-agenda-update";
}

class ComRoutes {
  // Commercial
  static const comDashboard = "/com-dashboard";
  static const comProduitModel = "/com-produit-model";
  static const comProduitModelDetail = "/com-produit-model-detail";
  static const comProduitModelAdd = "/com-produit-model-add";
  static const comProduitModelUpdate = "/com-produit-model-update";
  static const comStockGlobal = "/com-stock-global";
  static const comStockGlobalDetail = "/com-stock-global-detail";
  static const comStockGlobalAdd = "/com-stock-global-add";
  static const comStockGlobalRavitaillement =
      "/com-stock-global-ravitaillement";
  static const comStockGlobalLivraisonStock =
      "/com-stock-global-livraisonStock";
  static const comSuccursale = "/com-succursale";
  static const comSuccursaleDetail = "/com-succursale-detail";
  static const comSuccursaleAdd = "/com-succursale-add";
  static const comSuccursaleUpdate = "/com-succursale-update";
  static const comAchat = "/com-achat";
  static const comAchatAdd = "/com-achat-add";
  static const comAchatDetail = "/com-achat-detail";
  static const comAchatUpdate = "/com-achat-update";
  static const comBonLivraison = "/com-bon-livraison";
  static const comBonLivraisonDetail = "/com-bon-livraison-detail";
  static const comCart = "/com-cart";
  static const comCartDetail = "/com-cart-detail";
  static const comCreance = "/com-creance";
  static const comCreanceDetail = "/com-creance-detail";
  static const comFacture = "/com-facture";
  static const comFactureDetail = "/com-facture-detail";
  static const comGain = "/com-gain";
  static const comHistoryRavitaillement = "/com-history-ravitaillement";
  static const comHistoryLivraison = "/com-history-livraison";
  static const comRestitutionStock = "/com-restitution-stock";
  static const comRestitution = "/com-restitution";
  static const comRestitutionDetail = "/com-restitution-detail";
  static const comVente = "/com-vente";
  static const comVenteEffectue = "/com-vente-effectue";
  static const comVenteEffectueDetail = "/com-vente-effectue-detail";
 
}

class ReservationRoutes {
  static const dashboardReservation = "/dashboard-reservation";
  static const reservation = "/reservation";
  static const reservationAdd = "/reservation-add";
  static const reservationCalendarDetail = "/reservation-detail-calendar";
  static const reservationDetail = "/reservation-detail";
  static const reservationUpdate = "/reservation-update";
}

class RestaurantRoutes {
  static const dashboardRestaurant = "/dashboard-restaurant";
  static const venteRestaurant = "/vente-restaurant";
  static const tableCommandeRestaurant = "/table-commande-restaurant";
  static const tableCommandeRestaurantDetail = "/table-commande-restaurant-detail";
  static const tableConsommationRestaurant = "/table-consommation-restaurant";
  static const tableConsommationRestaurantDetail = "/table-consommation-restaurant-detail";
  static const prodModelRestaurant = "/prod-model-restaurant";
  static const prodModelRestaurantAdd = "/prod-model-restaurant-add";
  static const prodModelRestaurantDetail = "/prod-model-restaurant-detail";
  static const prodModelRestaurantUpdate = "/prod-model-restaurant-update";
  static const factureRestaurant = "/facture-restaurant";
  static const factureRestaurantDetail = "/facture-restaurant-detail";
  static const creanceRestaurantDetail = "/creance-restaurant-detail";
  static const ventEffectueRestaurant = "/vente-effectue-restaurant";
  static const ventEffectueRestaurantDetail = "/vente-effectue-restaurant-detail";
}

class VipRoutes {
  static const dashboardVip = "/dashboard-vip";
  static const venteVip = "/vente-vip";
  static const tableCommandeVip = "/table-commande-vip";
  static const tableCommandeVipDetail =
      "/table-commande-vip-detail";
  static const tableConsommationVip = "/table-consommation-vip";
  static const tableConsommationVipDetail =
      "/table-consommation-vip-detail";
  static const prodModelVip = "/prod-model-vip";
  static const prodModelVipAdd = "/prod-model-vip-add";
  static const prodModelVipDetail = "/prod-model-vip-detail";
  static const prodModelVipUpdate = "/prod-model-vip-update";
  static const factureVip = "/facture-vip";
  static const factureVipDetail = "/facture-vip-detail";
  static const creanceVipDetail = "/creance-vip-detail";
  static const ventEffectueVip = "/vente-effectue-vip";
  static const ventEffectueVipDetail =
      "/vente-effectue-vip-detail";
}

class TerrasseRoutes {
  static const dashboardTerrasse = "/dashboard-terrasse";
  static const venteTerrasse = "/vente-terrasse";
  static const tableCommandeTerrasse = "/table-commande-terrasse";
  static const tableCommandeTerrasseDetail = "/table-commande-terrasse-detail";
  static const tableConsommationTerrasse = "/table-consommation-terrasse";
  static const tableConsommationTerrasseDetail = "/table-consommation-terrasse-detail";
  static const prodModelTerrasse = "/prod-model-terrasse";
  static const prodModelTerrasseAdd = "/prod-model-terrasse-add";
  static const prodModelTerrasseDetail = "/prod-model-terrasse-detail";
  static const prodModelTerrasseUpdate = "/prod-model-terrasse-update";
  static const factureTerrasse = "/facture-terrasse";
  static const factureTerrasseDetail = "/facture-terrasse-detail";
  static const creanceTerrasseDetail = "/creance-terrasse-detail";
  static const ventEffectueTerrasse = "/vente-effectue-terrasse";
  static const ventEffectueTerrasseDetail = "/vente-effectue-terrasse-detail";
}

class LivraisonRoutes {
  static const dashboardLivraison = "/dashboard-livraison";
  static const venteLivraison = "/vente-livraison";
  static const tableCommandeLivraison = "/table-commande-livraison";
  static const tableCommandeLivraisonDetail = "/table-commande-livraison-detail";
  static const tableConsommationLivraison = "/table-consommation-livraison";
  static const tableConsommationLivraisonDetail =
      "/table-consommation-livraison-detail";
  static const prodModelLivraison = "/prod-model-livraison";
  static const prodModelLivraisonAdd = "/prod-model-livraison-add";
  static const prodModelLivraisonDetail = "/prod-model-livraison-detail";
  static const prodModelLivraisonUpdate = "/prod-model-livraison-update";
  static const factureLivraison = "/facture-livraison";
  static const factureLivraisonDetail = "/facture-livraison-detail";
  static const creanceLivraisonDetail = "/creance-livraison-detail";
  static const ventEffectueLivraison = "/vente-effectue-livraison";
  static const ventEffectueLivraisonDetail = "/vente-effectue-livraison-detail";
}

class ArchiveRoutes {
  static const archivesFolder = "/archives";
  static const archiveTable = "/archives-table";
  static const addArchives = "/archives-add";
  static const archivesDetail = "/archives-detail";
  static const archivesUpdate = "/archives-update";
  static const archivePdf = "/archives-pdf";
  static const archiveImage = "/archives-image";
}

class MailRoutes {
  static const mails = "/mails";
  static const mailSend = "/mail-send";
  static const addMail = "/mail-add";
  static const mailDetail = "/mail-detail";
  static const mailRepondre = "/mail-repondre";
  static const mailTransfert = "/mail-tranfert";
}
