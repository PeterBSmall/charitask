enum InvitationType { organization, workspace, location, program, group, event }

extension InvitationTypeExtension on InvitationType {
  String get label {
    switch (this) {
      case InvitationType.organization:
        return 'Organization';
      case InvitationType.workspace:
        return 'Workspace';
      case InvitationType.location:
        return 'Location';
      case InvitationType.program:
        return 'Program';
      case InvitationType.group:
        return 'Group';
      case InvitationType.event:
        return 'Event';
    }
  }

  String get description {
    switch (this) {
      case InvitationType.organization:
        return 'Invite people to your organization.';
      case InvitationType.workspace:
        return 'Invite people to a workspace.';
      case InvitationType.location:
        return 'Invite people to a location.';
      case InvitationType.program:
        return 'Invite people to a program.';
      case InvitationType.group:
        return 'Invite people to a group.';
      case InvitationType.event:
        return 'Invite people to an event.';
    }
  }
}
