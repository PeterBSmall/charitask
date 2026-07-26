import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> small = [
    BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
