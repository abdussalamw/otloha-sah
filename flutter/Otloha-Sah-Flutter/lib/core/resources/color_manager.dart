import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex('#0087e7');
  static Color darkGrey = HexColor.fromHex('#0095ff');
  static Color grey = HexColor.fromHex('#8F9BB3');
  static Color lightGrey = HexColor.fromHex('#C5CEE0');
  static Color primaryOpacity70 = HexColor.fromHex('#0095FF');

  // new colors
  static Color darkPrimary = HexColor.fromHex('#d17d11');
  static Color grey1 = HexColor.fromHex('#707070');
  static Color grey2 = HexColor.fromHex('#797979');
  static Color white = HexColor.fromHex('#FFFFFF');
  static Color error = HexColor.fromHex('#e61f34');
  static Color black = HexColor.fromHex('#222B45');
  static Color gold = HexColor.fromHex('#ff9d2b');
  static Color red = HexColor.fromHex('#ff2d55');
  static Color appBar = HexColor.fromHex('#F8F8F8');
  static Color inputBackground = HexColor.fromHex('#f4f4f4');
  static Color inputBackground2 = HexColor.fromHex('#3a4057');
  static Color background = HexColor.fromHex('#18203A');

  static Color bnbColor = HexColor.fromHex('#c5cee0');
  static Color bnbActiveColor = HexColor.fromHex('#0095ff');

  static const Color transparent = Colors.transparent;

  static List<Color> buttonBackground = [
    HexColor.fromHex('#0095ff'),
    HexColor.fromHex('#0095FF'),
  ];
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    var color = hexColorString;
    color = color.replaceAll('#', '');
    if (color.length == 6) {
      color = 'FF$color';
    }

    return Color(int.parse(color, radix: 16));
  }
}
