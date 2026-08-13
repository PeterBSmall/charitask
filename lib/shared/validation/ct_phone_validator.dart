class CTPhoneValidator {
  const CTPhoneValidator._();

  /// Removes formatting and returns digits only.
  static String digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  /// Formats a US phone number as:
  /// (555) 555-5555
  static String format(String value) {
    final digits = digitsOnly(value);

    if (digits.isEmpty) {
      return '';
    }

    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;

    if (limited.length <= 3) {
      return '($limited';
    }

    if (limited.length <= 6) {
      return '(${limited.substring(0, 3)}) '
          '${limited.substring(3)}';
    }

    return '(${limited.substring(0, 3)}) '
        '${limited.substring(3, 6)}-'
        '${limited.substring(6)}';
  }

  /// Returns a validation message or null when valid.
  static String? validate(String? value, {bool required = true}) {
    final digits = digitsOnly(value ?? '');

    if (digits.isEmpty) {
      return required ? 'Enter your phone number' : null;
    }

    if (digits.length != 10) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  /// Returns the normalized phone number for storage.
  ///
  /// Example:
  /// (508) 555-1234 → 5085551234
  static String normalize(String value) {
    return digitsOnly(value);
  }
}
