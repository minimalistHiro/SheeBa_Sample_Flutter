import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../view_model/view_model.dart';
import '../../app_components/components.dart';
import '../../app_components/custom_button.dart';
import '../../app_components/custom_dialog.dart';

class CreateNotificationPage extends StatefulWidget {
  final ViewModel viewModel;
  const CreateNotificationPage({super.key, required this.viewModel});

  @override
  State<CreateNotificationPage> createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  String _title = '';
  String _text = '';
  String _imageUrl = '';
  String _url = '';

  /// ボタン活性条件分岐
  ///
  /// @param なし
  /// @return true：活性、false：非活性
  bool _isCheckButtonEnable() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ComAppBarText(text: 'お知らせを作成'),
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
                    // タイトル
                    ComTextField(hintText: 'タイトル', onChanged: (text) {
                      setState(() {
                        _title = text;
                      });
                    }),

                    // タイトル
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: TextField(
                        controller: null,
                        decoration: const InputDecoration(
                            hintText: 'テキスト'
                        ),
                        onChanged: (text) {
                          setState(() {
                            _title = text;
                          });
                        },
                      ),
                    ),

                    CustomButton(text: 'お知らせを作成',
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