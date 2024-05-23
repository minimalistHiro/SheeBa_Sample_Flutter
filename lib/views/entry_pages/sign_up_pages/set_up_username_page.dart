import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeba_sample/Util/setting.dart';
import 'package:sheeba_sample/model/user.dart';
import 'package:sheeba_sample/view_model/view_model.dart';
import 'package:sheeba_sample/views/app_components/custom_button.dart';
import 'package:sheeba_sample/views/app_components/custom_icon.dart';
import 'package:sheeba_sample/views/entry_pages/sign_up_pages/set_up_email_page.dart';
import '../../app_components/components.dart';

class SetUpUsernamePage extends StatefulWidget {
  final ViewModel viewModel;
  const SetUpUsernamePage({super.key, required this.viewModel});

  @override
  State<SetUpUsernamePage> createState() => _SetUpUsernamePageState();
}

class _SetUpUsernamePageState extends State<SetUpUsernamePage> {
  late final ViewModel viewModel;
  final picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
  }

  /// ImagePickerを開く
  ///
  /// @param なし
  /// @return なし
  // Future<void> pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     viewModel.profileImageUrl = pickedFile.path;
  //     viewModel.imageFile = File(pickedFile.path);
  //   }
  // }

  Future pickImage() async {
    //カメラロールから読み取る
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        viewModel.profileImageUrl = pickedFile.path;
        _image = File(pickedFile.path);
      } else {
        print('画像が選択できませんでした。');
      }
    });
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
        // child: Consumer<ViewModel>(builder: (context, model, child) {
           Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: Text('トップ画像（任意）'),
                ),
                // トップ画像
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                      child: CustomIcon(imageFile: _image,),
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
                      viewModel.username = text;
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
                      viewModel.age = value;
                    },
                  ),
                ),
                // 住所
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: DropdownButtonFormField(
                    // value: '年代を選択',
                    hint: Text('住所を選択してください'),
                    items: addressItems,
                    onChanged: (value) {
                      viewModel.address = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CustomButton(text: '次へ',
                    buttonTap: () {
                      // print(viewModel.profileImageUrl);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetUpEmailPage(viewModel: viewModel)
                        ),
                      );
                    },
                  )
                ),
                Spacer(),
              ],
            ),
          ),
        // }),
      ),
    );
  }
}