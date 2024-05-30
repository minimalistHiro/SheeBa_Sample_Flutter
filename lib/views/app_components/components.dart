import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComAppBarText extends StatelessWidget {
  final String text;
  const ComAppBarText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}

class ComDarkProgressIndicator extends StatelessWidget {
  const ComDarkProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}