import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/firebase_options.dart';
import 'package:yc_icmc_2025/pages/auth/route_login_page.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AppState(savedThemeMode: savedThemeMode ?? AdaptiveThemeMode.light),
          ),
        ],
        child: AdaptiveTheme(
          light: lightTheme,
          dark: darkTheme,
          initial: savedThemeMode ?? AdaptiveThemeMode.light,
          builder: (light, dark) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: light,
            darkTheme: dark,
            home: const RouteLoginPage(),
          ),
        ));
  }
}
