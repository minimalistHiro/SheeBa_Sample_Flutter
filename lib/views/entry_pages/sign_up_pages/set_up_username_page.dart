import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeba_sample/model/chat_user.dart';
import 'package:sheeba_sample/util/util.dart';
import 'package:sheeba_sample/view_model/view_model.dart';
import 'package:sheeba_sample/views/app_components/custom_button.dart';
import 'package:sheeba_sample/views/app_components/custom_icon_image.dart';
import 'package:sheeba_sample/views/entry_pages/sign_up_pages/set_up_email_page.dart';
import '../../app_components/components.dart';

class SetUpUsernamePage extends StatefulWidget {
  final ViewModel viewModel;
  const SetUpUsernamePage({super.key, required this.viewModel});

  @override
  State<SetUpUsernamePage> createState() => _SetUpUsernamePageState();
}

class _SetUpUsernamePageState extends State<SetUpUsernamePage> {
  final picker = ImagePicker();

  /// ImagePickerを開く
  ///
  /// @param なし
  /// @return なし
  Future<void> pickImage() async {
    //カメラロールから読み取る
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        widget.viewModel.imageFile = File(pickedFile.path);
      } else {
        print('画像が選択できませんでした。');
      }
    });
  }

  /// ボタン活性条件分岐
  ///
  /// @param なし
  /// @return true：活性、false：非活性
  bool _isCheckButtonEnable() {
    if (widget.viewModel.username != null
        && widget.viewModel.age != null
        && widget.viewModel.address != null) {
      if (widget.viewModel.username!.isNotEmpty
          && widget.viewModel.age!.isNotEmpty
          && widget.viewModel.address!.isNotEmpty) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Util().sheebaYellow,
      appBar: AppBar(
          backgroundColor: Util().sheebaYellow,
          title: ComAppBarText(text: '新規アカウントを作成')),
      body: Center(
        child:
           Stack(
             children: [
               Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15, top: 15),
                      child: Text('トップ画像（任意）'),
                    ),
                    // プロフィール画像
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: GestureDetector(
                          child: CustomFileIcon(imageFile: widget.viewModel.imageFile, scale: 1,),
                          onTap: () {
                            setState(() {
                              pickImage();
                            });
                          }
                      ),
                    ),
                    // ユーザー名
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: TextField(
                        // controller: model.usernameController,
                        decoration: const InputDecoration(
                            hintText: 'ユーザー名（他のユーザーに公開されます）'
                        ),
                        onChanged: (text) {
                          setState(() {
                            widget.viewModel.username = text;
                          });
                        },
                      ),
                    ),
                    // 年代
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: DropdownButtonFormField(
                        // value: '年代を選択',
                        hint: Text('年代を選択してください'),
                        items: ageItems,
                        onChanged: (value) {
                          setState(() {
                            widget.viewModel.age = value;
                          });
                        },
                      ),
                    ),
                    // 住所
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: DropdownButtonFormField(
                        // value: '年代を選択',
                        hint: Text('住所を選択してください'),
                        items: addressItems,
                        onChanged: (value) {
                          setState(() {
                            widget.viewModel.address = value;
                          });
                        },
                      ),
                    ),

                    CustomButton(text: '次へ',
                      buttonTap: !_isCheckButtonEnable() ? null : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetUpEmailPage(viewModel: widget.viewModel)
                          ),
                        );
                      },
                      color: Colors.black,
                    ),

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