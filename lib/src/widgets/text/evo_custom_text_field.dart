import 'package:flutter/material.dart';

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
    this.maxLines 
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines ?? 1,
      // minLines: 1,
      onTap: onTap,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      cursorColor: theme.colorScheme.primary,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        suffixIconConstraints: const BoxConstraints(minWidth: 30),
        filled: true,
        labelText: labelText,
        hintText: hintText,
        fillColor:theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
        hintStyle: theme.inputDecorationTheme.hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        labelStyle: theme.inputDecorationTheme.labelStyle ??
            theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurface),
        isDense: true,
        contentPadding:const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        suffixIcon: suffixIcon,
        errorText: errorText,
        errorStyle: theme.inputDecorationTheme.errorStyle ??
            TextStyle(fontSize: 14, height: 0.7, color: theme.colorScheme.error),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.focusedBorder?.borderSide.color ??
                theme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.errorBorder?.borderSide.color ??
                theme.colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.focusedErrorBorder?.borderSide
                    .color ??
                theme.colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      validator: validator,
      maxLength: maxLength,
      readOnly: readOnly,
    );
  }
}
