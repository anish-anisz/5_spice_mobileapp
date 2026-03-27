import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyle {

  static TextStyle regular(double size, {Color color = Colors.black}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }


  static TextStyle medium(double size, {Color color = Colors.black}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }


  static TextStyle semiBold(double size, {Color color = Colors.black}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }


  static TextStyle bold(double size, {Color color = Colors.black}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  /// POPPINS FONTS -----------------------------

  /// Poppins Regular
  static TextStyle poppinsRegular(double size, {Color color = Colors.black}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  /// Poppins Medium
  static TextStyle poppinsMedium(double size, {Color color = Colors.black}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  /// Poppins Semi-Bold
  static TextStyle poppinsSemiBold(double size, {Color color = Colors.black}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  /// Poppins Bold
  static TextStyle poppinsBold(double size, {Color color = Colors.black}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}