/// Represents a person's ChariTask account.
///
/// A UserAccount controls access to ChariTask.
/// It does not define who the person is or how they
/// relate to an organization.
///
/// The person's permanent ChariTask ID belongs to Person.
class UserAccount {
  /// Whether the account's email has been verified.
  final bool emailVerified;

  /// Whether the account is currently active.
  final bool isActive;

  /// Authentication provider used by the account.
  ///
  /// Examples:
  /// - email
  /// - google
  final String authProvider;

  const UserAccount({
    this.emailVerified = false,
    this.isActive = true,
    this.authProvider = 'email',
  });

  UserAccount copyWith({
    bool? emailVerified,
    bool? isActive,
    String? authProvider,
  }) {
    return UserAccount(
      emailVerified: emailVerified ?? this.emailVerified,
      isActive: isActive ?? this.isActive,
      authProvider: authProvider ?? this.authProvider,
    );
  }
}
