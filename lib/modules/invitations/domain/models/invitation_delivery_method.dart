enum InvitationDeliveryMethod {
  email,
  textMessage,
  emailAndText,
  invitationLink,
  qrCode,
}

extension InvitationDeliveryMethodExtension on InvitationDeliveryMethod {
  String get label {
    switch (this) {
      case InvitationDeliveryMethod.email:
        return 'Email';
      case InvitationDeliveryMethod.textMessage:
        return 'Text Message';
      case InvitationDeliveryMethod.emailAndText:
        return 'Email + Text';
      case InvitationDeliveryMethod.invitationLink:
        return 'Invitation Link';
      case InvitationDeliveryMethod.qrCode:
        return 'QR Code';
    }
  }
}
