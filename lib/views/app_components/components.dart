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

class ComTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  const ComTextField({super.key, required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: null,
        decoration: InputDecoration(
            hintText: hintText
        ),
        onChanged: onChanged,
        maxLength: 100,
      ),
    );
  }
}

class ComPasswordTextField extends StatelessWidget {
  final String hintText;
  final bool isShow;
  final VoidCallback? buttonTap;
  final ValueChanged<String>? onChanged;
  const ComPasswordTextField({super.key, required this.hintText, required this.isShow, required this.buttonTap, required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextFormField(
        obscureText: !isShow,
        decoration: InputDecoration(
          labelText: hintText,
          suffixIcon: IconButton(
            icon: Icon(isShow ? Icons.visibility : Icons.visibility_off),
            onPressed: buttonTap
          ),
        ),
        onChanged: onChanged,
        maxLength: 50,
      ),
    );
  }
}

class ComTextBox extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  const ComTextBox({super.key, required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: null,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
        maxLines: 10,
        maxLength: 500,
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

class ComListMenu extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? buttonTap;
  const ComListMenu({super.key, required this.title, required this.color, required this.buttonTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTap,
      child:Container(
        padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
        ),
        child: Text(
          title,
          style: TextStyle(
              color: color,
              fontSize: 18.0
          ),
        ),
      ),
    );
  }
}