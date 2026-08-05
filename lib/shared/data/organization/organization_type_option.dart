import 'package:flutter/material.dart';

import 'package:charitask/domain/organization/organization_type.dart';

/// Defines one organization type that can be presented during onboarding.
///
/// This model intentionally contains only presentation data.
/// It allows the onboarding experience to be completely data-driven.
class OrganizationTypeOption {
  /// Internal enum value.
  final OrganizationType type;

  /// Icon displayed in the selection card.
  final IconData icon;

  /// Card title.
  final String title;

  /// Card description.
  final String subtitle;

  /// Hero headline displayed on the left panel.
  final String heroTitle;

  /// Hero supporting text displayed beneath the headline.
  final String heroSubtitle;

  final String? imageAsset;

  final Color? accentColor;

  const OrganizationTypeOption({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    this.imageAsset,
    this.accentColor,
  });
}
