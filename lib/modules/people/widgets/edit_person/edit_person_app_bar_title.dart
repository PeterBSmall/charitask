import 'package:flutter/material.dart';

class EditPersonAppBarTitle extends StatelessWidget {
  const EditPersonAppBarTitle({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        firstNameController,
        lastNameController,
        preferredNameController,
      ]),
      builder: (context, _) {
        final preferredName = preferredNameController.text.trim();
        final firstName = firstNameController.text.trim();
        final lastName = lastNameController.text.trim();

        final givenName = preferredName.isNotEmpty ? preferredName : firstName;

        final displayName = '$givenName $lastName'.trim();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName.isEmpty ? 'Edit Person' : displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Edit Person Profile',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }
}
