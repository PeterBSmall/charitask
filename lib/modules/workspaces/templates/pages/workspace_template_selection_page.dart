import 'package:flutter/material.dart';

import '../data/workspace_template_data.dart';
import '../widgets/workspace_template_card.dart';

class WorkspaceTemplateSelectionPage extends StatefulWidget {
  final ValueChanged<String> onContinue;
  final VoidCallback? onBack;

  const WorkspaceTemplateSelectionPage({
    super.key,
    required this.onContinue,
    this.onBack,
  });

  @override
  State<WorkspaceTemplateSelectionPage> createState() =>
      _WorkspaceTemplateSelectionPageState();
}

class _WorkspaceTemplateSelectionPageState
    extends State<WorkspaceTemplateSelectionPage> {
  String? _selectedTemplate;

  static const Color _purple = Color(0xFF7C4DFF);
  static const Color _darkText = Color(0xFF182230);
  static const Color _secondaryText = Color(0xFF667085);
  static const Color _divider = Color(0xFFE4E7EC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              isCompact ? 24 : 48,
              isCompact ? 24 : 28,
              isCompact ? 24 : 48,
              isCompact ? 28 : 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(),

                    const SizedBox(height: 10),

                    _buildHeader(),

                    const SizedBox(height: 24),

                    _buildCategory(
                      title: 'Mission & Community',
                      icon: Icons.groups_outlined,
                      templates: missionCommunityTemplates,
                      isCompact: isCompact,
                    ),

                    const SizedBox(height: 24),

                    _buildCategory(
                      title: 'Fundraising & Programs',
                      icon: Icons.volunteer_activism_outlined,
                      templates: fundraisingProgramsTemplates,
                      isCompact: isCompact,
                    ),

                    const SizedBox(height: 24),

                    _buildCategory(
                      title: 'People, Resources & Compliance',
                      icon: Icons.shield_outlined,
                      templates: peopleResourcesComplianceTemplates,
                      isCompact: isCompact,
                    ),

                    const SizedBox(height: 24),

                    _buildCategory(
                      title: 'Creative & Flexible',
                      icon: Icons.campaign_outlined,
                      templates: creativeFlexibleTemplates,
                      isCompact: isCompact,
                    ),

                    const SizedBox(height: 20),

                    _buildNavigation(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: widget.onBack,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back_rounded, size: 18, color: _purple),
            SizedBox(width: 6),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse templates',
          style: TextStyle(
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Each template comes with pre-configured tools and settings '
          'to help you get started quickly.',
          style: TextStyle(fontSize: 15, height: 1.4, color: _secondaryText),
        ),
      ],
    );
  }

  Widget _buildCategory({
    required String title,
    required IconData icon,
    required List<WorkspaceTemplate> templates,
    required bool isCompact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 19, color: _purple),
            const SizedBox(width: 9),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: _darkText,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Divider(height: 1, thickness: 1, color: _divider),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTemplateGrid(templates: templates, isCompact: isCompact),
      ],
    );
  }

  Widget _buildTemplateGrid({
    required List<WorkspaceTemplate> templates,
    required bool isCompact,
  }) {
    if (isCompact) {
      return Column(
        children: templates
            .map(
              (template) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: WorkspaceTemplateCard(
                  template: template,
                  isSelected: _selectedTemplate == template.id,
                  onTap: () => _selectTemplate(template.id),
                ),
              ),
            )
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < templates.length; i++) ...[
          Expanded(
            child: WorkspaceTemplateCard(
              template: templates[i],
              isSelected: _selectedTemplate == templates[i].id,
              onTap: () => _selectTemplate(templates[i].id),
            ),
          ),
          if (i < templates.length - 1) const SizedBox(width: 14),
        ],
      ],
    );
  }

  Widget _buildNavigation() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _selectedTemplate == null
            ? null
            : () => widget.onContinue(_selectedTemplate!),
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          disabledBackgroundColor: const Color(0xFFE4E7EC),
          foregroundColor: Colors.white,
          disabledForegroundColor: const Color(0xFF98A2B3),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: const Text(
          'Continue →',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _selectTemplate(String templateId) {
    setState(() {
      _selectedTemplate = templateId;
    });
  }
}
