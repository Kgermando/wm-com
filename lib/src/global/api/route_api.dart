import 'package:wm_com/src/utils/info_system.dart';

const String baseUrl = "http://54.242.170.46";
const String mainUrl = "$baseUrl/api";

// Notifications
var agendasNotifyUrl = "$mainUrl/counts/agendas";
var cartNotifyUrl = "$mainUrl/counts/carts";
var mailsNotifyUrl = "$mainUrl/counts/mails";

// AUTH
var refreshTokenUrl = Uri.parse("$mainUrl/auth/reloadToken");
var loginUrl = Uri.parse("$mainUrl/auth/login");
var logoutUrl = Uri.parse("$mainUrl/auth/logout");

var registerUrl = Uri.parse("$mainUrl/user/insert-new-user");
var userAllUrl = Uri.parse("$mainUrl/user/users/");
var userUrl = Uri.parse("$mainUrl/user/");

// RH
var listAgentsUrl = Uri.parse("$mainUrl/rh/agents/${InfoSystem().business()}/");
var addAgentsUrl = Uri.parse("$mainUrl/rh/agents/insert-new-agent");
var agentCountUrl =
    Uri.parse("$mainUrl/rh/agents/get-count/${InfoSystem().business()}/");
var agentChartPieSexeUrl =
    Uri.parse("$mainUrl/rh/agents/chart-pie-sexe/${InfoSystem().business()}/");

// var listPaiementSalaireUrl = Uri.parse("$mainUrl/rh/paiement-salaires/");
// var addPaiementSalaireUrl =
//     Uri.parse("$mainUrl/rh/paiement-salaires/insert-new-paiement");

// var listPresenceUrl = Uri.parse("$mainUrl/rh/presences/");
// var addPresenceUrl = Uri.parse("$mainUrl/rh/presences/insert-new-presence");
// var listPresencePersonnelUrl = Uri.parse("$mainUrl/rh/presence-personnels/");
// var addPresencePersonnelUrl =
//     Uri.parse("$mainUrl/rh/presence-personnels/insert-new-presence-personnel");

// var listPerformenceUrl = Uri.parse("$mainUrl/rh/performences/");
// var addPerformenceUrl =
//     Uri.parse("$mainUrl/rh/performences/insert-new-performence");
// var listPerformenceNoteUrl = Uri.parse("$mainUrl/rh/performences-note/");
// var addPerformenceNoteUrl =
//     Uri.parse("$mainUrl/rh/performences-note/insert-new-performence-note");

// var transportRestaurationUrl =
//     Uri.parse("$mainUrl/rh/transport-restaurations/");
// var addTransportRestaurationUrl = Uri.parse(
//     "$mainUrl/rh/transport-restaurations/insert-new-transport-restauration");
// var transRestAgentsUrl = Uri.parse("$mainUrl/rh/trans-rest-agents/");
// var addTransRestAgentsUrl =
//     Uri.parse("$mainUrl/rh/trans-rest-agents/insert-new-trans-rest-agent");

// Finances
// var banqueNameUrl = Uri.parse("$mainUrl/finances/transactions/banques-name/");
// var addBanqueNameUrl = Uri.parse(
//     "$mainUrl/finances/transactions/banques-name/insert-new-transaction-banque");
var caisseNameUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses-name/${InfoSystem().business()}/");
var addCaisseNameUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses-name/insert-new-transaction-caisse");
// var finExterieurNameUrl = Uri.parse("$mainUrl/finances/transactions/fin-exterieur-name/");
// var addFinExterieurNameUrl = Uri.parse(
//     "$mainUrl/finances/transactions/fin-exterieur-name/insert-new-transaction-fin-exterieur");

// var banqueUrl = Uri.parse("$mainUrl/finances/transactions/banques/${InfoSystem().business()}/");
// var addBanqueUrl = Uri.parse(
//     "$mainUrl/finances/transactions/banques/insert-new-transaction-banque");
// var banqueChartUrl =
//     Uri.parse("$mainUrl/finances/transactions/banques/chart/${InfoSystem().business()}/");

var banqueRetraitYeartUrl = Uri.parse(
    "$mainUrl/finances/transactions/banques/chart-year-retrait/${InfoSystem().business()}/");
var coupureBilletUrl =
    Uri.parse("$mainUrl/finances/coupure-billets/${InfoSystem().business()}/");
var addCoupureBilleUrl =
    Uri.parse("$mainUrl/finances/coupure-billets/insert-new-coupure-billet");

var caisseUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/${InfoSystem().business()}/");
var addCaisseUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/insert-new-transaction-caisse");
var caisseChartUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/chart/${InfoSystem().business()}/");

// COMMERCIAL
var prodModelsUrl =
    Uri.parse("$mainUrl/produit-models/${InfoSystem().business()}/");
var addProdModelsUrl =
    Uri.parse("$mainUrl/produit-models/insert-new-produit-model");

var stockGlobalUrl =
    Uri.parse("$mainUrl/stocks-global/${InfoSystem().business()}/");
var addStockGlobalUrl =
    Uri.parse("$mainUrl/stocks-global/insert-new-stocks-global");

var succursalesUrl =
    Uri.parse("$mainUrl/succursales/${InfoSystem().business()}/");
var addSuccursalesUrl = Uri.parse("$mainUrl/succursales/insert-new-succursale");

var bonLivraisonsUrl =
    Uri.parse("$mainUrl/bon-livraisons/${InfoSystem().business()}/");
var addBonLivraisonsUrl =
    Uri.parse("$mainUrl/bon-livraisons/insert-new-bon-livraison");

var achatsUrl = Uri.parse("$mainUrl/achats/${InfoSystem().business()}/");
var addAchatsUrl = Uri.parse("$mainUrl/achats/insert-new-achat");

// var cartsUrl = Uri.parse("$mainUrl/carts/");
var addCartsUrl = Uri.parse("$mainUrl/carts/insert-new-cart");

var facturesUrl = Uri.parse("$mainUrl/factures/${InfoSystem().business()}/");
var addFacturesUrl = Uri.parse("$mainUrl/factures/insert-new-facture");

var factureCreancesUrl =
    Uri.parse("$mainUrl/facture-creances/${InfoSystem().business()}/");
var addFactureCreancesUrl =
    Uri.parse("$mainUrl/facture-creances/insert-new-facture-creance");

var ventesUrl = Uri.parse("$mainUrl/ventes/${InfoSystem().business()}/");
var addVentesUrl = Uri.parse("$mainUrl/ventes/insert-new-vente");

var ardoiseUrl = Uri.parse("$mainUrl/ardoises/${InfoSystem().business()}/");
var addArdoiseUrl = Uri.parse("$mainUrl/ardoises/insert-new-ardoise");

var bonsConsommationUrl =
    Uri.parse("$mainUrl/bon-consommations/${InfoSystem().business()}/");
var addBonsConsommationUrl =
    Uri.parse("$mainUrl/bon-consommations/insert-new-bon-consommation");

// Chart Commercial
var venteChartsUrl =
    Uri.parse("$mainUrl/ventes/vente-chart/${InfoSystem().business()}");
var venteChartDayUrl =
    Uri.parse("$mainUrl/ventes/vente-chart-day/${InfoSystem().business()}");
var venteChartMonthsUrl =
    Uri.parse("$mainUrl/ventes/vente-chart-month/${InfoSystem().business()}");
var venteChartYearsUrl =
    Uri.parse("$mainUrl/ventes/vente-chart-year/${InfoSystem().business()}");
var gainChartDayUrl =
    Uri.parse("$mainUrl/gains/gain-chart-day/${InfoSystem().business()}");
var gainChartMonthsUrl =
    Uri.parse("$mainUrl/gains/gain-chart-month/${InfoSystem().business()}");
var gainChartYearsUrl =
    Uri.parse("$mainUrl/gains/gain-chart-year/${InfoSystem().business()}");

var gainsUrl = Uri.parse("$mainUrl/gains/${InfoSystem().business()}/");
var addGainsUrl = Uri.parse("$mainUrl/gains/insert-new-gain");

var restitutionsUrl =
    Uri.parse("$mainUrl/restitutions/${InfoSystem().business()}/");
var addRestitutionsUrl =
    Uri.parse("$mainUrl/restitutions/insert-new-restitution");

var numberFactsUrl =
    Uri.parse("$mainUrl/number-facts/${InfoSystem().business()}/");
var addNumberFactsUrl =
    Uri.parse("$mainUrl/number-facts/insert-new-number-fact");

var historyRavitaillementsUrl =
    Uri.parse("$mainUrl/history-ravitaillements/${InfoSystem().business()}/");
var addHistoryRavitaillementsUrl = Uri.parse(
    "$mainUrl/history-ravitaillements/insert-new-history-ravitaillement");

var historyLivraisonUrl =
    Uri.parse("$mainUrl/history-livraisons/${InfoSystem().business()}/");
var addHistoryLivraisonUrl =
    Uri.parse("$mainUrl/history-livraisons/insert-new-history_livraison");

// Restaurant
var prodModelRestUrl =
    Uri.parse("$mainUrl/prod-mode-rests/${InfoSystem().business()}/");
var addProdModelRestUrl =
    Uri.parse("$mainUrl/prod-mode-rests/insert-new-produit-model");
var venteChartRestaurantUrl = Uri.parse(
    "$mainUrl/vente-effectuee-rests/vente-chart/${InfoSystem().business()}");
var venteChartDayRestaurantUrl = Uri.parse(
    "$mainUrl/vente-effectuee-rests/vente-chart-day/${InfoSystem().business()}");
var venteChartMonthsRestaurantUrl = Uri.parse(
    "$mainUrl/vente-effectuee-rests/vente-chart-month/${InfoSystem().business()}");
var venteChartYearsRestaurantUrl = Uri.parse(
    "$mainUrl/vente-effectuee-rests/vente-chart-year/${InfoSystem().business()}");

var restaurantUrl =
    Uri.parse("$mainUrl/restaurants/${InfoSystem().business()}/");
var addrestaurantUrl = Uri.parse("$mainUrl/restaurants/insert-new-restaurant");

var creanceRestaurantUrl =
    Uri.parse("$mainUrl/creance-rests/${InfoSystem().business()}/");
var addCreanceRestaurantUrl =
    Uri.parse("$mainUrl/creance-rests/insert-new-creance");

var factureRestaurantUrl =
    Uri.parse("$mainUrl/facture-rests/${InfoSystem().business()}/");
var addFactureRestaurantUrl =
    Uri.parse("$mainUrl/facture-rests/insert-new-facture");

var tableRestaurantUrl =
    Uri.parse("$mainUrl/table-rests/${InfoSystem().business()}/");
var addTableRestaurantUrl = Uri.parse("$mainUrl/table-rests/insert-new-table");

var venteEffectueeRestaurantUrl =
    Uri.parse("$mainUrl/vente-effectuee-rests/${InfoSystem().business()}/");
var addVenteEffectueeRestaurantUrl =
    Uri.parse("$mainUrl/vente-effectuee-rests/insert-new-vente");

// Vip
var prodModelVipUrl =
    Uri.parse("$mainUrl/prod-mode-vips/${InfoSystem().business()}/");
var addProdModelVipUrl =
    Uri.parse("$mainUrl/prod-mode-vips/insert-new-produit-model");
var venteChartVipUrl = Uri.parse(
    "$mainUrl/vente-effectuee-vips/vente-chart/${InfoSystem().business()}");
var venteChartDayVipUrl = Uri.parse(
    "$mainUrl/vente-effectuee-vips/vente-chart-day/${InfoSystem().business()}");
var venteChartMonthsVipUrl = Uri.parse(
    "$mainUrl/vente-effectuee-vips/vente-chart-month/${InfoSystem().business()}");
var venteChartYearsVipUrl = Uri.parse(
    "$mainUrl/vente-effectuee-vips/vente-chart-year/${InfoSystem().business()}");

var vipUrl = Uri.parse("$mainUrl/vips/${InfoSystem().business()}/");
var addVipUrl = Uri.parse("$mainUrl/vips/insert-new-vip");

var creanceVipUrl =
    Uri.parse("$mainUrl/creance-vips/${InfoSystem().business()}/");
var addCreanceVipUrl = Uri.parse("$mainUrl/creance-vips/insert-new-creance");

var factureVipUrl =
    Uri.parse("$mainUrl/facture-vips/${InfoSystem().business()}/");
var addFactureVipUrl = Uri.parse("$mainUrl/facture-vips/insert-new-facture");

var tableVipUrl = Uri.parse("$mainUrl/table-vips/${InfoSystem().business()}/");
var addTableVipUrl = Uri.parse("$mainUrl/table-rests/insert-new-table");

var venteEffectueeVipUrl =
    Uri.parse("$mainUrl/vente-effectuee-vips/${InfoSystem().business()}/");
var addVenteEffectueeVipUrl =
    Uri.parse("$mainUrl/vente-effectuee-vips/insert-new-vente");

// Terrasse
var prodModelTerrasseUrl =
    Uri.parse("$mainUrl/prod-mode-terrasses/${InfoSystem().business()}/");
var addProdModelTerrasseUrl =
    Uri.parse("$mainUrl/prod-mode-terrasses/insert-new-produit-model");
var venteChartTerrasseUrl = Uri.parse(
    "$mainUrl/vente-effectuee-terrasses/vente-chart/${InfoSystem().business()}");
var venteChartDayTerrasseUrl = Uri.parse(
    "$mainUrl/vente-effectuee-terrasses/vente-chart-day/${InfoSystem().business()}");
var venteChartMonthsTerrasseUrl = Uri.parse(
    "$mainUrl/vente-effectuee-terrasses/vente-chart-month/${InfoSystem().business()}");
var venteChartYearsTerrasseUrl = Uri.parse(
    "$mainUrl/vente-effectuee-terrasses/vente-chart-year/${InfoSystem().business()}");

var terrasseUrl = Uri.parse("$mainUrl/terrasses/${InfoSystem().business()}/");
var addTerrasseUrl = Uri.parse("$mainUrl/terrasses/insert-new-terrasse");

var creanceTerrasseUrl =
    Uri.parse("$mainUrl/creance-terrasses/${InfoSystem().business()}/");
var addCreanceTerrasseUrl =
    Uri.parse("$mainUrl/creance-terrasses/insert-new-creance");

var factureTerrasseUrl =
    Uri.parse("$mainUrl/facture-terrasses/${InfoSystem().business()}/");
var addFactureTerrasseUrl =
    Uri.parse("$mainUrl/facture-terrasses/insert-new-facture");

var tableTerrasseUrl =
    Uri.parse("$mainUrl/table-terrasses/${InfoSystem().business()}/");
var addTableTerrasseUrl =
    Uri.parse("$mainUrl/table-terrasses/insert-new-table");

var venteEffectueeTerrasseUrl =
    Uri.parse("$mainUrl/vente-effectuee-terrasses/${InfoSystem().business()}/");
var addVenteEffectueeTerrasseUrl =
    Uri.parse("$mainUrl/vente-effectuee-terrasses/insert-new-vente");

// Livraison
var prodModelLivraisonUrl =
    Uri.parse("$mainUrl/prod-mode-livraisons/${InfoSystem().business()}/");
var addProdModelLivraisonUrl =
    Uri.parse("$mainUrl/prod-mode-livraisons/insert-new-produit-model");
var venteChartLivraisonUrl = Uri.parse(
    "$mainUrl/vente-effectuee-livraisons/vente-chart/${InfoSystem().business()}");
var venteChartDayLivraisonUrl = Uri.parse(
    "$mainUrl/vente-effectuee-livraisons/vente-chart-day/${InfoSystem().business()}");
var venteChartMonthsLivraisonUrl = Uri.parse(
    "$mainUrl/vente-effectuee-livraisons/vente-chart-month/${InfoSystem().business()}");
var venteChartYearsLivraisonUrl = Uri.parse(
    "$mainUrl/vente-effectuee-livraisons/vente-chart-year/${InfoSystem().business()}");

var livraisonUrl = Uri.parse("$mainUrl/livraisons/${InfoSystem().business()}/");
var addLivraisonUrl = Uri.parse("$mainUrl/livraisons/insert-new-livraison");

var creanceLivraisonUrl =
    Uri.parse("$mainUrl/creance-livraisons/${InfoSystem().business()}/");
var addCreanceLivraisonUrl =
    Uri.parse("$mainUrl/creance-livraisons/insert-new-creance");

var factureLivraisonUrl =
    Uri.parse("$mainUrl/facture-livraisons/${InfoSystem().business()}/");
var addFactureLivraisonUrl =
    Uri.parse("$mainUrl/facture-livraisons/insert-new-facture");

var tableLivraisonUrl =
    Uri.parse("$mainUrl/table-livraisons/${InfoSystem().business()}/");
var addTableLivraisonUrl =
    Uri.parse("$mainUrl/table-livraisons/insert-new-table");

var venteEffectueeLivraisonUrl = Uri.parse(
    "$mainUrl/vente-effectuee-livraisons/${InfoSystem().business()}/");
var addVenteEffectueeLivraisonUrl =
    Uri.parse("$mainUrl/vente-effectuee-livraisons/insert-new-vente");

// Marketing
var agendasUrl = Uri.parse("$mainUrl/agendas/${InfoSystem().business()}/");
var addAgendasUrl = Uri.parse("$mainUrl/agendas/insert-new-agenda");

var annuairesUrl = Uri.parse("$mainUrl/annuaires/${InfoSystem().business()}/");
var addAnnuairesUrl = Uri.parse("$mainUrl/annuaires/insert-new-annuaire");
var annuairesPieUrl = Uri.parse("$mainUrl/annuaires/chart/");

var campaignsUrl = Uri.parse("$mainUrl/campaigns${InfoSystem().business()}//");
var addCampaignsUrl = Uri.parse("$mainUrl/campaigns/insert-new-campaign");

// ARCHIVES
var archvesUrl = Uri.parse("$mainUrl/archives/${InfoSystem().business()}/");
var addArchvesUrl = Uri.parse("$mainUrl/archives/insert-new-archive");

var archveFoldersUrl =
    Uri.parse("$mainUrl/archives-folders/${InfoSystem().business()}/");
var addArchveFolderUrl =
    Uri.parse("$mainUrl/archives-folders/insert-new-archive-folder");

// MAILS
var mailsUrl = Uri.parse("$mainUrl/mails/${InfoSystem().business()}/");
var addMailUrl = Uri.parse("$mainUrl/mails/insert-new-mail");

// Update Software
var updateVerionUrl =
    Uri.parse("$mainUrl/update-versions/${InfoSystem().business()}/");
var addUpdateVerionrUrl =
    Uri.parse("$mainUrl/update-versions/insert-new-update-verion");

// Reservation
var reservationUrl =
    Uri.parse("$mainUrl/reservations/${InfoSystem().business()}/");
var reservationChartPieUrl =
    Uri.parse("$mainUrl/reservations/chart-pie/${InfoSystem().business()}/");
var addReservationUrl =
    Uri.parse("$mainUrl/reservations/insert-new-reservation");

var paiementReservationUrl =
    Uri.parse("$mainUrl/reservations-paiements/${InfoSystem().business()}/");
var addPaiementReservationUrl = Uri.parse(
    "$mainUrl/reservations-paiements/insert-new-reservation-paiement");

// Settings
var monnaieUrl =
    Uri.parse("$mainUrl/settings/monnaies/${InfoSystem().business()}/");
var addMonnaieUrl = Uri.parse("$mainUrl/settings/monnaies/insert-new-monnaie");
