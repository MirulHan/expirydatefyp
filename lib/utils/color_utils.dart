import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

LinearGradient hexStringToGradient(List<String> hexColors) {
  List<Color> colors =
      hexColors.map((hexColor) => hexStringToColor(hexColor)).toList();

  return LinearGradient(
    colors: colors,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

Color hexStringToColor(String hexColor) {
  final String cleanedHexString = hexColor.replaceFirst('#', '');
  final int length = cleanedHexString.length;

  if (length == 6) {
    return Color(int.parse(cleanedHexString, radix: 16) + 0xFF000000);
  } else if (length == 8) {
    return Color(int.parse(cleanedHexString, radix: 16));
  } else {
    throw ArgumentError('Invalid hex color string length: $length');
  }
}

LinearGradient getFixedGradient() {
  return hexStringToGradient([
    '#FFC107',
    '#FFD600',
    '#FFE86C',
    '#FFE86C',
    '#FFD600',
    '#FFC107',
  ]);
}

class CustomColors {
  static const Color greyBackground = Color.fromRGBO(249, 252, 255, 1);
  static const Color greyBorder = Color.fromRGBO(207, 207, 207, 1);

  static const Color greenLight = Color.fromRGBO(93, 230, 26, 1);
  static const Color greenDark = Color.fromRGBO(57, 170, 2, 1);
  static const Color greenIcon = Color.fromRGBO(30, 209, 2, 1);
  static const Color greenAccent = Color.fromRGBO(30, 209, 2, 1);
  static const Color greenShadow = Color.fromRGBO(30, 209, 2, 0.24); // 24%
  static const Color greenBackground =
      Color.fromRGBO(181, 255, 155, 0.36); // 36%

  static const Color orangeIcon = Color.fromRGBO(236, 108, 11, 1);
  static const Color orangeBackground =
      Color.fromRGBO(255, 208, 155, 0.36); // 36%

  static const Color purpleLight = Color.fromRGBO(248, 87, 195, 1);
  static const Color purpleDark = Color.fromRGBO(224, 19, 156, 1);
  static const Color purpleIcon = Color.fromRGBO(209, 2, 99, 1);
  static const Color purpleAccent = Color.fromRGBO(209, 2, 99, 1);
  static const Color purpleShadow = Color.fromRGBO(209, 2, 99, 0.27); // 27%
  static const Color purpleBackground =
      Color.fromRGBO(255, 155, 205, 0.36); // 36%

  static const Color deeppurlpleIcon = Color.fromRGBO(191, 0, 128, 1);
  static const Color deeppurlpleBackground =
      Color.fromRGBO(245, 155, 255, 0.36); // 36%

  static const Color blueLight = Color.fromRGBO(126, 182, 255, 1);
  static const Color blueDark = Color.fromRGBO(95, 135, 231, 1);
  static const Color blueIcon = Color.fromRGBO(9, 172, 206, 1);
  static const Color blueBackground =
      Color.fromRGBO(155, 255, 248, 0.36); // 36%
  static const Color blueShadow = Color.fromRGBO(104, 148, 238, 1);

  static const Color headerBlueLight = Color.fromRGBO(129, 199, 245, 1);
  static const Color headerBlueDark = Color.fromRGBO(56, 103, 213, 1);
  static const Color headerGreyLight =
      Color.fromRGBO(225, 255, 255, 0.31); // 31%

  static const Color yellowIcon = Color.fromRGBO(249, 194, 41, 1);
  static const Color yellowBell = Color.fromRGBO(225, 220, 0, 1);
  static const Color yellowAccent = Color.fromRGBO(255, 213, 6, 1);
  static const Color yellowShadow = Color.fromRGBO(243, 230, 37, 0.27); // 27%
  static const Color yellowBackground =
      Color.fromRGBO(255, 238, 155, 0.36); // 36%

  static const Color bellGrey = Color.fromRGBO(217, 217, 217, 1);
  static const Color bellYellow = Color.fromRGBO(255, 220, 0, 1);

  static const Color trashRed = Color.fromRGBO(251, 54, 54, 1);
  static const Color trashRedBackground = Color.fromRGBO(255, 207, 207, 1);

  static const Color textHeader = Color.fromRGBO(85, 78, 143, 1);
  static const Color textHeaderGrey = Color.fromRGBO(104, 104, 104, 1);
  static const Color textSubHeaderGrey = Color.fromRGBO(161, 161, 161, 1);
  static const Color textSubHeader = Color.fromRGBO(139, 135, 179, 1);
  static const Color textBody = Color.fromRGBO(130, 160, 183, 1);
  static const Color textGrey = Color.fromRGBO(198, 198, 200, 1);
  static const Color textWhite = Color.fromRGBO(243, 243, 243, 1);
  static const Color headerCircle = Color.fromRGBO(255, 255, 255, 0.17);

  static const Color darkMain = Color.fromRGBO(255, 160, 0, 1.0);
  static const Color lightMain = Color.fromRGBO(255, 193, 7, 1.0);
  static const Color light2Main = Color.fromRGBO(255, 214, 0, 1.0);
  static const Color light3Main = Color.fromRGBO(255, 232, 108, 1.0);
  static const Color light4Main = Color.fromRGBO(255, 249, 180, 1.0);
  static const Color darkerMain = Color.fromRGBO(204, 128, 0, 1.0);
  static const Color mintWhite = Color.fromRGBO(245, 255, 250, 1.0);
  static const Color black = Color.fromRGBO(0, 0, 0, 1.0);

  static TextStyle headerText = GoogleFonts.merriweather(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: CustomColors.darkMain,
  );

  static TextStyle header2 = GoogleFonts.ptSans(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: CustomColors.black,
  );
  static TextStyle maintext = GoogleFonts.bebasNeue(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: CustomColors.textHeaderGrey,
  );

  static TextStyle mainstext = GoogleFonts.bebasNeue(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: CustomColors.black,
  );
  static TextStyle htext = GoogleFonts.bebasNeue(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: CustomColors.black,
  );
  static TextStyle usertext = GoogleFonts.arvo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: CustomColors.black,
  );
  static TextStyle emailtext = GoogleFonts.caveat(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: CustomColors.black,
  );

  static TextStyle buttext = GoogleFonts.inconsolata(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: CustomColors.black,
  );

  static TextStyle headtext = GoogleFonts.arvo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: CustomColors.black,
  );
  static TextStyle disctext = GoogleFonts.kaushanScript(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: CustomColors.textHeaderGrey,
  );

  static TextStyle datetext = GoogleFonts.marcellus(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: CustomColors.black,
  );

  static TextStyle chattext = GoogleFonts.roboto(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: CustomColors.black,
  );
}
