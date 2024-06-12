import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../view_model/view_model.dart';
import '../app_components/components.dart';

class GetPointPage extends StatefulWidget {
  final ViewModel viewModel;
  const GetPointPage({super.key, required this.viewModel});

  @override
  State<GetPointPage> createState() => _GetPointPageState();
}

class _GetPointPageState extends State<GetPointPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ComAppBarText(text: 'ポイントゲット！'),
      ),
      body: Center(child: Text('GetPointPage')),
    );
  }
}