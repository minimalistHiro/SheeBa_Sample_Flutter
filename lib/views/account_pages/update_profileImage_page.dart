import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../util/firebase_constants.dart';
import '../../util/util.dart';
import '../../view_model/view_model.dart';
import '../app_components/components.dart';
import '../app_components/custom_button.dart';
import '../app_components/custom_dialog.dart';
import '../app_components/custom_icon_image.dart';

class UpdateProfileImagePage extends StatefulWidget {
  final ViewModel viewModel;
  final String profileImageUrl;
  const UpdateProfileImagePage({super.key, required this.viewModel, required this.profileImageUrl});

  @override
  State<UpdateProfileImagePage> createState() => _UpdateProfileImagePageState();
}

class _UpdateProfileImagePageState extends State<UpdateProfileImagePage> {
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
        // widget.viewModel.profileImageUrl = pickedFile.path;
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
    if (widget.viewModel.imageFile != null) {
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
          title: ComAppBarText(text: 'トップ画像を変更')),
      body: Center(
        child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    // トップ画像変更
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: GestureDetector(
                          child: widget.viewModel.imageFile == null
                              ? CustomWebIcon(imageUrl: widget.profileImageUrl, scale: 2,)
                              : CustomFileIcon(imageFile: widget.viewModel.imageFile, scale: 2,),
                          onTap: () {
                            setState(() {
                              pickImage();
                            });
                          }
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

                                if (user != null) {
                                  await widget.viewModel.persistImage(user, false);
                                  Map<String, dynamic> data = {FirebaseChatUser().profileImageUrl: widget.viewModel.profileImageUrl};
                                  await widget.viewModel.updateUser(user.uid, data);
                                  CustomShowSingleDialog(context, '', 'プロフィール画像を変更しました。', null);
                                }
                              } catch(e) {
                                CustomShowSingleDialog(context, '', 'プロフィール画像の失敗しました。', null);
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