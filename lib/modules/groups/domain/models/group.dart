enum GroupType {
  team,
  committee,
  department,
  cohort,
  participantGroup,
  leadershipTeam,
  staffGroup,
  volunteerGroup,
  board,
  donorCircle,
  ministry;

  String get value {
    switch (this) {
      case GroupType.team:
        return 'team';
      case GroupType.committee:
        return 'committee';
      case GroupType.department:
        return 'department';
      case GroupType.cohort:
        return 'cohort';
      case GroupType.participantGroup:
        return 'participant_group';
      case GroupType.leadershipTeam:
        return 'leadership_team';
      case GroupType.staffGroup:
        return 'staff_group';
      case GroupType.volunteerGroup:
        return 'volunteer_group';
      case GroupType.board:
        return 'board';
      case GroupType.donorCircle:
        return 'donor_circle';
      case GroupType.ministry:
        return 'ministry';
    }
  }

  String get label {
    switch (this) {
      case GroupType.team:
        return 'Team';
      case GroupType.committee:
        return 'Committee';
      case GroupType.department:
        return 'Department';
      case GroupType.cohort:
        return 'Cohort';
      case GroupType.participantGroup:
        return 'Participant Group';
      case GroupType.leadershipTeam:
        return 'Leadership Team';
      case GroupType.staffGroup:
        return 'Staff Group';
      case GroupType.volunteerGroup:
        return 'Volunteer Group';
      case GroupType.board:
        return 'Board';
      case GroupType.donorCircle:
        return 'Donor Circle';
      case GroupType.ministry:
        return 'Ministry';
    }
  }

  static GroupType? fromValue(String? value) {
    switch (value) {
      case 'team':
        return GroupType.team;
      case 'committee':
        return GroupType.committee;
      case 'department':
        return GroupType.department;
      case 'cohort':
        return GroupType.cohort;
      case 'participant_group':
        return GroupType.participantGroup;
      case 'leadership_team':
        return GroupType.leadershipTeam;
      case 'staff_group':
        return GroupType.staffGroup;
      case 'volunteer_group':
        return GroupType.volunteerGroup;
      case 'board':
        return GroupType.board;
      case 'donor_circle':
        return GroupType.donorCircle;
      case 'ministry':
        return GroupType.ministry;
      default:
        return null;
    }
  }
}

enum GroupOwnerType {
  organization,
  program,
  location,
  event,
  project;

  String get value {
    switch (this) {
      case GroupOwnerType.organization:
        return 'organization';
      case GroupOwnerType.program:
        return 'program';
      case GroupOwnerType.location:
        return 'location';
      case GroupOwnerType.event:
        return 'event';
      case GroupOwnerType.project:
        return 'project';
    }
  }

  String get label {
    switch (this) {
      case GroupOwnerType.organization:
        return 'Organization';
      case GroupOwnerType.program:
        return 'Program';
      case GroupOwnerType.location:
        return 'Location';
      case GroupOwnerType.event:
        return 'Event';
      case GroupOwnerType.project:
        return 'Project';
    }
  }

  static GroupOwnerType? fromValue(String? value) {
    switch (value) {
      case 'organization':
        return GroupOwnerType.organization;
      case 'program':
        return GroupOwnerType.program;
      case 'location':
        return GroupOwnerType.location;
      case 'event':
        return GroupOwnerType.event;
      case 'project':
        return GroupOwnerType.project;
      default:
        return null;
    }
  }
}

enum GroupVisibility {
  public,
  private,
  hidden;

  String get value {
    switch (this) {
      case GroupVisibility.public:
        return 'public';
      case GroupVisibility.private:
        return 'private';
      case GroupVisibility.hidden:
        return 'hidden';
    }
  }

  String get label {
    switch (this) {
      case GroupVisibility.public:
        return 'Public';
      case GroupVisibility.private:
        return 'Private';
      case GroupVisibility.hidden:
        return 'Hidden';
    }
  }

  static GroupVisibility fromValue(String? value) {
    switch (value) {
      case 'public':
        return GroupVisibility.public;
      case 'hidden':
        return GroupVisibility.hidden;
      case 'private':
      default:
        return GroupVisibility.private;
    }
  }
}

enum GroupMembershipType {
  volunteers,
  staff,
  participants;

  String get value {
    switch (this) {
      case GroupMembershipType.volunteers:
        return 'volunteers';
      case GroupMembershipType.staff:
        return 'staff';
      case GroupMembershipType.participants:
        return 'participants';
    }
  }

  String get label {
    switch (this) {
      case GroupMembershipType.volunteers:
        return 'Volunteers';
      case GroupMembershipType.staff:
        return 'Staff';
      case GroupMembershipType.participants:
        return 'Participants';
    }
  }

  static GroupMembershipType? fromValue(String? value) {
    switch (value) {
      case 'volunteers':
        return GroupMembershipType.volunteers;
      case 'staff':
        return GroupMembershipType.staff;
      case 'participants':
        return GroupMembershipType.participants;
      default:
        return null;
    }
  }
}

class Group {
  final String id;
  final String organizationId;
  final String name;
  final String? description;
  final GroupType? groupType;
  final GroupOwnerType? ownerType;
  final String? ownerId;
  final List<GroupMembershipType> membershipComposition;
  final String? locationId;
  final String status;
  final GroupVisibility visibility;
  final int memberCount;
  final String? createdByPersonId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String color;
  final bool isActive;
  final List<String> tags;

  const Group({
    required this.id,
    required this.organizationId,
    required this.name,
    this.description,
    this.groupType,
    this.ownerType,
    this.ownerId,
    this.membershipComposition = const [],
    this.locationId,
    this.status = 'active',
    this.visibility = GroupVisibility.private,
    this.memberCount = 0,
    this.createdByPersonId,
    this.createdAt,
    this.updatedAt,
    this.color = '#06B6D4',
    this.isActive = true,
    this.tags = const [],
  });

  Group copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? description,
    GroupType? groupType,
    GroupOwnerType? ownerType,
    String? ownerId,
    List<GroupMembershipType>? membershipComposition,
    String? locationId,
    String? status,
    GroupVisibility? visibility,
    int? memberCount,
    String? createdByPersonId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? color,
    bool? isActive,
    List<String>? tags,
  }) {
    return Group(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description ?? this.description,
      groupType: groupType ?? this.groupType,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      membershipComposition:
          membershipComposition ?? this.membershipComposition,
      locationId: locationId ?? this.locationId,
      status: status ?? this.status,
      visibility: visibility ?? this.visibility,
      memberCount: memberCount ?? this.memberCount,
      createdByPersonId: createdByPersonId ?? this.createdByPersonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
    );
  }
}
