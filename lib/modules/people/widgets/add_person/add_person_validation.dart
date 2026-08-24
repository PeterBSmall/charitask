class AddPersonValidation {
  static bool isBasicInformationValid({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    if (firstName.trim().isEmpty) return false;
    if (lastName.trim().isEmpty) return false;

    final trimmedEmail = email.trim();

    if (trimmedEmail.isNotEmpty && !isValidEmail(trimmedEmail)) {
      return false;
    }

    return true;
  }

  static String? validateConnectionType(String? connectionType) {
    if (connectionType == null) {
      return 'Please choose how this person is connected to your organization.';
    }

    return null;
  }

  static String? validateBasicInformation({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    if (firstName.trim().isEmpty) {
      return 'Please enter a first name.';
    }

    if (lastName.trim().isEmpty) {
      return 'Please enter a last name.';
    }

    final trimmedEmail = email.trim();

    if (trimmedEmail.isNotEmpty && !isValidEmail(trimmedEmail)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
