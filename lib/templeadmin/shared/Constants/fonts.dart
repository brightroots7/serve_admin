import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle poppinsFont(textStyle) {
    return GoogleFonts.poppins(textStyle: textStyle);
  }

  static TextStyle aliceFont(textStyle) {
    return GoogleFonts.alice(textStyle: textStyle);
  }

  static TextStyle ubuntuFont(textStyle) {
    return GoogleFonts.ubuntu(textStyle: textStyle);
  }
}
