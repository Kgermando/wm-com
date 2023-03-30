import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/style.dart';
import 'package:wm_com/src/pages/auth/controller/login_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/custom_text.dart';
import 'package:wm_com/src/widgets/loading.dart';

class LoginAuth extends GetView<LoginController> {
  const LoginAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    return Scaffold(
      body: Card(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: p10),
                        child: Image.asset(InfoSystem().logo(), height: 150),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text("Login",
                          style: headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text:
                              "Bienvenue sur l'interface ${InfoSystem().name()}.",
                          color: lightGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: p16,
                  ),
                  matriculeBuild(),
                  passwordBuild(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: CustomText(
                              text: "Mot de passe oublié ?", color: mainColor))
                    ],
                  ),
                  const SizedBox(
                    height: p16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: btnBuilder(context)),
                    ],
                  ),
                  const SizedBox(
                    height: p16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget matriculeBuild() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          scrollPhysics: const ScrollPhysics(),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Matricule',
          ),
          controller: controller.matriculeController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est obligatoire';
            }
            return null;
          },
          style: const TextStyle(),
        ));
  }

  Widget passwordBuild() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          scrollPhysics: const ScrollPhysics(),
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Mot de passe',
          ),
          controller: controller.passwordController,
          keyboardType: TextInputType.text,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est obligatoire';
            }
            return null;
          },
          style: const TextStyle(),
        ));
  }

  Widget btnBuilder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      height: 1.3 * (MediaQuery.of(context).size.height / 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 10),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: controller.login,
          child: Obx(() => controller.isLoadingLogin
              ? loadingWhite()
              : Text("Login",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white)))),
    );
  }
}
