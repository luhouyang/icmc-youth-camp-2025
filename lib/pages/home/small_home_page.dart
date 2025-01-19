import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/states/constants.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class SmallHomePage extends StatefulWidget {
  const SmallHomePage({super.key});

  @override
  State<SmallHomePage> createState() => _SmallHomePageState();
}

class _SmallHomePageState extends State<SmallHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        int crossAxisCount = (screenWidth / 400).ceil();
        double aspectRation = 0.6;
        double crossAxisSpacing = 4.0;
        double mainAxisSpacing = 4.0;

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Constants().smallScreenPadding),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/profile_placeholder.jpg',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          height: 250,
                          width: screenWidth,
                          color: (appState.isDarkMode ? UIColor().transparentPrimaryOrange : UIColor().transparentPrimaryBlue).withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 120,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "Youth Camp",
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                    color: appState.isDarkMode ? UIColor().orangeBlack : UIColor().blueBlack,
                                    fontSize: 36,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  FirebaseAuth.instance.currentUser != null
                      ? const Column(
                          children: [Text("Auth")],
                        )
                      : const Column(
                          children: [Text("Not auth")],
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
