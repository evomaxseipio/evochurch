import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EvoCustomTextField extends StatelessWidget {
  const EvoCustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.margin,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.obscureText = false,
    this.onTap,
    this.onSubmitted,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.errorText,
    this.readOnly = false,
    this.onIconTap,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.isNumberOnly = false,
    this.allowDecimals = false,
    this.decimalPlaces = 2,
  });

  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final TextInputAction? textInputAction;
  final String? labelText;
  final String? hintText;
  final FocusNode? focusNode;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? errorText;
  final bool readOnly;
  final void Function()? onIconTap;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final bool isNumberOnly;
  final bool allowDecimals;
  final int decimalPlaces;

  InputDecoration _buildInputDecoration(ThemeData theme) {
    return InputDecoration(
      suffixIconConstraints: const BoxConstraints(minWidth: 30),
      filled: true,
      labelText: labelText,
      hintText: hintText,
      fillColor:
          theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
      hintStyle: theme.inputDecorationTheme.hintStyle ??
          theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      labelStyle: theme.inputDecorationTheme.labelStyle ??
          theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      suffixIcon: suffixIcon,
      errorText: errorText,
      errorStyle: theme.inputDecorationTheme.errorStyle ??
          const TextStyle(fontSize: 14, height: 0.7, color: Colors.red),
      enabledBorder: _buildBorder(
        theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
            theme.colorScheme.outline,
      ),
      focusedBorder: _buildBorder(
        theme.inputDecorationTheme.focusedBorder?.borderSide.color ??
            theme.colorScheme.primary,
      ),
      errorBorder: _buildBorder(
        theme.inputDecorationTheme.errorBorder?.borderSide.color ??
            theme.colorScheme.error,
      ),
      focusedErrorBorder: _buildBorder(
        theme.inputDecorationTheme.focusedErrorBorder?.borderSide.color ??
            theme.colorScheme.error,
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(4),
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (isNumberOnly) {
      return [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ];
    }
    return null;
  }

 /* List<TextInputFormatter>? _getInputFormatters() {
    if (isNumberOnly) {
      if (allowDecimals) {
        return [
          FilteringTextInputFormatter.allow(
              RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = newValue.text;
            if (text.isEmpty) {
              return newValue;
            }
            if (text == '.') {
              return const TextEditingValue(
                text: '0.',
                selection: TextSelection.collapsed(offset: 2),
              );
            }
            // Prevent multiple decimal points
            if (text.contains('.') &&
                text.substring(text.indexOf('.') + 1).contains('.')) {
              return oldValue;
            }
            return newValue;
          }),
        ];
      } else {
        return [
          FilteringTextInputFormatter.digitsOnly,
        ];
      }
    }
    return null;
  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines ?? 1,
      onTap: onTap,
      keyboardType: isNumberOnly
          ? TextInputType.numberWithOptions(decimal: allowDecimals)
          : keyboardType,
      inputFormatters: _getInputFormatters(),
      textCapitalization: textCapitalization,
      cursorColor: theme.colorScheme.primary,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: _buildInputDecoration(theme),
      validator: validator,
      maxLength: maxLength,
      readOnly: readOnly,
    );
  }
}
