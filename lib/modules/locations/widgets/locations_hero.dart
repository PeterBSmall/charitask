import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/design_system.dart';

class LocationsHero extends StatelessWidget {
  final bool canCreate;
  final VoidCallback onAddLocation;

  const LocationsHero({
    super.key,
    required this.canCreate,
    required this.onAddLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 1050;

          return Container(
            height: compact ? 220 : 170,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF6848D8), Color(0xFF7B55E8)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: compact
                ? _buildCompactHero(context)
                : _buildDesktopHero(context),
          );
        },
      ),
    );
  }

  Widget _buildDesktopHero(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 40,
          bottom: -18,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Icon(Icons.home_work_rounded, size: 130, color: Colors.white),
                  SizedBox(width: 8),
                  Icon(Icons.home_rounded, size: 105, color: Colors.white),
                  SizedBox(width: 8),
                  Icon(Icons.home_work_rounded, size: 115, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              _buildIcon(),

              const SizedBox(width: 18),

              Expanded(
                child: _buildTextContent(
                  titleFontSize: 28,
                  descriptionMaxWidth: 680,
                ),
              ),

              const SizedBox(width: 18),

              Container(
                height: 76,
                width: 1,
                color: Colors.white.withValues(alpha: 0.45),
              ),

              const SizedBox(width: 18),

              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'People',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Places',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Greater Impact',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 24),

              _buildAddButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactHero(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Stack(
        children: [
          // Keep the decorative artwork out of the compact layout.
          // This prevents it from competing with the text at narrow widths.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIcon(size: 56),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      'Organizational Locations',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.display.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    'Manage the permanent places where your organization operates, provides services, stores resources, or regularly conducts activities.',
                    style: AppTypography.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(alignment: Alignment.centerRight, child: _buildAddButton()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon({double size = 64}) {
    final iconSize = size * 0.59;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(size >= 64 ? 16 : 14),
      ),
      child: Icon(
        Icons.location_on_rounded,
        size: iconSize,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextContent({
    required double titleFontSize,
    required double descriptionMaxWidth,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organizational Locations',
          style: AppTypography.display.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: titleFontSize,
          ),
        ),
        const SizedBox(height: 7),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: descriptionMaxWidth),
          child: Text(
            'Manage the permanent places where your organization operates, provides services, stores resources, or regularly conducts activities.',
            style: AppTypography.body.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return FilledButton.icon(
      onPressed: canCreate ? onAddLocation : null,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF6246D5),
        disabledBackgroundColor: Colors.white.withValues(alpha: 0.45),
        disabledForegroundColor: const Color(
          0xFF6246D5,
        ).withValues(alpha: 0.55),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      icon: const Icon(Icons.add, size: 20),
      label: const Text(
        'Add Location',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
