import 'package:flutter/material.dart';

import 'foundation_sidebar.dart';
import 'package:charitask/shared/widgets/navigation/ct_top_navigation.dart';

class FoundationWorkspaceShell extends StatefulWidget {
  final Widget dashboard;
  final Widget organization;
  final Widget people;
  final Widget groups;
  final Widget security;
  final Widget analytics;
  final Widget notes;

  const FoundationWorkspaceShell({
    super.key,
    required this.dashboard,
    required this.organization,
    required this.people,
    required this.groups,
    required this.security,
    required this.analytics,
    required this.notes,
  });

  @override
  State<FoundationWorkspaceShell> createState() =>
      _FoundationWorkspaceShellState();
}

class _FoundationWorkspaceShellState extends State<FoundationWorkspaceShell> {
  int _selectedIndex = 0;

  // Top navigation selection
  int _topNavIndex = 0;

  Widget get _currentPage {
    switch (_selectedIndex) {
      case 0:
        return widget.dashboard;

      case 1:
        return widget.organization;

      case 2:
        return widget.people;

      case 3:
        return widget.groups;

      case 4:
        return widget.security;

      case 5:
        return widget.analytics;

      case 6:
        return widget.notes;

      default:
        return widget.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          FoundationSidebar(
            selectedIndex: _selectedIndex,
            onSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          Expanded(
            child: Column(
              children: [
                CTTopNavigation(
                  selectedIndex: _topNavIndex,
                  onSelected: (index) {
                    setState(() {
                      _topNavIndex = index;
                    });
                  },
                ),

                Expanded(child: _currentPage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
