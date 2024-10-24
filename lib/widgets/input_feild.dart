import 'package:flutter/material.dart';

class InputFeild extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final int? maxLines;
  final bool? showBorder;
  final bool? readOnly;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const InputFeild(
      {Key? key,
      this.keyboardType,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      required this.controller,
      this.validator,
      this.maxLines,
      this.suffixIcon,
      this.showBorder = true,
      this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        border: showBorder == true ? const OutlineInputBorder() : null,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
