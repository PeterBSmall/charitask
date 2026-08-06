import 'package:flutter/material.dart';

import 'package:charitask/domain/organization/organization_size.dart';

class OrganizationSizeOption {
  final OrganizationSize size;
  final IconData icon;
  final String title;
  final String subtitle;

  const OrganizationSizeOption({
    required this.size,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const organizationSizes = [
  OrganizationSizeOption(
    size: OrganizationSize.startup,
    icon: Icons.rocket_launch_outlined,
    title: 'Just Getting Started',
    subtitle: '1–10 people',
  ),
  OrganizationSizeOption(
    size: OrganizationSize.small,
    icon: Icons.groups_2_outlined,
    title: 'Small Organization',
    subtitle: '11–50 people',
  ),
  OrganizationSizeOption(
    size: OrganizationSize.medium,
    icon: Icons.apartment_outlined,
    title: 'Growing Organization',
    subtitle: '51–250 people',
  ),
  OrganizationSizeOption(
    size: OrganizationSize.large,
    icon: Icons.domain_outlined,
    title: 'Large Organization',
    subtitle: '251–1,000 people',
  ),
  OrganizationSizeOption(
    size: OrganizationSize.enterprise,
    icon: Icons.public_outlined,
    title: 'Enterprise',
    subtitle: '1,000+ people',
  ),
];
