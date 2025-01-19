import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UIColor {
  final Color primaryBlue = const Color.fromARGB(255, 10, 10, 75);
  final Color secondaryBlue = const Color.fromARGB(255, 5, 175, 205);

  final Color primaryOrange = const Color.fromARGB(255, 220, 110, 30);
  final Color secondaryOrange = const Color.fromARGB(255, 250, 180, 30);

  final Color primaryRed = const Color.fromARGB(255, 255, 64, 64);

  final Color white = const Color.fromARGB(255, 255, 255, 255);
  final Color darkGray = const Color.fromARGB(255, 90, 90, 90);
  final Color gray = const Color.fromARGB(255, 175, 175, 175);
  final Color mediumGray = const Color.fromARGB(255, 215, 215, 215);
  final Color lightGray = const Color.fromARGB(255, 245, 245, 245);

  final Color blueBlack = const Color.fromARGB(255, 5, 5, 25);
  final Color orangeBlack = const Color.fromARGB(255, 30, 5, 5);

  // Transparent Colors
  final Color transparentPrimaryBlue = const Color.fromARGB(255, 201, 214, 232);
  final Color transparentSecondaryBlue = const Color.fromARGB(255, 213, 246, 251);

  final Color transparentPrimaryOrange = const Color.fromARGB(255, 255, 213, 183);
  final Color transparentSecondaryOrange = const Color.fromARGB(255, 255, 229, 200);
}

class DataPresentationColor {
  final Color lightBackground = UIColor().lightGray;
  final Color darkBackground = UIColor().primaryBlue;

  final List<Color> colourChoices = [
    const Color.fromARGB(255, 255, 200, 80),
    const Color.fromARGB(255, 40, 215, 245),
  ];
}

final ThemeData lightTheme = ThemeData(
  primaryColor: UIColor().primaryBlue,
  scaffoldBackgroundColor: UIColor().white,
  iconTheme: IconThemeData(color: UIColor().primaryBlue),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      textStyle: TextStyle(
        color: UIColor().primaryBlue,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    ),
    displayMedium: GoogleFonts.inter(
      textStyle: TextStyle(
        color: UIColor().primaryBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    headlineMedium: GoogleFonts.inter(
      textStyle: TextStyle(
        color: UIColor().white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    headlineSmall:  GoogleFonts.inter(
      textStyle: TextStyle(
        color: UIColor().white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyMedium: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().primaryBlue),
    ),
    labelLarge: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().secondaryBlue),
    ),
    labelSmall: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().gray),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // padding: const EdgeInsets.all(16),
      foregroundColor: UIColor().white,
      backgroundColor: UIColor().primaryBlue,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: UIColor().gray,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: UIColor().transparentSecondaryBlue,
    hintStyle: TextStyle(fontSize: 16, color: UIColor().primaryBlue),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: UIColor().primaryBlue,
      ),
    ),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: UIColor().secondaryBlue,
      ),
    ),
    hoverColor: UIColor().transparentPrimaryBlue,
    errorStyle: TextStyle(
      color: UIColor().primaryRed,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: UIColor().transparentSecondaryBlue,
    contentTextStyle: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().primaryBlue),
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStatePropertyAll(
      UIColor().secondaryBlue,
    ),
  ),
  cardTheme: CardTheme(
    color: UIColor().mediumGray,
  ),
  highlightColor: UIColor().secondaryBlue,
  dividerTheme: DividerThemeData(
    color: UIColor().primaryBlue,
    thickness: 1.5,
  ),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  primaryColor: UIColor().white,
  scaffoldBackgroundColor: UIColor().blueBlack,
  iconTheme: IconThemeData(color: UIColor().secondaryOrange),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      textStyle: TextStyle(
        color: UIColor().white,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    ),
    displayMedium: GoogleFonts.inter(
      textStyle: TextStyle(
        color: UIColor().secondaryOrange,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    headlineMedium: GoogleFonts.inter(
      textStyle: TextStyle(
        color: UIColor().primaryBlue,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyMedium: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().white),
    ),
    labelLarge: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().primaryOrange),
    ),
    labelSmall: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().gray),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // padding: const EdgeInsets.all(16),
      foregroundColor: UIColor().blueBlack,
      backgroundColor: UIColor().secondaryOrange,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: UIColor().transparentSecondaryOrange,
    hintStyle: TextStyle(fontSize: 16, color: UIColor().blueBlack),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: UIColor().white,
      ),
    ),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: UIColor().secondaryOrange,
      ),
    ),
    hoverColor: UIColor().transparentPrimaryOrange,
    errorStyle: TextStyle(
      color: UIColor().primaryRed,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: UIColor().transparentSecondaryOrange,
    contentTextStyle: GoogleFonts.inter(
      textStyle: TextStyle(color: UIColor().blueBlack),
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStatePropertyAll(
      UIColor().secondaryOrange,
    ),
  ),
  cardTheme: CardTheme(
    color: UIColor().darkGray,
  ),
  highlightColor: UIColor().primaryOrange,
  dividerTheme: DividerThemeData(
    color: UIColor().white,
    thickness: 1.5,
  ),
  useMaterial3: true,
);
