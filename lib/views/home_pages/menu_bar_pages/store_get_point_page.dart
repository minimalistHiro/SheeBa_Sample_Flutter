import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/views/app_components/components.dart';
import '../../../view_model/view_model.dart';

class StoreGetPointPage extends StatefulWidget {
  final ViewModel viewModel;
  const StoreGetPointPage({super.key, required this.viewModel});

  @override
  State<StoreGetPointPage> createState() => _StoreGetPointPageState();
}

class _StoreGetPointPageState extends State<StoreGetPointPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ComAppBarText(text: '本日の獲得ポイント一覧'),
      ),
      body: Center(child: Text('StoreGetPointPage')),
    );
  }
}