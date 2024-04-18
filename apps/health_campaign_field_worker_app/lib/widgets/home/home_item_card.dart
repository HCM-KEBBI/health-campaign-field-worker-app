import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';

import '../../blocs/localization/app_localization.dart';

class HomeItemCard extends StatelessWidget {
  final IconData icon;
  final String customIcon;
  final String label;
  final VoidCallback? onPressed;
  final bool enableCustomIcon;

  const HomeItemCard({
    required this.icon,
    required this.label,
    this.enableCustomIcon = false,
    this.customIcon = "",
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DigitCard(
      onPressed: onPressed,
      padding: const EdgeInsets.all(kPadding / 2).copyWith(top: kPadding * 3),
      margin: const EdgeInsets.all(kPadding),
      child: Align(
        alignment: Alignment.center,
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
              AppLocalizations.of(context).translate(
                label,
              ),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
