import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/pages/about/small_about_page.dart';
import 'package:yc_icmc_2025/pages/admin/small_admin_page.dart';
import 'package:yc_icmc_2025/pages/home/small_home_page.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class SmallNavigator extends StatefulWidget {
  final bool loggedIn;
  const SmallNavigator({super.key, required this.loggedIn});

  @override
  State<SmallNavigator> createState() => _SmallNavigatorState();
}

class _SmallNavigatorState extends State<SmallNavigator> with TickerProviderStateMixin {
  late AnimationController _hideBottomBarAnimationController;

  final iconListAdmin = <IconData>[
    Icons.home_outlined,
    Icons.info_outline_rounded,
    Icons.admin_panel_settings_outlined,
  ];

  final iconListNormal = <IconData>[
    Icons.home_outlined,
    Icons.info_outline_rounded,
  ];

  @override
  void initState() {
    super.initState();

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification && notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget getPage(int index) {
      if (index == 0) {
        return const SmallHomePage();
      } else if (index == 1) {
        return const SmallAboutPage();
      } else if (index == 2) {
        return const SmallAdminPage();
      }
      return const SmallHomePage();
    }

    return Consumer<AppState>(
      builder: (context, appState, child) {
        List<IconData> iconList = widget.loggedIn ? iconListAdmin : iconListNormal;

        return Scaffold(
          body: NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: Column(
              children: [
                if (!kIsWeb)
                  const SizedBox(
                    height: 36,
                  ),
                SizedBox(
                  height: 54,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    child: Row(
                      children: [
                        Image.asset('assets/profile_placeholder.jpg'),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Youth Camp",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const Expanded(child: SizedBox()),
                        appState.isDarkMode
                            ? IconButton(
                                onPressed: () {
                                  AdaptiveTheme.of(context).setLight();
                                  appState.setDarkMode(false);
                                },
                                icon: const Icon(
                                  Icons.light_mode_outlined,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  AdaptiveTheme.of(context).setDark();
                                  setState(() {
                                    appState.setDarkMode(true);
                                  });
                                },
                                icon: const Icon(
                                  Icons.dark_mode_outlined,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: getPage(appState.bottomNavIndex),
                )
              ],
            ),
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive
                  ? appState.isDarkMode
                      ? Theme.of(context).iconTheme.color
                      : UIColor().secondaryBlue
                  : UIColor().gray;

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: color,
                  ),
                ],
              );
            },
            backgroundColor: UIColor().primaryBlue,
            activeIndex: appState.bottomNavIndex,
            splashColor: appState.isDarkMode ? Theme.of(context).iconTheme.color : UIColor().secondaryBlue,
            gapLocation: GapLocation.none,
            onTap: (index) => appState.setBottomNavIndex(index),
            hideAnimationController: _hideBottomBarAnimationController,
          ),
        );
      },
    );
  }
}
