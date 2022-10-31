import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';

class DigitIconCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const DigitIconCard({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DigitCard(
      onPressed: onPressed,
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: onPressed == null
                  ? theme.disabledColor
                  : theme.colorScheme.secondary,
              size: 30,
            ),
            const SizedBox(height: 24),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
