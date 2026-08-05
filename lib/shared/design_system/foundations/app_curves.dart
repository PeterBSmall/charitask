import 'package:flutter/material.dart';

/// Standard animation curves used throughout ChariTask.
///
/// These define the "feel" of the application.
/// Components should use these instead of Flutter's
/// built-in curves directly.
class AppCurves {
  AppCurves._();

  /// Default UI animations.
  static const standard = Curves.easeOutCubic;

  /// More noticeable transitions.
  static const emphasized = Curves.easeInOutCubic;

  /// Spring-like animations (checkmarks, selections, etc.).
  static const spring = Curves.easeOutBack;

  /// Gentle fades and subtle movements.
  static const gentle = Curves.easeInOut;
}
