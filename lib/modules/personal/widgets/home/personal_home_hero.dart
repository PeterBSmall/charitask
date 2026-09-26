import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/personal/data/hero_images/hero_image.dart';
import 'package:charitask/modules/personal/data/hero_images/hero_image_library.dart';
import 'package:charitask/modules/personal/data/services/personal_preferences_service.dart';

class PersonalHomeHero extends StatefulWidget {
  const PersonalHomeHero({super.key});

  @override
  State<PersonalHomeHero> createState() => _PersonalHomeHeroState();
}

class _PersonalHomeHeroState extends State<PersonalHomeHero> {
  final PersonalPreferencesService _preferencesService =
      PersonalPreferencesService();

  HeroImage _selectedImage = HeroImageLibrary.defaultImage;
  bool _isHoveringHero = false;

  @override
  void initState() {
    super.initState();
    _loadSavedHeroImage();
  }

  Future<void> _loadSavedHeroImage() async {
    final heroImageId = await _preferencesService.getHeroImageId();

    if (!mounted || heroImageId == null) {
      return;
    }

    HeroImage? savedImage;

    for (final image in HeroImageLibrary.all) {
      if (image.id == heroImageId) {
        savedImage = image;
        break;
      }
    }

    if (savedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = savedImage!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstName =
        Supabase.instance.client.auth.currentUser?.userMetadata?['first_name']
            as String? ??
        'Peter';

    return Container(
      height: 300,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_selectedImage.assetPath, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.45)),

          // Hero content
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 500;
              final veryNarrow = constraints.maxWidth < 400;

              return Padding(
                padding: EdgeInsets.all(
                  veryNarrow
                      ? 20
                      : narrow
                      ? 24
                      : 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (!veryNarrow) const Spacer(),

                    Text(
                      'GOOD MORNING,',
                      style: TextStyle(
                        fontSize: veryNarrow
                            ? 10
                            : narrow
                            ? 12
                            : 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: veryNarrow ? 1.2 : 1.8,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: veryNarrow ? 1 : 4),

                    Text(
                      firstName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: veryNarrow
                            ? 26
                            : narrow
                            ? 33
                            : 36,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: veryNarrow ? 3 : 8),

                    Text(
                      'Welcome to your ChariTask personal home.',
                      maxLines: veryNarrow ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: veryNarrow
                            ? 11
                            : narrow
                            ? 14
                            : 15,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(
                      height: veryNarrow
                          ? 8
                          : narrow
                          ? 16
                          : 28,
                    ),

                    Wrap(
                      spacing: veryNarrow ? 6 : 12,
                      runSpacing: veryNarrow ? 4 : 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _HeroSummaryItem(
                          icon: Icons.calendar_today_outlined,
                          value: '4',
                          label: "Today's Schedule",
                          compact: veryNarrow,
                        ),

                        if (!veryNarrow) const _HeroSummaryDivider(),

                        _HeroSummaryItem(
                          icon: Icons.check_circle_outline_rounded,
                          value: '7',
                          label: 'Active Tasks',
                          compact: veryNarrow,
                        ),

                        if (!veryNarrow) const _HeroSummaryDivider(),

                        _HeroSummaryItem(
                          icon: Icons.event_outlined,
                          value: '3',
                          label: 'Upcoming Events',
                          compact: veryNarrow,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Customize button hover zone
          Positioned(
            top: 12,
            right: 12,
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveringHero = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveringHero = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: AnimatedOpacity(
                  opacity: _isHoveringHero ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: IgnorePointer(
                    ignoring: !_isHoveringHero,
                    child: _CustomizeButton(
                      onPressed: () => _showHeroCustomizer(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showHeroCustomizer(BuildContext context) async {
    final selected = await showDialog<HeroImage>(
      context: context,
      builder: (context) {
        return _HeroCustomizerDialog(selectedImage: _selectedImage);
      },
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _selectedImage = selected;
    });

    await _preferencesService.saveHeroImageId(selected.id);
  }
}

class _CustomizeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CustomizeButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.28),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image_outlined, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Customize',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool compact;

  const _HeroSummaryItem({
    required this.icon,
    required this.value,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: compact ? 20 : 24, color: Colors.white),
        SizedBox(width: compact ? 6 : 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: compact ? 20 : 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 10 : 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroSummaryDivider extends StatelessWidget {
  const _HeroSummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white.withValues(alpha: 0.30),
    );
  }
}

class _HeroCustomizerDialog extends StatefulWidget {
  final HeroImage selectedImage;

  const _HeroCustomizerDialog({required this.selectedImage});

  @override
  State<_HeroCustomizerDialog> createState() => _HeroCustomizerDialogState();
}

class _HeroCustomizerDialogState extends State<_HeroCustomizerDialog> {
  late HeroImage _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customize Your Hero',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF273247),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Choose an image for your Personal Home.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final category in HeroImageCategory.values) ...[
                        _CategoryHeading(category: category),
                        const SizedBox(height: 10),
                        _buildCategoryGrid(category),
                        const SizedBox(height: 22),
                      ],
                    ],
                  ),
                ),
              ),
              const Divider(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6547E8),
                    ),
                    onPressed: () {
                      Navigator.pop(context, _selectedImage);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(HeroImageCategory category) {
    final images = HeroImageLibrary.byCategory(category);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 3 : 2;
        const spacing = 12.0;

        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final image in images)
              SizedBox(
                width: width,
                child: _HeroImageOption(
                  image: image,
                  selected: _selectedImage.id == image.id,
                  onTap: () {
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryHeading extends StatelessWidget {
  final HeroImageCategory category;

  const _CategoryHeading({required this.category});

  @override
  Widget build(BuildContext context) {
    return Text(
      _categoryName(category),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF273247),
      ),
    );
  }

  String _categoryName(HeroImageCategory category) {
    switch (category) {
      case HeroImageCategory.community:
        return 'Community';
      case HeroImageCategory.mission:
        return 'Mission';
      case HeroImageCategory.nature:
        return 'Nature & Hope';
      case HeroImageCategory.seasonal:
        return 'Seasonal';
    }
  }
}

class _HeroImageOption extends StatelessWidget {
  final HeroImage image;
  final bool selected;
  final VoidCallback onTap;

  const _HeroImageOption({
    required this.image,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? image.accentColor : const Color(0xFFE2E8F0),
              width: selected ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2.4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(image.assetPath, fit: BoxFit.cover),
                    if (selected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: image.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  image.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF273247),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
