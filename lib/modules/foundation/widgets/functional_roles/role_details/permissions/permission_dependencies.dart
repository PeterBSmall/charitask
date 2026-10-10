import '../../../../domain/models/permission.dart';

class PermissionDependencies {
  const PermissionDependencies._();

  static bool requiresView(Permission permission) {
    final action = actionFor(permission);

    return action == 'create' ||
        action == 'edit' ||
        action == 'delete' ||
        action == 'manage';
  }

  static String actionFor(Permission permission) {
    final parts = permission.key.split('.');

    return parts.isEmpty ? permission.key : parts.last;
  }

  static Permission? findViewPermission({
    required Permission permission,
    required List<Permission> permissions,
  }) {
    for (final candidate in permissions) {
      if (candidate.module == permission.module &&
          actionFor(candidate) == 'view') {
        return candidate;
      }
    }

    return null;
  }

  static List<Permission> findDependents({
    required Permission viewPermission,
    required List<Permission> permissions,
    required Set<String> selectedIds,
  }) {
    return permissions.where((permission) {
      if (permission.module != viewPermission.module) {
        return false;
      }

      return requiresView(permission) && selectedIds.contains(permission.id);
    }).toList();
  }
}
