import 'group.dart';

enum CreateGroupTypeOption { team, committee, cohort, other }

class CreateGroupDraft {
  CreateGroupTypeOption? groupTypeOption;
  GroupType? groupType;

  String name = '';
  String description = '';

  final Set<String> attributes = {};

  GroupOwnerType? ownerType;
  String? ownerId;

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
      CreateGroupTypeOption.cohort => GroupType.cohort,
      CreateGroupTypeOption.other => null,
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
    memberIds.clear();
    memberRoles.clear();
    locationIds.clear();
  }
}
