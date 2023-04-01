import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/role_theme.dart';
import 'package:wm_com/src/pages/404/error.dart';
import 'package:wm_com/src/pages/screens/binding/splash_binding.dart';
import 'package:wm_com/src/routes/router.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
 
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
        debugShowCheckedModeBanner: false,
        popGesture: true,
        title: InfoSystem().name(),
        initialBinding: SplashBinding(),
        initialRoute: SettingsRoutes.splash,
        unknownRoute: GetPage(
          name: '/not-found',
          page: () => const PageNotFound(),
          transition: Transition.fadeIn
        ),
        getPages: getPages,
        theme: ThemeData(
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
            },
          ),
          scaffoldBackgroundColor: Colors.blue.shade50,
          primaryColor: Colors.white,
          primarySwatch: roleThemeSwatch(1),
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.light(
            primary: mainColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(5.0),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0));
              }),
              textStyle: MaterialStateProperty.all(const TextStyle(
                color: Colors.white,
              )),
              backgroundColor: MaterialStateProperty.all(mainColor),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        )),
  );
}
