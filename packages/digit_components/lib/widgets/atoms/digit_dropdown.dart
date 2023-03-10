import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DigitDropdown extends StatelessWidget {
  final String label;
  final String? initialValue;
  final List<MenuItemModel> menuItems;
  final ValueChanged<String?> onChanged;
  final String formControlName;

  const DigitDropdown({
    super.key,
    required this.label,
    required this.menuItems,
    required this.formControlName,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          ReactiveDropdownField(
            formControlName: formControlName,
            items: menuItems.map((e) {
              return DropdownMenuItem(
                value: e.code,
                child: Text(e.name),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class MenuItemModel {
  final String name;
  final String code;

  MenuItemModel(this.name, this.code);
}
