import 'package:flutter/material.dart';

class PeopleTable extends StatefulWidget {
  final List<Map<String, dynamic>> people;

  const PeopleTable({super.key, required this.people});

  @override
  State<PeopleTable> createState() => _PeopleTableState();
}

class _PeopleTableState extends State<PeopleTable> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  String _initials(Map<String, dynamic> person) {
    final firstName = (person['first_name'] as String?)?.trim() ?? '';
    final lastName = (person['last_name'] as String?)?.trim() ?? '';

    final firstInitial = firstName.isNotEmpty
        ? firstName.substring(0, 1).toUpperCase()
        : '';

    final lastInitial = lastName.isNotEmpty
        ? lastName.substring(0, 1).toUpperCase()
        : '';

    final initials = '$firstInitial$lastInitial';

    return initials.isEmpty ? '?' : initials;
  }

  String _fullName(Map<String, dynamic> person) {
    final firstName = (person['first_name'] as String?)?.trim() ?? '';
    final lastName = (person['last_name'] as String?)?.trim() ?? '';

    return '$firstName $lastName'.trim();
  }

  String _displayValue(dynamic value) {
    if (value == null) return '—';

    final text = value.toString().trim();

    return text.isEmpty ? '—' : text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PeopleTableHeader(),

                  const Divider(height: 1),

                  if (widget.people.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No people found.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7B8494),
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(widget.people.length, (index) {
                      final person = widget.people[index];

                      final status = _displayValue(person['status']);

                      return Column(
                        children: [
                          _PeopleRow(
                            initials: _initials(person),
                            name: _fullName(person),
                            email: _displayValue(person['email']),
                            role: _displayValue(person['role']),
                            groups: _displayValue(person['groups']),
                            locations: _displayValue(person['locations']),
                            status: status,
                            phone: _displayValue(person['phone']),
                            lastActive: '—',
                          ),

                          if (index < widget.people.length - 1)
                            const Divider(height: 1),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PeopleTableHeader extends StatelessWidget {
  const _PeopleTableHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 58,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(width: 250, child: _HeaderText('NAME')),
            SizedBox(width: 120, child: _HeaderText('ROLE')),
            SizedBox(width: 120, child: _HeaderText('GROUP(S)')),
            SizedBox(width: 120, child: _HeaderText('LOCATION(S)')),
            SizedBox(width: 100, child: _HeaderText('STATUS')),
            SizedBox(width: 150, child: _HeaderText('PHONE')),
            SizedBox(width: 110, child: _HeaderText('LAST ACTIVE')),
          ],
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}

class _PeopleRow extends StatelessWidget {
  final String initials;
  final String name;
  final String email;
  final String role;
  final String groups;
  final String locations;
  final String status;
  final String phone;
  final String lastActive;

  const _PeopleRow({
    required this.initials,
    required this.name,
    required this.email,
    required this.role,
    required this.groups,
    required this.locations,
    required this.status,
    required this.phone,
    required this.lastActive,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF5F8D63);

      case 'inactive':
        return const Color(0xFF6B7280);

      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              width: 250,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFEDE9FE),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF5B4BC4),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'Unnamed person' : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2F3A4A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7B8494),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 120, child: _CellText(role)),

            SizedBox(width: 120, child: _CellText(groups)),

            SizedBox(width: 120, child: _CellText(locations)),

            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _StatusBadge(label: status, color: _statusColor),
              ),
            ),

            SizedBox(width: 150, child: _CellText(phone)),

            SizedBox(width: 110, child: _CellText(lastActive)),
          ],
        ),
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;

  const _CellText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
