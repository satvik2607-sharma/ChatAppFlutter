import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField(
      {super.key,
      required this.hintText,
      required this.height,
      required this.validationRegEx,
      this.ObsecureText = false,
      required this.onSaved});
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool ObsecureText;
  final void Function(String?) onSaved;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: ObsecureText,
        validator: (value) {
          if (value != null && validationRegEx.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${hintText.toLowerCase()}";
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
