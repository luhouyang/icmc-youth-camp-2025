import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/states/constants.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class LargeHomePage extends StatefulWidget {
  const LargeHomePage({super.key});

  @override
  State<LargeHomePage> createState() => _LargeHomePageState();
}

class _LargeHomePageState extends State<LargeHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        double availableScreenWidth = screenWidth - (appState.isNavBarCollapsed ? 75 : 270);
        int crossAxisCount = (availableScreenWidth / 400).floor();
        double aspectRation = crossAxisCount == 1 ? 0.75 : 0.65;
        double crossAxisSpacing = 8.0;
        double mainAxisSpacing = 8.0;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/profile_placeholder.jpg',
                      height: max(500, screenWidth * 0.35),
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: max(500, screenWidth * 0.35),
                        width: availableScreenWidth,
                        color: (appState.isDarkMode ? UIColor().transparentPrimaryOrange : UIColor().transparentPrimaryBlue).withOpacity(0.5),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: max(500, screenWidth * 0.35) / 2.5,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            "Youth Camp",
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: appState.isDarkMode ? UIColor().orangeBlack : UIColor().blueBlack,
                                  fontSize: 64,
                                ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(Constants().largeScreenPadding),
                  child: FirebaseAuth.instance.currentUser != null
                      ? const Column(
                          children: [Text("Auth")],
                        )
                      : const Column(
                          children: [Text("Not auth")],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
