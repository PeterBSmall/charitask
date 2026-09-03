import 'package:flutter/material.dart';
import 'package:charitask/platform/people/person.dart';
import 'package:charitask/domain/identity/organization_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Controls the first-time ChariTask account onboarding journey.
///
/// This controller is intentionally separate from the organization
/// onboarding controller (CTJourneyController).
///
/// Account onboarding establishes the individual first.
/// Organization setup happens afterward.
class OnboardingController extends ChangeNotifier {
  Person? person;

  bool emailVerified = false;
  OrganizationRole? organizationRole;

  /// Updates the person's basic identity information.
  void updatePerson({
    String? firstName,
    String? lastName,
    String? preferredName,
    String? pronouns,
    String? email,
    String? phone,
    String? photoPath,
  }) {
    if (person == null) {
      return;
    }

    person = person!.copyWith(
      firstName: firstName,
      lastName: lastName,
      preferredName: preferredName,
      pronouns: pronouns,
      email: email,
      phone: phone,
      photoPath: photoPath,
    );

    notifyListeners();
  }

  /// Creates the in-memory person during account creation.
  ///
  /// The permanent ChariTask ID will be assigned when the person
  /// is actually created/persisted.
  void createPersonDraft({
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
  }) {
    // Temporary placeholder only while the account is being created.
    // This is replaced with the real ChariTask ID when persisted.
    person = Person(
      id: '',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );

    notifyListeners();
  }

  /// Restores the in-memory person from the authenticated Supabase user.
  ///
  /// Used when an existing Auth account signs in before the ChariTask
  /// Person has been provisioned.
  void loadAuthenticatedPerson() {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

    final metadata = user.userMetadata ?? {};

    final firstName = (metadata['first_name'] as String?)?.trim() ?? '';
    final lastName = (metadata['last_name'] as String?)?.trim() ?? '';
    final phone = (metadata['phone'] as String?)?.trim();

    person = Person(
      id: '',
      firstName: firstName,
      lastName: lastName,
      email: user.email?.trim(),
      phone: phone?.isEmpty == true ? null : phone,
    );

    notifyListeners();
  }

  /// Resends the email verification message for the current person.
  Future<void> resendVerificationEmail() async {
    final email = person?.email?.trim();

    if (email == null || email.isEmpty) {
      throw const AuthException(
        'We could not find an email address for this account.',
      );
    }

    await Supabase.instance.client.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  /// Marks the person's email as verified.
  void markEmailVerified() {
    emailVerified = true;
    notifyListeners();
  }

  /// Stores the person's organizational role selected during onboarding.
  void setOrganizationRole(OrganizationRole role) {
    organizationRole = role;
    notifyListeners();
  }

  /// Clears the onboarding state.
  void reset() {
    person = null;
    emailVerified = false;
    organizationRole = null;
    notifyListeners();
  }
}
