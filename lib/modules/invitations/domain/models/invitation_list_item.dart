class InvitationListItem {
  const InvitationListItem({
    required this.id,
    required this.name,
    required this.email,
    required this.recipientType,
    required this.invitationType,
    required this.invitedTo,
    required this.accessType,
    required this.assignment,
    required this.status,
    required this.sentAt,
    required this.expiresAt,
  });

  final String id;
  final String name;
  final String email;
  final String recipientType;
  final String invitationType;
  final String invitedTo;
  final String accessType;
  final String assignment;
  final String status;
  final DateTime? sentAt;
  final DateTime? expiresAt;
}
