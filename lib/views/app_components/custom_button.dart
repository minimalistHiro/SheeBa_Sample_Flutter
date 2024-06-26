import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? buttonTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.buttonTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 50),
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: const StadiumBorder(),
      ),
      onPressed: buttonTap,
      child: Text(text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? buttonTap;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.buttonTap
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(300, 50),
        foregroundColor: Colors.black, shape: const StadiumBorder(),
        side: const BorderSide(color: Colors.black, width: 2.5),
      ),
      onPressed: buttonTap,
      child: Text(text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}