import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFileIcon extends StatefulWidget {
  final File? imageFile;
  final double scale;
  const CustomFileIcon({super.key, required this.imageFile, required this.scale});

  @override
  State<CustomFileIcon> createState() => _CustomFileIconState();
}

class _CustomFileIconState extends State<CustomFileIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120 * widget.scale,
            height: 120 * widget.scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              border: Border.all(width: 3),
            ),
          ),
          widget.imageFile != null
              ? Container(
            width: 120.0 * widget.scale,
            height: 120.0 * widget.scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(widget.imageFile!.path)
              ),
              border: Border.all(width: 3),
            ),
          )
              : Icon(Icons.person, size: 70,)
        ]
    );
  }
}

class CustomWebIcon extends StatefulWidget {
  final String? imageUrl;
  final double scale;
  const CustomWebIcon({super.key, required this.imageUrl, required this.scale});

  @override
  State<CustomWebIcon> createState() => _CustomWebIconState();
}

class _CustomWebIconState extends State<CustomWebIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120 * widget.scale,
            height: 120 * widget.scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              border: Border.all(width: 3),
            ),
          ),
          widget.imageUrl != null && widget.imageUrl != ''
              ? Container(
            width: 120.0 * widget.scale,
            height: 120.0 * widget.scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.imageUrl!),
              ),
              border: Border.all(width: 3),
            ),
          )
              : Icon(Icons.person, size: 70,)
        ]
    );
  }
}