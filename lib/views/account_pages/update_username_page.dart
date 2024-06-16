import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../util/firebase_constants.dart';
import '../../util/util.dart';
import '../../view_model/view_model.dart';
import '../app_components/components.dart';
import '../app_components/custom_button.dart';
import '../app_components/custom_dialog.dart';

class UpdateUsernamePage extends StatefulWidget {
  final ViewModel viewModel;
  const UpdateUsernamePage({super.key, required this.viewModel});

  @override
  State<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends State<UpdateUsernamePage> {
  String _username = '';

  /// ボタン活性条件分岐
  ///
  /// @param なし
  /// @return true：活性、false：非活性
  bool _isCheckButtonEnable() {
    if (_username.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Util().sheebaYellow,
      appBar: AppBar(
          backgroundColor: Util().sheebaYellow,
          title: ComAppBarText(text: 'ユーザー名を変更')),
      body: Center(
        child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    // ユーザー名変更テキスト
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: TextField(
                        controller: null,
                        decoration: const InputDecoration(
                          hintText: 'ユーザー名',
                        ),
                        onChanged: (text) {
                          setState(() {
                            _username = text;
                          });
                        },
                      ),
                    ),

                    const Spacer(),

                    Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child:
                        CustomButton(text: '確定',
                            buttonTap: !_isCheckButtonEnable() ? null : () async {
                              setState(() {
                                widget.viewModel.isLoading = true;
                              });
                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                Map<String, dynamic> data = {FirebaseChatUser().username: _username};

                                if (user != null) {
                                  await widget.viewModel.updateUser(user.uid, data);
                                  CustomShowSingleDialog(context, '', 'ユーザー名を変更しました。', null);
                                }
                              } catch(e) {
                                CustomShowSingleDialog(context, '', 'ユーザー名の変更に失敗しました。', null);
                              } finally {
                                setState(() {
                                  widget.viewModel.isLoading = false;
                                });
                              }
                            },
                          color: Colors.black,
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