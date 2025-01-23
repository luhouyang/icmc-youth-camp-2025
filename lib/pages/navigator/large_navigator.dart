import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/pages/about/large_about_page.dart';
import 'package:yc_icmc_2025/pages/admin/large_admin_page.dart';
import 'package:yc_icmc_2025/pages/home/large_home_page.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class NavItemModel {
  const NavItemModel({
    required this.idx,
    required this.name,
    required this.icon,
  });

  final int idx;
  final String name;
  final IconData icon;
}

extension on Widget {
  Widget? showOrNull(bool isShow) => isShow ? this : null;
}

class LargeNavigator extends StatefulWidget {
  final bool loggedIn;
  const LargeNavigator({super.key, required this.loggedIn});

  @override
  State<LargeNavigator> createState() => _LargeNavigatorState();
}

class _LargeNavigatorState extends State<LargeNavigator> {
  final _sideMenuController = SideMenuController();

  final _navItems = const [
    NavItemModel(idx: 0, name: 'Home', icon: Icons.home_outlined),
    NavItemModel(idx: 1, name: 'About', icon: Icons.info_outline_rounded),
  ];

  final _adminItems = const [
    NavItemModel(idx: 2, name: 'Admin', icon: Icons.admin_panel_settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    Widget getPage(int index) {
      if (index == 0) {
        return const LargeHomePage();
      } else if (index == 1) {
        return const LargeAboutPage();
      } else if (index == 2) {
        return const LargeAdminPage();
      }
      return const LargeHomePage();
    }

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: Row(
            children: [
              SideMenu(
                backgroundColor: UIColor().primaryBlue,
                hasResizerToggle: false,
                hasResizer: false,
                controller: _sideMenuController,
                mode: appState.isNavBarCollapsed ? SideMenuMode.compact : SideMenuMode.open,
                minWidth: 75,
                maxWidth: 270,
                builder: (data) {
                  return SideMenuData(
                    header: Column(
                      children: [
                        ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: InkWell(
                              onHover: (value) {},
                              onTap: () {
                                appState.setNavBarCollapsed(!appState.isNavBarCollapsed);
                              },
                              child: appState.isNavBarCollapsed
                                  ? Icon(
                                      Icons.menu_outlined,
                                      color: appState.isDarkMode ? Theme.of(context).iconTheme.color : UIColor().secondaryBlue,
                                    )
                                  : Icon(
                                      Icons.menu_open_outlined,
                                      color: appState.isDarkMode ? Theme.of(context).iconTheme.color : UIColor().secondaryBlue,
                                    ),
                            ),
                          ),
                          title: Text(
                            'Youth Camp',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: UIColor().white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ).showOrNull(!appState.isNavBarCollapsed),
                        ),
                      ],
                    ),
                    items: [
                      ..._navItems.map(
                        (e) => SideMenuItemDataTile(
                          isSelected: e.idx == appState.bottomNavIndex,
                          onTap: () {
                            appState.setBottomNavIndex(e.idx);
                          },
                          title: e.name,
                          titleStyle: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: UIColor().white,
                              fontSize: 16,
                            ),
                          ),
                          hoverColor: e.idx == appState.bottomNavIndex
                              ? Colors.transparent
                              : appState.isDarkMode
                                  ? UIColor().transparentSecondaryOrange.withOpacity(0.4)
                                  : UIColor().transparentSecondaryBlue.withOpacity(0.4),
                          hasSelectedLine: false,
                          highlightSelectedColor: appState.isDarkMode
                              ? UIColor().transparentPrimaryOrange.withOpacity(0.35)
                              : UIColor().transparentPrimaryBlue.withOpacity(0.35),
                          selectedTitleStyle: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appState.isDarkMode ? UIColor().secondaryRed : UIColor().secondaryBlue,
                            ),
                          ),
                          icon: Icon(
                            e.icon,
                            color: e.idx == appState.bottomNavIndex
                                ? appState.isDarkMode
                                    ? Theme.of(context).iconTheme.color
                                    : UIColor().secondaryBlue
                                : UIColor().gray,
                          ),
                        ),
                      ),
                      if (!appState.isNavBarCollapsed && widget.loggedIn)
                        SideMenuItemDataDivider(
                            divider: Divider(
                          color: UIColor().white,
                        )),
                      if (!appState.isNavBarCollapsed && widget.loggedIn)
                        SideMenuItemDataTitle(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
                          title: 'Admin',
                          titleStyle: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: UIColor().white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (FirebaseAuth.instance.currentUser != null)
                        ..._adminItems.map(
                          (e) => SideMenuItemDataTile(
                            isSelected: e.idx == appState.bottomNavIndex,
                            onTap: () {
                              appState.setBottomNavIndex(e.idx);
                            },
                            title: e.name,
                            titleStyle: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: UIColor().white,
                                fontSize: 16,
                              ),
                            ),
                            hoverColor: e.idx == appState.bottomNavIndex
                                ? Colors.transparent
                                : appState.isDarkMode
                                    ? UIColor().transparentSecondaryOrange.withOpacity(0.4)
                                    : UIColor().transparentSecondaryBlue.withOpacity(0.4),
                            hasSelectedLine: false,
                            highlightSelectedColor: appState.isDarkMode
                                ? UIColor().transparentPrimaryOrange.withOpacity(0.35)
                                : UIColor().transparentPrimaryBlue.withOpacity(0.35),
                            selectedTitleStyle: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: appState.isDarkMode ? UIColor().secondaryRed : UIColor().secondaryBlue,
                              ),
                            ),
                            icon: Icon(
                              e.icon,
                              color: e.idx == appState.bottomNavIndex
                                  ? appState.isDarkMode
                                      ? Theme.of(context).iconTheme.color
                                      : UIColor().secondaryBlue
                                  : UIColor().gray,
                            ),
                          ),
                        ),
                    ],
                    footer: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appState.isDarkMode
                              ? IconButton(
                                  onPressed: () {
                                    AdaptiveTheme.of(context).setLight();
                                    appState.setDarkMode(false);
                                  },
                                  icon: Icon(
                                    Icons.light_mode_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    AdaptiveTheme.of(context).setDark();
                                    setState(() {
                                      appState.setDarkMode(true);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.dark_mode_outlined,
                                    color: UIColor().secondaryBlue,
                                  ),
                                ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: getPage(appState.bottomNavIndex),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
