import 'package:flutter/material.dart';

/// Global animation timings used throughout ChariTask.
/// Keeping these centralized gives the entire app a
/// consistent feel.
class AppMotion {
  AppMotion._();

  static const instant = Duration(milliseconds: 80);
  static const fast = Duration(milliseconds: 140);
  static const normal = Duration(milliseconds: 220);
  static const medium = Duration(milliseconds: 320);
  static const slow = Duration(milliseconds: 450);
  static const hero = Duration(milliseconds: 700);
}
