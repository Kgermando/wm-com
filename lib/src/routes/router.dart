import 'package:get/get.dart';
import 'package:wm_com/src/models/archive/archive_model.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/bon_livraison.dart';
import 'package:wm_com/src/models/commercial/cart_model.dart';
import 'package:wm_com/src/models/commercial/creance_cart_model.dart';
import 'package:wm_com/src/models/commercial/facture_cart_model.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/models/commercial/restitution_model.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart'; 
import 'package:wm_com/src/models/finance/caisse_model.dart';
import 'package:wm_com/src/models/finance/caisse_name_model.dart';
import 'package:wm_com/src/models/mail/mail_model.dart';
import 'package:wm_com/src/models/marketing/agenda_model.dart';
import 'package:wm_com/src/models/marketing/annuaire_model.dart'; 
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/models/update/update_model.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/pages/404/error.dart';
import 'package:wm_com/src/pages/archives/bindings/archive_binding.dart';
import 'package:wm_com/src/pages/archives/components/add_archive.dart';
import 'package:wm_com/src/pages/archives/components/archive_image_reader.dart';
import 'package:wm_com/src/pages/archives/components/archive_pdf_viewer.dart';
import 'package:wm_com/src/pages/archives/components/detail_archive.dart';
import 'package:wm_com/src/pages/archives/components/update_archive.dart';
import 'package:wm_com/src/pages/archives/views/archive_folder_page.dart';
import 'package:wm_com/src/pages/archives/views/archives.dart';
import 'package:wm_com/src/pages/auth/bindings/auth_binding.dart';
import 'package:wm_com/src/pages/auth/view/change_password_auth.dart';
import 'package:wm_com/src/pages/auth/view/forgot_password.dart';
import 'package:wm_com/src/pages/auth/view/login_auth.dart';
import 'package:wm_com/src/pages/auth/view/profil_auth.dart';
import 'package:wm_com/src/pages/commercial/bindings/com_binding.dart';
import 'package:wm_com/src/pages/commercial/components/achats/detail_achat.dart';
import 'package:wm_com/src/pages/commercial/components/bon_livraison/detail_bon_livraison.dart';
import 'package:wm_com/src/pages/commercial/components/cart/detail_cart.dart';
import 'package:wm_com/src/pages/commercial/components/factures/detail_facture.dart';
import 'package:wm_com/src/pages/commercial/components/factures/detail_facture_creance.dart';
import 'package:wm_com/src/pages/commercial/components/produit_model/ajout_product_model.dart';
import 'package:wm_com/src/pages/commercial/components/produit_model/detail_product_model.dart';
import 'package:wm_com/src/pages/commercial/components/produit_model/update_product_modele_controller.dart';
import 'package:wm_com/src/pages/commercial/components/restitution/detail_restitution.dart';
import 'package:wm_com/src/pages/commercial/components/stock_global/add_stock_global.dart';
import 'package:wm_com/src/pages/commercial/components/stock_global/detail_stock_global.dart';
import 'package:wm_com/src/pages/commercial/components/stock_global/livraison_stock.dart';
import 'package:wm_com/src/pages/commercial/components/stock_global/ravitaillement_stock.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/add_succursale.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/detail_succursale.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/update_succursale.dart';
import 'package:wm_com/src/pages/commercial/components/vente_effectue/detail_vente_effectue.dart';
import 'package:wm_com/src/pages/commercial/view/achat_page.dart';
import 'package:wm_com/src/pages/commercial/view/bon_livraison_page.dart';
import 'package:wm_com/src/pages/commercial/view/cart_page.dart';
import 'package:wm_com/src/pages/commercial/view/dashboard_com_page.dart';
import 'package:wm_com/src/pages/commercial/view/facture_page.dart';
import 'package:wm_com/src/pages/commercial/view/history_livraison_page.dart';
import 'package:wm_com/src/pages/commercial/view/history_ravitaillement_page.dart';
import 'package:wm_com/src/pages/commercial/view/produit_model_page.dart';
import 'package:wm_com/src/pages/commercial/view/restitution_page.dart';
import 'package:wm_com/src/pages/commercial/view/stock_global_page.dart';
import 'package:wm_com/src/pages/commercial/view/succursale_page.dart';
import 'package:wm_com/src/pages/commercial/view/vente_effectue_page.dart';
import 'package:wm_com/src/pages/commercial/view/vente_page.dart';
 
import 'package:wm_com/src/pages/finance/binding/caisse_binding.dart';
import 'package:wm_com/src/pages/finance/components/caisses/detail_caisse.dart';
import 'package:wm_com/src/pages/finance/view/caisse_page.dart';
import 'package:wm_com/src/pages/finance/view/dashboard_caisse.dart';
import 'package:wm_com/src/pages/home/bindings/home_binding.dart';
import 'package:wm_com/src/pages/home/view/home_page.dart';
import 'package:wm_com/src/pages/home/view/sub_home_page.dart';
import 'package:wm_com/src/pages/mailling/bindings/mail_binding.dart';
import 'package:wm_com/src/pages/mailling/components/detail_mail.dart';
import 'package:wm_com/src/pages/mailling/components/new_mail.dart';
import 'package:wm_com/src/pages/mailling/components/repondre_mail.dart';
import 'package:wm_com/src/pages/mailling/components/tranfert_mail.dart';
import 'package:wm_com/src/pages/mailling/view/mail_send.dart';
import 'package:wm_com/src/pages/mailling/view/mails_page.dart';
import 'package:wm_com/src/pages/marketing/binding/marketing_binding.dart';
import 'package:wm_com/src/pages/marketing/components/agenda/detail_agenda.dart';
import 'package:wm_com/src/pages/marketing/components/agenda/update_agenda.dart';
import 'package:wm_com/src/pages/marketing/components/annuaire/add_annuaire.dart';
import 'package:wm_com/src/pages/marketing/components/annuaire/detail_anniuaire.dart';
import 'package:wm_com/src/pages/marketing/components/annuaire/update_annuaire.dart';
import 'package:wm_com/src/pages/marketing/view/agenda_page.dart';
import 'package:wm_com/src/pages/marketing/view/annuaire_page.dart'; 
import 'package:wm_com/src/pages/rh/binding/personnel_binding.dart';
import 'package:wm_com/src/pages/rh/components/add_personnel.dart';
import 'package:wm_com/src/pages/rh/components/detail._user.dart';
import 'package:wm_com/src/pages/rh/components/detail_personne.dart';
import 'package:wm_com/src/pages/rh/components/update_personnel.dart';
import 'package:wm_com/src/pages/rh/view/dashboard_rh.dart';
import 'package:wm_com/src/pages/rh/view/personnel_page.dart';
import 'package:wm_com/src/pages/rh/view/users_page.dart';
import 'package:wm_com/src/pages/screens/binding/setting_binfing.dart';
import 'package:wm_com/src/pages/screens/binding/splash_binding.dart';
import 'package:wm_com/src/pages/screens/components/settings/monnaie_page.dart';
import 'package:wm_com/src/pages/screens/help_page.dart';
import 'package:wm_com/src/pages/screens/settings_page.dart';
import 'package:wm_com/src/pages/screens/splash_page.dart'; 
import 'package:wm_com/src/pages/update/binding/update_binfing.dart';
import 'package:wm_com/src/pages/update/components/detail_update.dart'; 
import 'package:wm_com/src/routes/routes.dart';

List<GetPage<dynamic>>? getPages = [
  // 404
  GetPage(
      name: ExceptionRoutes.notFound,
      page: () => const PageNotFound(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  // Settings
  GetPage(
      name: SettingsRoutes.splash,
      binding: SplashBinding(),
      page: () => const SplashView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: SettingsRoutes.settings,
      page: () => const SettingsPage(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: SettingsRoutes.helps,
      page: () => const HelpPage(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: SettingsRoutes.monnaiePage,
      binding: SettingsBinding(),
      page: () => const MonnaiePage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(seconds: 1)),

  // HomeRoutes
  GetPage(
      name: HomeRoutes.home,
      binding: HomeBinding(),
      page: () => const HomePage(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: HomeRoutes.subHome,
      binding: HomeBinding(),
      page: () => const SubHomePage(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(seconds: 1)),

  // UserRoutes
  GetPage(
      name: UserRoutes.login,
      binding: AuthBinding(),
      page: () => const LoginAuth(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: UserRoutes.logout,
      binding: AuthBinding(),
      page: () => const LoginAuth(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: UserRoutes.profil,
      binding: AuthBinding(),
      page: () => const ProfileAuth(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: UserRoutes.changePassword,
      binding: AuthBinding(),
      page: () => const ChangePasswordAuth(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: UserRoutes.forgotPassword,
      binding: AuthBinding(),
      page: () => const ForgotPassword(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  // Mails
  GetPage(
      name: MailRoutes.mails,
      binding: MailBinding(),
      page: () => const MailPages(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MailRoutes.addMail,
      binding: MailBinding(),
      page: () => const NewMail(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MailRoutes.mailSend,
      binding: MailBinding(),
      page: () => const MailSend(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MailRoutes.mailDetail,
      binding: MailBinding(),
      page: () {
        MailColor mailColor = Get.arguments as MailColor;
        return DetailMail(mailColor: mailColor);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MailRoutes.mailRepondre,
      binding: MailBinding(),
      page: () {
        MailModel mailModel = Get.arguments as MailModel;
        return RepondreMail(mailModel: mailModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MailRoutes.mailTransfert,
      binding: MailBinding(),
      page: () {
        MailModel mailModel = Get.arguments as MailModel;
        return TransfertMail(mailModel: mailModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  // Archives
  GetPage(
      name: ArchiveRoutes.archivesFolder,
      binding: ArchiveBinding(),
      page: () => const ArchiveFolderPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ArchiveRoutes.archiveTable,
      binding: ArchiveBinding(),
      page: () {
        ArchiveFolderModel archiveFolderModel =
            Get.arguments as ArchiveFolderModel;
        return ArchiveData(archiveFolderModel: archiveFolderModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ArchiveRoutes.addArchives,
      binding: ArchiveBinding(),
      page: () {
        ArchiveFolderModel archiveFolderModel =
            Get.arguments as ArchiveFolderModel;
        return AddArchive(archiveFolderModel: archiveFolderModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ArchiveRoutes.archivesDetail,
      binding: ArchiveBinding(),
      page: () {
        ArchiveModel archiveModel = Get.arguments as ArchiveModel;
        return DetailArchive(archiveModel: archiveModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ArchiveRoutes.archivesUpdate,
      binding: ArchiveBinding(),
      page: () {
        ArchiveModel archiveModel = Get.arguments as ArchiveModel;
        return UpdateArchive(archiveModel: archiveModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ArchiveRoutes.archivePdf,
      binding: ArchiveBinding(),
      page: () {
        String url = Get.arguments as String;
        return ArchivePdfViewer(url: url);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ArchiveRoutes.archiveImage,
      binding: ArchiveBinding(),
      page: () {
        String url = Get.arguments as String;
        return ArchiveImageReader(url: url);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

   // Commercial
  GetPage(
      name: ComRoutes.comDashboard,
      binding: ComBinding(),
      page: () => const DashboardCommPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comSuccursale,
      binding: ComBinding(),
      page: () => const SuccursalePage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comSuccursaleAdd,
      binding: ComBinding(),
      page: () => const AddSuccursale(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comSuccursaleDetail,
      binding: ComBinding(),
      page: () {
        final SuccursaleModel succursaleModel =
            Get.arguments as SuccursaleModel;
        return DetailSuccursale(succursaleModel: succursaleModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comSuccursaleUpdate,
      binding: ComBinding(),
      page: () {
        final SuccursaleModel succursaleModel =
            Get.arguments as SuccursaleModel;
        return UpdateSuccursale(succursaleModel: succursaleModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comVente,
      binding: ComBinding(),
      page: () => const VentePage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comStockGlobal,
      binding: ComBinding(),
      page: () => const StockGlobalPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comStockGlobalAdd,
      binding: ComBinding(),
      page: () => const AddStockGlobal(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comStockGlobalDetail,
      binding: ComBinding(),
      page: () {
        final StocksGlobalMOdel stocksGlobalMOdel =
            Get.arguments as StocksGlobalMOdel;
        return DetailStockGlobal(stocksGlobalMOdel: stocksGlobalMOdel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comStockGlobalLivraisonStock,
      binding: ComBinding(),
      page: () {
        final StocksGlobalMOdel stocksGlobalMOdel =
            Get.arguments as StocksGlobalMOdel;
        return LivraisonStock(stocksGlobalMOdel: stocksGlobalMOdel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comStockGlobalRavitaillement,
      binding: ComBinding(),
      page: () {
        final StocksGlobalMOdel stocksGlobalMOdel =
            Get.arguments as StocksGlobalMOdel;
        return RavitaillementStock(stocksGlobalMOdel: stocksGlobalMOdel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  GetPage(
      name: ComRoutes.comRestitution,
      binding: ComBinding(),
      page: () => const RestitutionPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comRestitutionDetail,
      binding: ComBinding(),
      page: () {
        final RestitutionModel restitutionModel =
            Get.arguments as RestitutionModel;
        return DetailRestitution(restitutionModel: restitutionModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comProduitModel,
      binding: ComBinding(),
      page: () => const ProduitModelPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comProduitModelAdd,
      binding: ComBinding(),
      page: () => const AjoutProductModel(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comProduitModelDetail,
      binding: ComBinding(),
      page: () {
        final ProductModel productModel = Get.arguments as ProductModel;
        return DetailProductModel(productModel: productModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comProduitModelUpdate,
      binding: ComBinding(),
      page: () {
        final ProductModel productModel = Get.arguments as ProductModel;
        return UpdateProductModele(productModel: productModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  GetPage(
      name: ComRoutes.comHistoryRavitaillement,
      binding: ComBinding(),
      page: () => const HistoryRavitaillementPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comHistoryLivraison,
      binding: ComBinding(),
      page: () => const HistoryLivraisonPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  GetPage(
      name: ComRoutes.comFacture,
      binding: ComBinding(),
      page: () => const FacturePage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comFactureDetail,
      binding: ComBinding(),
      page: () {
        final FactureCartModel factureCartModel =
            Get.arguments as FactureCartModel;
        return DetailFacture(factureCartModel: factureCartModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comCreanceDetail,
      binding: ComBinding(),
      page: () {
        final CreanceCartModel creanceCartModel =
            Get.arguments as CreanceCartModel;
        return DetailFactureCreance(creanceCartModel: creanceCartModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  GetPage(
      name: ComRoutes.comCart,
      binding: ComBinding(),
      page: () => const CartPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comCartDetail,
      binding: ComBinding(),
      page: () {
        final CartModel cart = Get.arguments as CartModel;
        return DetailCart(cart: cart);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  GetPage(
      name: ComRoutes.comBonLivraison,
      binding: ComBinding(),
      page: () => const BonLivraisonPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comBonLivraisonDetail,
      binding: ComBinding(),
      page: () {
        final BonLivraisonModel bonLivraisonModel =
            Get.arguments as BonLivraisonModel;
        return DetailBonLivraison(bonLivraisonModel: bonLivraisonModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  GetPage(
      name: ComRoutes.comAchat,
      binding: ComBinding(),
      page: () => const AchatPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comAchatDetail,
      binding: ComBinding(),
      page: () {
        final AchatModel achatModel = Get.arguments as AchatModel;
        return DetailAchat(achatModel: achatModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  GetPage(
      name: ComRoutes.comVenteEffectue,
      binding: ComBinding(),
      page: () => const VenteEffectue(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: ComRoutes.comVenteEffectueDetail,
      binding: ComBinding(),
      page: () {
        final VenteCartModel venteCartModel = Get.arguments as VenteCartModel;
        return DetailVenteEffectue(venteCartModel: venteCartModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),


  // RH
  GetPage(
      name: RhRoutes.rhDashboard,
      binding: PersonnelBinding(),
      page: () => const DashboardRH(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: RhRoutes.rhPersonnelsPage,
      binding: PersonnelBinding(),
      page: () => const PersonnelPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: RhRoutes.rhPersonnelsAdd,
      binding: PersonnelBinding(),
      page: () {
        List<AgentModel> personnelList = Get.arguments as List<AgentModel>;
        return AddPersonnel(personnelList: personnelList);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: RhRoutes.rhPersonnelsDetail,
      binding: PersonnelBinding(),
      page: () {
        final AgentModel personne = Get.arguments as AgentModel;
        return DetailPersonne(personne: personne);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: RhRoutes.rhPersonnelsUpdate,
      binding: PersonnelBinding(),
      page: () {
        AgentModel personne = Get.arguments as AgentModel;
        return UpdatePersonnel(personne: personne);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: RhRoutes.rhUserActif,
      binding: PersonnelBinding(),
      page: () => const UserPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: RhRoutes.rhdetailUser,
      binding: PersonnelBinding(),
      page: () {
        final UserModel user = Get.arguments as UserModel;
        return DetailUser(user: user);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  // Finance
  GetPage(
      name: FinanceRoutes.transactionsCaisseDashbaord,
      binding: CaisseBinding(),
      page: () => const DashboardCaisse(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: '/transactions-caisse/:id',
      binding: CaisseBinding(),
      page: () {
        final CaisseNameModel caisseNameModel =
            Get.arguments as CaisseNameModel;
        return CaissePage(caisseNameModel: caisseNameModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: FinanceRoutes.transactionsCaisseDetail,
      binding: CaisseBinding(),
      page: () {
        final CaisseModel caisseModel = Get.arguments as CaisseModel;
        return DetailCaisse(caisseModel: caisseModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  // Marketing
  GetPage(
      name: MarketingRoutes.marketingAnnuaire,
      binding: MarketingBinding(),
      page: () => const AnnuairePage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MarketingRoutes.marketingAnnuaireAdd,
      binding: MarketingBinding(),
      page: () => const AddAnnuaire(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MarketingRoutes.marketingAnnuaireDetail,
      binding: MarketingBinding(),
      page: () {
        final AnnuaireColor annuaireColor = Get.arguments as AnnuaireColor;
        return DetailAnnuaire(annuaireColor: annuaireColor);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MarketingRoutes.marketingAnnuaireEdit,
      binding: MarketingBinding(),
      page: () {
        final AnnuaireModel annuaireModel = Get.arguments as AnnuaireModel;
        return UpdateAnnuaire(annuaireModel: annuaireModel);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MarketingRoutes.marketingAgenda,
      binding: MarketingBinding(),
      page: () => const AgendaPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MarketingRoutes.marketingAgendaDetail,
      binding: MarketingBinding(),
      page: () {
        final AgendaColor agendaColor = Get.arguments as AgendaColor;
        return DetailAgenda(agendaColor: agendaColor);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),
  GetPage(
      name: MarketingRoutes.marketingAgendaUpdate,
      binding: MarketingBinding(),
      page: () {
        final AgendaColor agendaColor = Get.arguments as AgendaColor;
        return UpdateAgenda(agendaColor: agendaColor);
      },
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 1)),

  // Update version
  // GetPage(
  //     name: UpdateRoutes.updatePage,
  //     page: () => const UpdatePage(),
  //     binding: UpdateBinding(),
  //     transition: Transition.cupertino,
  //     transitionDuration: const Duration(seconds: 1)),
  GetPage(
    name: '/update/:id',
    binding: UpdateBinding(),
    page: () {
      final UpdateModel updateModel = Get.arguments as UpdateModel;
      return DetailUpdate(updateModel: updateModel);
    },
    transition: Transition.cupertino,
    transitionDuration: const Duration(seconds: 1),
  ),
];
