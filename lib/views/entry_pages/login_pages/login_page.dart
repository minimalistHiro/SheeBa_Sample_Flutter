import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/util/util.dart';
import 'package:sheeba_sample/views/app_components/components.dart';
import 'package:sheeba_sample/views/app_components/custom_button.dart';
import '../../../view_model/view_model.dart';
import '../../app_components/custom_dialog.dart';

class LoginPage extends StatefulWidget {
  final ViewModel viewModel;
  const LoginPage({super.key, required this.viewModel});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isShowPassword = false;

  /// ボタン活性条件分岐
  ///
  /// @param なし
  /// @return true：活性、false：非活性
  bool _isCheckButtonEnable() {
    if (widget.viewModel.email != null && widget.viewModel.password != null) {
      if (widget.viewModel.email!.isNotEmpty
          && widget.viewModel.password!.isNotEmpty) {
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
        title: ComAppBarText(text: 'ログイン')
      ),
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
                    child: CustomButton(text: 'ログイン',
                      buttonTap: !_isCheckButtonEnable() ? null : () async {
                        setState(() {
                          widget.viewModel.isLoading = true;
                        });
                        try {
                          await widget.viewModel.login();
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
          ],
        ),
      ),
    );
  }
}