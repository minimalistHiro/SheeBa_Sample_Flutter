import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/Util/setting.dart';
import 'package:sheeba_sample/views/app_components/custom_button.dart';
import 'package:sheeba_sample/views/entry_pages/login_pages/login_page.dart';
import 'package:sheeba_sample/views/entry_pages/sign_up_pages/set_up_username_page.dart';
import '../../view_model/view_model.dart';

class EntryPage extends StatefulWidget {
  final ViewModel viewModel;
  const EntryPage({super.key, required this.viewModel});

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late final ViewModel viewModel;

  @override
  void initState() {
    print('initState開始');
    super.initState();
    viewModel = widget.viewModel;
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Setting().sheebaYellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100, top: 100),
              child: Image.asset(
                'images/title.png',
                width: 250,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CustomOutlinedButton(text: 'アカウントを作成する',
                nextPage: SetUpUsernamePage(viewModel: viewModel),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: CustomButton(text: 'ログイン',
                    buttonTap: () {
                      viewModel.init();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    })
            ),
          ],
        ),
      ),
    );
  }
}