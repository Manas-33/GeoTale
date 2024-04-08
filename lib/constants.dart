import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final backgroundColor = Color.fromARGB(255, 2, 17, 68);
final secondColor = const Color.fromARGB(255, 37, 78, 185);
// final secondColor = Color.fromARGB(255, 41, 210, 210);
TextStyle googleTextStyle(
    double customFontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.openSans(
    textStyle: TextStyle(
      color: color,
      fontSize: customFontSize,
      fontWeight: fontWeight,
    ),
  );
}

TextStyle googleGradientTextStyle(
  double customFontSize,
  FontWeight fontWeight,
  Color color1,
  Color color2,
) {
  return GoogleFonts.openSans(
    textStyle: TextStyle(
      foreground: Paint()
        ..shader = LinearGradient(
          colors: <Color>[color1, color2],
        ).createShader(Rect.fromLTWH(0.0, 0.0, 800.0, 70.0)),
      fontSize: customFontSize,
      fontWeight: fontWeight,
    ),
  );
}
