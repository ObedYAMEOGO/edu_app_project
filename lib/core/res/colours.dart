import 'package:flutter/material.dart';

class Colours {
  static const gradient = [
    Color(0xff86f3cd),
    Color(0xffffffff),
    Color(0xfff7fdc9)
  ];
  static const subscriptionColours = [
    mathTileColour,
    languageTileColour,
    literatureTileColour,
  ];

  static const subscriptionColoursDarker = [
    Color(0xFFE59995),
    Color(0xFFAADFA4),
    Color(0xFFB191E1),
  ];
  static const primaryColour = Color.fromARGB(255, 2, 82, 201);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 2, 82, 201), // Primary Blue
      Color(0xff00c6ff), // Cyan Accent
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const secondaryColour = Color(0xFF136DD8);
  static const greenColour = Color(0xFF4EB26A);
  static const whiteColour = Color.fromARGB(255, 255, 255, 255);
  static const secondaryWhiteColour = Color.fromARGB(255, 221, 220, 220);
  static const darkColour = Colors.black;
  static const successColor = Color(0xFF4EB26A);
  static const shade = Color.fromARGB(255, 117, 117, 117);

  static const lightGoldenColor = Color(0xFFE6EE9C);
  static const inforThemeColor1 = Color(0xFFD3D5FE);
  static const inforThemeColor2 = Color(0xFFDAFFD6);
  static const inforThemeColor3 = Color(0xFFCFE5FC);
  static const inforThemeColor4 = Color(0xFFFFE4F1);
  static const redColour = Color(0xFFb53c26);
  static const neutralTextColour = Color(0xFF757C8E);
  static const favoriteYellow = Color(0xFFFEC55E);

  /// #F4F5F6
  static const chatFieldColour = Color(0xFFF4F5F6);

  /// #E8E9EA
  static const chatFieldColourDarker = Color(0xFFE8E9EA);

  static const currentUserChatBubbleColour = Color(0xFF293241);

  static const otherUserChatBubbleColour = Color(0xFFEEEEEE);

  static const currentUserChatBubbleColourDarker = Color(0xFF293241);

  static const otherUserChatBubbleColourDarker = Color(0xFFE0E0E0);

  static const physicsTileColour = Color(0xFFD3D5FE);

  /// #FFEFDA
  static const scienceTileColour = Color(0xFFFFEFDA);

  /// #FFE4F1
  static const chemistryTileColour = Color(0xFFFFE4F1);

  /// #CFE5FC
  static const biologyTileColour = Color(0xFFCFE5FC);

  /// #FFCECA
  static const mathTileColour = Color(0xFFFFCECA);

  /// #DAFFD6
  static const languageTileColour = Color(0xFFDAFFD6);

  /// #D5BEFB
  static const literatureTileColour = Color(0xFFD5BEFB);
}
