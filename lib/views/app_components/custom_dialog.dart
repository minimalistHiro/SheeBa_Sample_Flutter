import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSingleDialog extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback? action;

  const CustomSingleDialog({
    super.key,
    required this.title,
    required this.text,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class CustomDoubleDialog extends StatelessWidget {
  final String title;
  final String text;
  final String okText;
  final VoidCallback? action;

  const CustomDoubleDialog({
    super.key,
    required this.title,
    required this.text,
    required this.okText,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          child: Text('キャンセル'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(okText),
          onPressed: () async {
            action;
          },
        ),
      ],
    );
  }
}