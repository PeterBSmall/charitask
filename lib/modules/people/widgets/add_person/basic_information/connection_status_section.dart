import 'package:flutter/material.dart';

class ConnectionStatusSection extends StatelessWidget {
  final String connectionType;
  final String membershipStatus;
  final TextEditingController joinDateController;
  final ValueChanged<String> onMembershipStatusChanged;

  const ConnectionStatusSection({
    super.key,
    required this.connectionType,
    required this.membershipStatus,
    required this.joinDateController,
    required this.onMembershipStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isExternal = connectionType == 'external';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),

        const SizedBox(height: 32),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isExternal ? Icons.handshake_outlined : Icons.badge_outlined,
                color: const Color(0xFF5B3FC4),
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connection to Your Organization',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Set this person’s current status and when their connection began.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Status',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: membershipStatus,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF6B7280),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5B3FC4), width: 2),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'Active', child: Text('Active')),
            DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
            DropdownMenuItem(value: 'Pending', child: Text('Pending')),
          ],
          onChanged: (value) {
            if (value != null) {
              onMembershipStatusChanged(value);
            }
          },
        ),

        const SizedBox(height: 24),

        Text(
          isExternal ? 'Connection Date' : 'Join Date',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: joinDateController,
          readOnly: true,
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (selectedDate != null) {
              joinDateController.text =
                  '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
            }
          },
          decoration: InputDecoration(
            hintText: isExternal
                ? 'Select connection date'
                : 'Select join date',
            prefixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF6B7280),
            ),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF6B7280),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5B3FC4), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
