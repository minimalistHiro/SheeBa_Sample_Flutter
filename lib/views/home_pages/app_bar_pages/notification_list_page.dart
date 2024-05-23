import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/views/app_components/components.dart';

class NotificationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ComAppBarText(text: 'お知らせ')
      ),
      body: Center(child: Text('NotificationListPage')),
    );
  }
}