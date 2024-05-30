import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/util/util.dart';
import 'package:sheeba_sample/views/app_components/custom_button.dart';
import 'package:sheeba_sample/views/app_components/custom_dialog.dart';
import '../../../view_model/view_model.dart';
import '../../app_components/components.dart';

class SetUpEmailPage extends StatefulWidget {
  final ViewModel viewModel;
  const SetUpEmailPage({super.key, required this.viewModel});

  @override
  State<SetUpEmailPage> createState() => _SetUpEmailPageState();
}

class _SetUpEmailPageState extends State<SetUpEmailPage> {
  bool _isShowPassword = false;

  /// ボタン活性条件分岐
  ///
  /// @param なし
  /// @return true：活性、false：非活性
  bool _isCheckButtonEnable() {
    if (widget.viewModel.email != null && widget.viewModel.password != null) {
      if (widget.viewModel.email!.isNotEmpty
          && widget.viewModel.password!.length >= Util().minPasswordLength) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Util().sheebaYellow,
      appBar: AppBar(
          backgroundColor: Util().sheebaYellow,
          title: ComAppBarText(text: '新規アカウントを作成')),
      body: Center(
        child: Stack(
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
                          setState(() {
                            widget.viewModel.email = text;
                          });
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
                          setState(() {
                            widget.viewModel.password = text;
                          });
                        },
                      ),
                    ),

                    const Spacer(),

                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child:
                        CustomButton(text: 'アカウントを作成',
                            buttonTap: !_isCheckButtonEnable() ? null : () async {
                              setState(() {
                                widget.viewModel.isLoading = true;
                              });
                              try {
                                await widget.viewModel.signUp();
                                // 自身のユーザー情報が取得できた場合のみ実行。
                                if (widget.viewModel.currentUser != null) {
                                  // 画像が設定されていた場合、画像をDBに保存。そうでない場合、そのまま保存。
                                  if (widget.viewModel.imageFile == null) {
                                    await widget.viewModel.persistUser(widget.viewModel.currentUser!);
                                  } else {
                                    await widget.viewModel.persistImage(widget.viewModel.currentUser!, true);
                                  }
                                } else {
                                  CustomShowSingleDialog(context, 'アカウントの作成エラー', 'ユーザー情報の取得に失敗しました。', null);
                                }
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              } catch(e) {
                                CustomShowSingleDialog(context, '', e.toString(), null);
                              } finally {
                                setState(() {
                                  widget.viewModel.isLoading = false;
                                });
                              }
                            },
                        )
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
              ),
              // インジケーター
              if (widget.viewModel.isLoading)
                const ComDarkProgressIndicator()
            ]
        ),
      ),
    );
  }
}