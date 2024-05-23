import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheeba_sample/Util/setting.dart';
import 'package:sheeba_sample/views/app_components/custom_button.dart';
import 'package:sheeba_sample/views/app_components/custom_dialog.dart';
import 'package:sheeba_sample/views/bottom_tab%20_page.dart';
import '../../../view_model/view_model.dart';
import '../../app_components/components.dart';

class SetUpEmailPage extends StatefulWidget {
  final ViewModel viewModel;
  const SetUpEmailPage({super.key, required this.viewModel});

  @override
  _SetUpEmailPageState createState() => _SetUpEmailPageState();
}

class _SetUpEmailPageState extends State<SetUpEmailPage> {
  late final ViewModel viewModel;
  bool _isShowPassword = false;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Setting().sheebaYellow,
      appBar: AppBar(
          backgroundColor: Setting().sheebaYellow,
          title: ComAppBarText(text: '新規アカウントを作成')),
      body: Center(
        child:
    // Consumer<ViewModel>(builder: (context, model, child) {
           Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      // メールアドレス
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: TextField(
                          controller: null,
                          decoration: const InputDecoration(
                              hintText: 'メールアドレス'
                          ),
                          onChanged: (text) {
                            viewModel.email = text;
                          },
                        ),
                      ),
                      // パスワード
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: TextFormField(
                          controller: null,
                          obscureText: !_isShowPassword,
                          decoration: InputDecoration(
                            labelText: 'パスワード',
                            suffixIcon: IconButton(
                              icon: Icon(_isShowPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isShowPassword = !_isShowPassword;
                                });
                              },
                            ),
                          ),
                          onChanged: (text) {
                            viewModel.password = text;
                          },
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                          child:
                          CustomButton(text: 'アカウントを作成',
                              buttonTap: () async {
                                viewModel.startLoading();
                                try {
                                  await viewModel.signUp();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomTabPage(),
                                    ),
                                  );
                                } catch(e) {
                                  CustomSingleDialog(title: '', text: e.toString());
                                } finally {
                                  viewModel.endLoading();
                                }
                              }
                          )
                      ),
                      const Spacer(),
                      const Spacer(),
                    ],
                  ),
                ),
                // インジケーター
                if (viewModel.isLoading)
                  ComProgressIndicator()
              ]
          ),
        // }),
      ),
    );
  }
}