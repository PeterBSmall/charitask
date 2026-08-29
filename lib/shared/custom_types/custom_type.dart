import 'package:flutter/material.dart';

class CustomType {
  final String id;
  final String name;
  final String? description;
  final String category;
  final IconData icon;

  const CustomType({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.icon,
  });
}
