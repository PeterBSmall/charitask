import 'package:flutter/material.dart';

class CTOperatingHoursDay {
  final int dayOfWeek;
  final String dayName;
  final bool isOpen;
  final TimeOfDay? opensAt;
  final TimeOfDay? closesAt;

  const CTOperatingHoursDay({
    required this.dayOfWeek,
    required this.dayName,
    this.isOpen = false,
    this.opensAt,
    this.closesAt,
  });

  CTOperatingHoursDay copyWith({
    bool? isOpen,
    TimeOfDay? opensAt,
    TimeOfDay? closesAt,
    bool clearOpensAt = false,
    bool clearClosesAt = false,
  }) {
    return CTOperatingHoursDay(
      dayOfWeek: dayOfWeek,
      dayName: dayName,
      isOpen: isOpen ?? this.isOpen,
      opensAt: clearOpensAt ? null : (opensAt ?? this.opensAt),
      closesAt: clearClosesAt ? null : (closesAt ?? this.closesAt),
    );
  }
}
