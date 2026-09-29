import 'invitation_delivery_method.dart';
import 'invitation_recipient_type.dart';
import 'invitation_type.dart';

class CreateInvitationDraft {
  InvitationType? invitationType;
  InvitationRecipientType? recipientType;
  InvitationDeliveryMethod? deliveryMethod;

  final List<String> recipientIds = [];

  String? targetId;

  bool get isInvitationTypeSelected => invitationType != null;

  bool get isRecipientTypeSelected => recipientType != null;

  bool get hasRecipients => recipientIds.isNotEmpty;

  bool get isDeliveryMethodSelected => deliveryMethod != null;

  bool get isComplete =>
      isInvitationTypeSelected &&
      isRecipientTypeSelected &&
      hasRecipients &&
      isDeliveryMethodSelected;

  void reset() {
    invitationType = null;
    recipientType = null;
    deliveryMethod = null;
    recipientIds.clear();
    targetId = null;
  }
}
