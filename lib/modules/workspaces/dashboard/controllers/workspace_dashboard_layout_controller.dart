import '../models/workspace_dashboard_module.dart';

class WorkspaceDashboardLayoutController {
  final List<WorkspaceDashboardModule> _modules;

  WorkspaceDashboardLayoutController({
    required List<WorkspaceDashboardModule> modules,
  }) : _modules = List<WorkspaceDashboardModule>.from(modules)
         ..sort((a, b) => a.position.compareTo(b.position));

  List<WorkspaceDashboardModule> get modules =>
      List<WorkspaceDashboardModule>.unmodifiable(_modules);

  List<WorkspaceDashboardModule> get visibleModules =>
      _modules.where((module) => module.visible).toList();

  WorkspaceDashboardModule? findModule(String id) {
    for (final module in _modules) {
      if (module.id == id) {
        return module;
      }
    }

    return null;
  }

  bool isVisible(String id) {
    return findModule(id)?.visible ?? true;
  }

  bool isMovable(String id) {
    return findModule(id)?.isMovable ?? false;
  }

  void setVisibility(String id, bool visible) {
    final index = _modules.indexWhere((module) => module.id == id);

    if (index == -1) {
      return;
    }

    _modules[index] = _modules[index].copyWith(visible: visible);
  }

  void moveModule({required String moduleId, required int newPosition}) {
    final index = _modules.indexWhere((module) => module.id == moduleId);

    if (index == -1) {
      return;
    }

    if (!_modules[index].isMovable) {
      return;
    }

    final module = _modules.removeAt(index);

    final clampedPosition = newPosition.clamp(0, _modules.length);

    _modules.insert(clampedPosition, module);

    _normalizePositions();
  }

  void _normalizePositions() {
    for (var i = 0; i < _modules.length; i++) {
      _modules[i] = _modules[i].copyWith(position: i);
    }
  }

  List<WorkspaceDashboardModule> exportLayout() {
    return List<WorkspaceDashboardModule>.unmodifiable(_modules);
  }
}
