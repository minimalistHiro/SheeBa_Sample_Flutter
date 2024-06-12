import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/chat_user.dart';
import '../../view_model/view_model.dart';
import '../app_components/components.dart';

class SendPointPage extends StatefulWidget {
  final ViewModel viewModel;
  final ChatUser? fetcheduser;
  final bool isError;
  const SendPointPage({super.key, required this.viewModel, required this.isError, required this.fetcheduser});

  @override
  State<SendPointPage> createState() => _SendPointPageState();
}

class _SendPointPageState extends State<SendPointPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ComAppBarText(text:
        widget.fetcheduser != null ? '${widget.fetcheduser!.username}に送る' : 'エラー'),
      ),
      body: Center(child: Text(widget.isError ? 'エラー' : '正常')),
    );
  }
}