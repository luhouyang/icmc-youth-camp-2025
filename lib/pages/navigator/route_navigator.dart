import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/pages/navigator/large_navigator.dart';
import 'package:yc_icmc_2025/pages/navigator/small_navigator.dart';
import 'package:yc_icmc_2025/states/constants.dart';

class RouteNavigator extends StatelessWidget {
  final bool loggedIn;
  const RouteNavigator({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth > Constants().largeScreenWidth
        ? LargeNavigator(
            loggedIn: loggedIn,
          )
        : SmallNavigator(
            loggedIn: loggedIn,
          );
  }
}
