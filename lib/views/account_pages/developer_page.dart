import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/views/account_pages/developer_pages/create_notification_page.dart';
import '../../view_model/view_model.dart';
import '../app_components/components.dart';

class DeveloperPage extends StatefulWidget {
  final ViewModel viewModel;
  const DeveloperPage({super.key, required this.viewModel});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ComAppBarText(text: 'Developer専用ページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            ComListMenu(title: 'お知らせを作成', color: Colors.black, buttonTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNotificationPage(viewModel: widget.viewModel),
                ),
              );
            }),
          ],),
      ),
    );
  }
}