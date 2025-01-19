import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/widgets/texts/snack_bar_text.dart';

class WebLogin {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      context.mounted ? SnackBarText().showBanner(msg: "Error during sign-in: $e", context: context) : debugPrint("Error during sign-in: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      firebaseAuth.signOut();
    } catch (e) {
      context.mounted ? SnackBarText().showBanner(msg: "Error during sign out: $e", context: context) : debugPrint("Error during sign out: $e");
    }
  }
}
