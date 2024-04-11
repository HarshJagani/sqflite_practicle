import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key, required this.text,required this.controller,required this.fieldNmae});
  final String text;
 final TextEditingController controller;
 final String fieldNmae;

static String? validateEmptytext(String? fieldNmae, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldNmae is reqired.';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        validator: (value) => validateEmptytext(fieldNmae, value),
        controller: controller,
        decoration: InputDecoration(
            hintText: text,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            )),
      ),
    );
  }
}
