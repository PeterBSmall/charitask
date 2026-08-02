import 'package:flutter/material.dart';

import 'ct_journey_constants.dart';

class CTJourneyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CTJourneyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: CTJourneySizes.buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: CTJourneyColors.purple,
          disabledBackgroundColor: CTJourneyColors.purple.withValues(
            alpha: 0.35,
          ),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CTJourneySizes.buttonRadius),
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
