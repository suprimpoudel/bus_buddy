import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final bool? obscureText;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String value)? onTextChanged;
  final Function(String value)? onFormSubmitted;
  final String? Function(String?)? validator;
  const CustomTextField(
      {super.key,
      this.hint,
      this.label,
      this.obscureText,
      this.prefix,
      this.prefixIcon,
      this.suffix,
      this.suffixIcon,
      this.keyboardType,
      this.inputAction,
      this.controller,
      this.focusNode,
      this.onTextChanged,
      this.onFormSubmitted,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: inputAction ?? TextInputAction.next,
        onChanged: (value) {
          if (onTextChanged != null) {
            onTextChanged!(value);
          }
        },
        onFieldSubmitted: (value) {
          if (onFormSubmitted != null) {
            onFormSubmitted!(value);
          }
        },
        obscureText: obscureText ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        decoration: InputDecoration(
            hintText: hint,
            label: label != null ? Text(label!) : null,
            prefix: prefix,
            prefixIcon: prefixIcon,
            suffix: suffix,
            suffixIcon: suffixIcon,
            border: const OutlineInputBorder()),
      ),
    );
  }
}
