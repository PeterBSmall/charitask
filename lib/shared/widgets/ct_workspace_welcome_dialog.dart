import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:charitask/shared/design_system/foundations/app_colors.dart';

class CTWorkspaceWelcomeFeature {
  final IconData icon;
  final String title;
  final String description;

  const CTWorkspaceWelcomeFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class CTWorkspaceWelcomeDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<CTWorkspaceWelcomeFeature> features;

  final String primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  final String secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  /// Unique key used to remember whether this workspace welcome
  /// has been dismissed permanently.
  final String preferenceKey;

  const CTWorkspaceWelcomeDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.preferenceKey,
    this.primaryActionLabel = "Let's get started",
    this.onPrimaryAction,
    this.secondaryActionLabel = 'Learn more',
    this.onSecondaryAction,
  });

  /// Shows the welcome dialog unless the user has chosen
  /// "Do not show again" for this workspace.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<CTWorkspaceWelcomeFeature> features,
    required String preferenceKey,
    String primaryActionLabel = "Let's get started",
    VoidCallback? onPrimaryAction,
    String secondaryActionLabel = 'Learn more',
    VoidCallback? onSecondaryAction,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final shouldShow = !(prefs.getBool(preferenceKey) ?? false);

    if (!shouldShow || !context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      builder: (context) {
        return CTWorkspaceWelcomeDialog(
          title: title,
          subtitle: subtitle,
          features: features,
          preferenceKey: preferenceKey,
          primaryActionLabel: primaryActionLabel,
          onPrimaryAction: onPrimaryAction,
          secondaryActionLabel: secondaryActionLabel,
          onSecondaryAction: onSecondaryAction,
        );
      },
    );
  }

  @override
  State<CTWorkspaceWelcomeDialog> createState() =>
      _CTWorkspaceWelcomeDialogState();
}

class _CTWorkspaceWelcomeDialogState extends State<CTWorkspaceWelcomeDialog> {
  bool _doNotShowAgain = false;

  Future<void> _close() async {
    if (_doNotShowAgain) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(widget.preferenceKey, true);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _primaryAction() async {
    await _close();

    if (widget.onPrimaryAction != null) {
      widget.onPrimaryAction!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.clamp(320.0, 920.0);

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: constraints.maxHeight,
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6951E8), Color(0xFF5141C9)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.20),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(48, 36, 48, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 28),

                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.16),
                      ),

                      const SizedBox(height: 32),

                      ...[
                        for (int i = 0; i < widget.features.length; i++) ...[
                          _buildFeature(widget.features[i]),

                          if (i != widget.features.length - 1)
                            const SizedBox(height: 24),
                        ],
                      ],

                      const SizedBox(height: 32),

                      _buildActions(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🎉', style: TextStyle(fontSize: 46)),

        const SizedBox(width: 20),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 34,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 19,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.90),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        IconButton(
          onPressed: _close,
          tooltip: 'Close',
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
        ),
      ],
    );
  }

  Widget _buildFeature(CTWorkspaceWelcomeFeature feature) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(feature.icon, color: Colors.white, size: 32),
        ),

        const SizedBox(width: 22),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                feature.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.35,
                  color: Colors.white.withValues(alpha: 0.84),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 620;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPrimaryButton(),

              const SizedBox(height: 18),

              _buildSecondaryButton(),

              const SizedBox(height: 18),

              _buildDoNotShowAgain(),
            ],
          );
        }

        return Row(
          children: [
            _buildPrimaryButton(),

            const SizedBox(width: 32),

            _buildSecondaryButton(),

            const Spacer(),

            _buildDoNotShowAgain(),
          ],
        );
      },
    );
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: _primaryAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.missionPurple,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        widget.primaryActionLabel,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return TextButton(
      onPressed: widget.onSecondaryAction,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.secondaryActionLabel,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),

          const SizedBox(width: 8),

          const Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    );
  }

  Widget _buildDoNotShowAgain() {
    return InkWell(
      onTap: () {
        setState(() {
          _doNotShowAgain = !_doNotShowAgain;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _doNotShowAgain,
            onChanged: (value) {
              setState(() {
                _doNotShowAgain = value ?? false;
              });
            },
            side: const BorderSide(color: Colors.white, width: 2),
            checkColor: AppColors.missionPurple,
            activeColor: Colors.white,
          ),

          const SizedBox(width: 4),

          Text(
            'Do not show again',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}
