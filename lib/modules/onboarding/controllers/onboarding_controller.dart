import 'package:flutter/material.dart';
import 'package:charitask/modules/foundation/domain/models/person.dart';

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

  /// Updates the person's basic identity information.
  void updatePerson({
    String? firstName,
    String? lastName,
    String? preferredName,
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

  /// Marks the person's email as verified.
  void markEmailVerified() {
    emailVerified = true;
    notifyListeners();
  }

  /// Clears the onboarding state.
  void reset() {
    person = null;
    emailVerified = false;
    notifyListeners();
  }
}
