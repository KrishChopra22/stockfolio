import 'package:flutter/material.dart';

import '../utils/Colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hintText,
    this.icon,
    required this.inputType,
    required this.maxLines,
    required this.controller,
    required this.labelText,
    this.onChangedFunction,
    this.isEnabled,
    super.key,
  });
  final String hintText;
  final String labelText;
  final IconData? icon;
  final bool? isEnabled;
  final TextInputType inputType;
  final int maxLines;
  final TextEditingController controller;
  final Function(String)? onChangedFunction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        onTapOutside: (PointerDownEvent event) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        showCursor: true,
        onChanged: onChangedFunction,
        cursorColor: AppColors.black,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        enabled: isEnabled,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.blue,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.blue
            ),
          ),
          hintText: hintText,
          labelText: labelText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.grey,
            fontSize: 16,
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: AppColors.blue,
            fontSize: 16,
          ),
          border: InputBorder.none,
          fillColor: Colors.transparent,
          filled: true,
        ),
      ),
    );
  }
}
