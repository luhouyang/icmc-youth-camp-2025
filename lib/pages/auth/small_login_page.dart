import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/services/auth/app_login.dart';
import 'package:yc_icmc_2025/services/auth/web_login.dart';
import 'package:yc_icmc_2025/widgets/fields/text_input.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget.dart';
import 'package:yc_icmc_2025/widgets/texts/h1_text.dart';
import 'package:yc_icmc_2025/widgets/texts/snack_bar_text.dart';

class SmallLoginPage extends StatefulWidget {
  const SmallLoginPage({super.key});

  @override
  State<SmallLoginPage> createState() => _SmallLoginPageState();
}

class _SmallLoginPageState extends State<SmallLoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  TextInputs textInputs = TextInputs();
  AppLogin appLogin = AppLogin();
  WebLogin webLogin = WebLogin();
  SnackBarText snackBarText = SnackBarText();

  TextEditingController inEmailTextController = TextEditingController();
  TextEditingController inPassTextController = TextEditingController();

  bool _hidePassword = true;

  void setShowPasword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  bool getShowPassword() {
    return _hidePassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FirebaseAuth.instance.currentUser != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const H1Text(text: "LOGOUT"),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () async {
                          kIsWeb ? await webLogin.logout(context) : await appLogin.logout(context);
                          setState(() {});
                        },
                        child: Text(
                          "LOGOUT",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const H1Text(text: "LOGIN"),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      textInputs.inputTextWidget(hint: "email", validator: textInputs.emailVerify, controller: inEmailTextController),
                      textInputs.obscureInputTextWidget(
                          hint: "password",
                          validator: textInputs.passwordVerify,
                          controller: inPassTextController,
                          getFunc: getShowPassword,
                          setFunc: setShowPasword),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(mainAxisSize: MainAxisSize.max, children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_loginFormKey.currentState!.validate()) {
                                snackBarText.showBanner(msg: "Logging In", context: context);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return LoadingWidget().circularLoadingWidget(context);
                                  },
                                );
                                kIsWeb
                                    ? await webLogin.signIn(context, inEmailTextController.text.trim(), inPassTextController.text.trim())
                                    : await appLogin.signIn(context, inEmailTextController.text.trim(), inPassTextController.text.trim());
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                                setState(() {});
                              }
                            },
                            child: Text(
                              "LOGIN",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
