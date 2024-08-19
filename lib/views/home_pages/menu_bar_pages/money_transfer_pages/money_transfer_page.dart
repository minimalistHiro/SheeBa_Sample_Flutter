import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/views/app_components/custom_icon_image.dart';
import '../../../../view_model/view_model.dart';

class MoneyTransferPage extends StatefulWidget {
  final ViewModel viewModel;
  const MoneyTransferPage({super.key, required this.viewModel});

  @override
  State<MoneyTransferPage> createState() => _MoneyTransferPageState();
}

class _MoneyTransferPageState extends State<MoneyTransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 5,right: 20),
        child: ListView.separated(
          itemCount: 2,
          itemBuilder: (context, index) {
            return const ListTile(
              leading: CustomWebIcon(imageUrl: null, scale: 0.5),
              title: Text('タイトル',
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('テキスト', maxLines: 1,),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(color: Colors.white,);
          },
          // TODO: - onTapでchat_pageに移動（その前にchat_pageを作成）。
        ),
      ),
    );
  }
}