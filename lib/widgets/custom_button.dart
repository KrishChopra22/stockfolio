import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.text, required this.onPressed, super.key});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 15,horizontal: 20), // Add padding here
          ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
