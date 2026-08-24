import 'package:flutter/services.dart';

class AddPersonPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    final limitedDigits = digits.length > 10 ? digits.substring(0, 10) : digits;

    String formatted = '';

    if (limitedDigits.isNotEmpty) {
      formatted = '(';
      formatted += limitedDigits.substring(0, limitedDigits.length.clamp(0, 3));

      if (limitedDigits.length >= 4) {
        formatted += ') ';
        formatted += limitedDigits.substring(
          3,
          limitedDigits.length.clamp(3, 6),
        );
      }

      if (limitedDigits.length >= 7) {
        formatted += '-';
        formatted += limitedDigits.substring(6);
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
