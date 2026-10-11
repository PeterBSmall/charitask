import 'group.dart';

enum CreateGroupTypeOption {
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
  ministry,
}

class CreateGroupDraft {
  CreateGroupTypeOption? groupTypeOption;
  GroupType? groupType;

  String name = '';
  String description = '';

  final Set<String> attributes = {};

  GroupOwnerType? ownerType;
  String? ownerId;

  GroupVisibility visibility = GroupVisibility.private;

  final Set<String> memberIds = {};
  final Map<String, String> memberRoles = {};

  final Set<String> locationIds = {};

  bool get isDefinitionComplete {
    return groupTypeOption != null && name.trim().isNotEmpty;
  }

  void setGroupType(CreateGroupTypeOption option) {
    groupTypeOption = option;

    groupType = switch (option) {
      CreateGroupTypeOption.team => GroupType.team,
      CreateGroupTypeOption.committee => GroupType.committee,
      CreateGroupTypeOption.department => GroupType.department,
      CreateGroupTypeOption.cohort => GroupType.cohort,
      CreateGroupTypeOption.participantGroup => GroupType.participantGroup,
      CreateGroupTypeOption.leadershipTeam => GroupType.leadershipTeam,
      CreateGroupTypeOption.staffGroup => GroupType.staffGroup,
      CreateGroupTypeOption.volunteerGroup => GroupType.volunteerGroup,
      CreateGroupTypeOption.board => GroupType.board,
      CreateGroupTypeOption.donorCircle => GroupType.donorCircle,
      CreateGroupTypeOption.ministry => GroupType.ministry,
    };
  }

  void reset() {
    groupTypeOption = null;
    groupType = null;
    name = '';
    description = '';
    attributes.clear();
    ownerType = null;
    ownerId = null;
    visibility = GroupVisibility.private;
    memberIds.clear();
    memberRoles.clear();
    locationIds.clear();
  }
}
