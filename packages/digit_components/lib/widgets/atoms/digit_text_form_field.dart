import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DigitTextFormField extends StatelessWidget {
  final bool readOnly;
  final String formControlName;
  final String? hint;
  final Widget? suffix;
  final bool isRequired;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool obscureText;
  final String label;
  final int? minLength;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final ControlValueAccessor<dynamic, String>? valueAccessor;
  final Map<String, String Function(Object control)>? validationMessages;
  final ValueChanged<String>? onChanged;

  const DigitTextFormField({
    super.key,
    required this.label,
    required this.formControlName,
    this.hint,
    this.suffix,
    this.minLines = 1,
    this.maxLines = 1,
    this.valueAccessor,
    this.maxLength,
    this.onTap,
    this.focusNode,
    this.validationMessages,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.obscureText = false,
    this.isRequired = false,
    this.readOnly = false,
    this.minLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => LabeledField(
        label: '$label ${isRequired ? '*' : ''}',
        child: ReactiveTextField(
          readOnly: readOnly,
          formControlName: formControlName,
          maxLength: maxLength,
          validationMessages: validationMessages,
          autofocus: false,
          textCapitalization: textCapitalization,
          minLines: minLines,
          maxLines: maxLines,
          obscureText: obscureText,
          focusNode: focusNode,
          keyboardType: keyboardType,
          valueAccessor: valueAccessor,
          decoration: InputDecoration(
            labelText: hint,
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 48,
              maxWidth: 48,
            ),
            suffixIcon: suffix == null
                ? null
                : InkWell(
                    onTap: onTap,
                    child: suffix,
                  ),
          ),
          onChanged: (control) {
            final value = control.value;
            if (value == null) return;
            onChanged?.call(value);
          }
        ),
      );
}
