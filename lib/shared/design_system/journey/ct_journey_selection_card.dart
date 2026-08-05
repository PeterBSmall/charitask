import 'package:flutter/material.dart';
import 'package:charitask/shared/design_system/foundations/app_curves.dart';
import 'package:charitask/shared/design_system/foundations/app_motion.dart';

class CTJourneySelectionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const CTJourneySelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  State<CTJourneySelectionCard> createState() => _CTJourneySelectionCardState();
}

class _CTJourneySelectionCardState extends State<CTJourneySelectionCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    final borderColor = (widget.selected || _hovering)
        ? color
        : Colors.grey.shade300;

    final backgroundColor = widget.selected
        ? color.withOpacity(.06)
        : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedSlide(
        duration: AppMotion.fast,
        curve: AppCurves.standard,
        offset: _hovering ? const Offset(0, -.015) : Offset.zero,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: AppMotion.normal,
            curve: AppCurves.standard,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: widget.selected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_hovering ? .06 : .025),
                  blurRadius: _hovering ? 12 : 6,
                  offset: Offset(0, _hovering ? 5 : 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedScale(
                  duration: AppMotion.fast,
                  curve: AppCurves.spring,
                  scale: widget.selected ? 1.12 : (_hovering ? 1.05 : 1.0),
                  child: AnimatedContainer(
                    duration: AppMotion.normal,
                    curve: AppCurves.standard,
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.selected
                          ? color.withOpacity(.12)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      boxShadow: widget.selected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(.20),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedSwitcher(
                      duration: AppMotion.fast,
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: Icon(
                        widget.icon,
                        key: ValueKey(widget.selected),
                        size: 24,
                        color: widget.selected || _hovering
                            ? color
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),

                AnimatedSwitcher(
                  duration: AppMotion.normal,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: AppCurves.spring,
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: widget.selected
                      ? Container(
                          key: const ValueKey('selected'),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(.28),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : const SizedBox(
                          key: ValueKey('empty'),
                          width: 30,
                          height: 30,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
