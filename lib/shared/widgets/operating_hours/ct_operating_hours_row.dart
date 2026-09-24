import 'package:flutter/material.dart';

class CTOperatingHoursRow extends StatelessWidget {
  final String dayName;
  final bool isOpen;
  final TimeOfDay? opensAt;
  final TimeOfDay? closesAt;
  final ValueChanged<bool> onOpenChanged;
  final VoidCallback onOpenTimeTap;
  final VoidCallback onCloseTimeTap;

  const CTOperatingHoursRow({
    super.key,
    required this.dayName,
    required this.isOpen,
    required this.opensAt,
    required this.closesAt,
    required this.onOpenChanged,
    required this.onOpenTimeTap,
    required this.onCloseTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              dayName,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Switch.adaptive(value: isOpen, onChanged: onOpenChanged),

          SizedBox(
            width: 52,
            child: Text(
              isOpen ? 'Open' : 'Closed',
              style: TextStyle(
                color: isOpen
                    ? const Color(0xFF15803D)
                    : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (isOpen) ...[
            const SizedBox(width: 12),

            Expanded(
              child: _TimeButton(
                value: opensAt,
                placeholder: 'Opening time',
                onTap: onOpenTimeTap,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('—', style: TextStyle(color: Color(0xFF94A3B8))),
            ),

            Expanded(
              child: _TimeButton(
                value: closesAt,
                placeholder: 'Closing time',
                onTap: onCloseTimeTap,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  final TimeOfDay? value;
  final String placeholder;
  final VoidCallback onTap;

  const _TimeButton({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD1D5DB)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.schedule_outlined,
              size: 16,
              color: Color(0xFF64748B),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                value?.format(context) ?? placeholder,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value == null
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF334155),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
