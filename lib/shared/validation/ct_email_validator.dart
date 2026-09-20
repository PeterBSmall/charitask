class CTEmailValidator {
  const CTEmailValidator._();

  /// Returns a validation message or null when valid.
  ///
  /// Email is optional by default. A blank value is valid unless
  /// [required] is true.
  static String? validate(String? value, {bool required = false}) {
    final email = (value ?? '').trim();

    if (email.isEmpty) {
      return required ? 'Enter an email address' : null;
    }

    if (!isValid(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Returns true when [email] matches ChariTask's basic email rule.
  static bool isValid(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }
}
