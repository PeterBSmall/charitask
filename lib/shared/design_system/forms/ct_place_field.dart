import 'package:flutter/material.dart';
import 'package:charitask/shared/design_system/forms/ct_place_result_card.dart';
import 'package:charitask/shared/models/ct_place.dart';

class CTLocationField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const CTLocationField({super.key, required this.controller, this.onChanged});

  @override
  State<CTLocationField> createState() => _CTLocationFieldState();
}

class _CTLocationFieldState extends State<CTLocationField> {
  final List<String> _allLocations = [
    'Hyannis, MA',
    'Yarmouth, MA',
    'Falmouth, MA',
    'East Falmouth, MA',
    'North Falmouth, MA',
    'Barnstable, MA',
    'Dennis, MA',
    'Mashpee, MA',
    'Sandwich, MA',
    'Bourne, MA',
  ];

  List<String> _results = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_search);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_search);
    super.dispose();
  }

  void _search() {
    final query = widget.controller.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _results = [];
      } else {
        _results = _allLocations
            .where((location) => location.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            hintText: 'Search for an address...',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),

        if (_results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: _results.map((location) {
                return CTPlaceResultCard(
                  place: CTPlace(
                    primary: location,
                    secondary: 'Cape Cod, Massachusetts',
                  ),
                  onTap: () {
                    widget.controller.text = location;

                    widget.onChanged?.call(location);

                    setState(() {
                      _results = [];
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
