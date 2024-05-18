import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/Util/setting.dart';
import 'package:sheeba_sample/views/app_components/custom_button.dart';
import '../../app_components/components.dart';

class SetUpEmailPage extends StatefulWidget {
  @override
  _SetUpEmailPageState createState() => _SetUpEmailPageState();
}

class _SetUpEmailPageState extends State<SetUpEmailPage> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Setting().sheebaYellow,
      appBar: AppBar(
          backgroundColor: Setting().sheebaYellow,
          title: AppBarText(text: '新規アカウントを作成')),
      body: Center(
        child: Padding(
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
                  decoration: InputDecoration(
                      hintText: 'メールアドレス'
                  ),
                  onChanged: (text) {

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
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: CustomButton(text: '次へ'),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}