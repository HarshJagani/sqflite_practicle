import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
       this.text,
      required this.controller,
      required this.fieldNmae,
      this.ontap,
      this.prefixIcon,
       this.reanOnly = false,  this.enabled = true
       });
  final String? text;
  final TextEditingController controller;
  final String fieldNmae;
  final VoidCallback? ontap;
  final Widget? prefixIcon;
  final bool reanOnly;
  final bool enabled;

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
        enabled: enabled,
        readOnly: reanOnly,
        validator: (value) => validateEmptytext(fieldNmae, value),
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintText: text,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            )),
            onTap: ontap,
      ),
    );
  }
}
