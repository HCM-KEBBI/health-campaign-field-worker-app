import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/digit_theme.dart';

class DigitCheckboxTile extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const DigitCheckboxTile({
    this.value = false,
    required this.label,
    this.onChanged,
    this.padding,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin ?? const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onChanged?.call(!value),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, bottom: kPadding * 2),
          child: Row(
            children: [
              Icon(
                value
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank_sharp,
                color: value
                    ? theme.colorScheme.secondary
                    : const DigitColors().davyGray,
                size: kPadding * 3,
              ),
              const SizedBox(width: kPadding * 2),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
