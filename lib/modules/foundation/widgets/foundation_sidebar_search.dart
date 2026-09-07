import 'package:flutter/material.dart';

class FoundationSidebarSearch extends StatelessWidget {
  const FoundationSidebarSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search anything...',
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF8A94A3)),
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 20,
              color: Color(0xFF667085),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                widthFactor: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F2F6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '⌘ K',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B8494),
                    ),
                  ),
                ),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFD9DDE7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFD9DDE7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFF5B4BC4)),
            ),
          ),
        ),
      ),
    );
  }
}
