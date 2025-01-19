import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/pages/navigator/route_navigator.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/states/constants.dart';

class RouteLoginPage extends StatefulWidget {
  const RouteLoginPage({super.key});

  @override
  State<RouteLoginPage> createState() => _RouteLoginPageState();
}

class _RouteLoginPageState extends State<RouteLoginPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth > Constants().largeScreenWidth) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // if (!snapshot.hasData) {
              //   return Stack(
              //     children: [
              //       screenWidth > Constants().largeScreenWidth ? const LargeLoginPage() : const SmallLoginPage(),
              //       Positioned(
              //         top: (screenWidth > Constants().largeScreenWidth || kIsWeb) ? 10 : 35,
              //         right: 15,
              //         child: appState.isDarkMode
              //             ? IconButton(
              //                 onPressed: () {
              //                   AdaptiveTheme.of(context).setLight();
              //                   appState.setDarkMode(false);
              //                 },
              //                 icon: const Icon(
              //                   Icons.light_mode_outlined,
              //                 ),
              //               )
              //             : IconButton(
              //                 onPressed: () {
              //                   AdaptiveTheme.of(context).setDark();
              //                   appState.setDarkMode(true);
              //                 },
              //                 icon: const Icon(
              //                   Icons.dark_mode_outlined,
              //                 ),
              //               ),
              //       ),
              //     ],
              //   );
              // }
              if (!snapshot.hasData) {
                return const RouteNavigator(loggedIn: false,);
              }

              return const RouteNavigator(loggedIn: true,);
            },
          ),
        );
      },
    );
  }
}
