enum InvitationRecipientType { existingPerson, newPerson }

extension InvitationRecipientTypeExtension on InvitationRecipientType {
  String get label {
    switch (this) {
      case InvitationRecipientType.existingPerson:
        return 'Existing Person';
      case InvitationRecipientType.newPerson:
        return 'New Person';
    }
  }

  String get description {
    switch (this) {
      case InvitationRecipientType.existingPerson:
        return 'Invite someone who already has a ChariTask account.';
      case InvitationRecipientType.newPerson:
        return 'Invite someone who does not yet have a ChariTask account.';
    }
  }
}
