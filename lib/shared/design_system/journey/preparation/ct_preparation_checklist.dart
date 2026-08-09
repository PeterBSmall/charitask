import 'package:flutter/material.dart';

import 'ct_preparation_task.dart';

class CTPreparationChecklist extends StatelessWidget {
  final List<CTPreparationTask> tasks;

  const CTPreparationChecklist({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((task) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: task.completed
                    ? const Icon(
                        Icons.check_circle,
                        key: ValueKey(true),
                        color: Color(0xFF6C4CF1),
                        size: 24,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        key: ValueKey(false),
                        color: Colors.grey,
                        size: 24,
                      ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: task.completed
                        ? Colors.black87
                        : Colors.grey.shade700,
                  ),
                  child: Text(task.title),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
