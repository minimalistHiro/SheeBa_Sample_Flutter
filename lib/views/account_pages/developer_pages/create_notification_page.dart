import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheeba_sample/model/chat_user.dart';
import '../../../util/firebase_constants.dart';
import '../../../util/util.dart';
import '../../../view_model/view_model.dart';
import '../../app_components/components.dart';
import '../../app_components/custom_button.dart';
import '../../app_components/custom_dialog.dart';
import '../../app_components/custom_icon_image.dart';

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
  final picker = ImagePicker();
  File? imageFile;                  // 画像ファイル情報

  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchAllUsers();
  }

  /// ImagePickerを開く
  ///
  /// @param なし
  /// @return なし
  Future<void> pickImage() async {
    //カメラロールから読み取る
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
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
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Util().sheebaYellow,
      appBar: AppBar(
        backgroundColor: Util().sheebaYellow,
        title: const ComAppBarText(text: 'お知らせを作成'),
      ),
      body: Center(
        child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // タイトル
                      ComTextField(hintText: 'タイトル', onChanged: (text) {
                        setState(() {
                          _title = text;
                        });
                      }),

                      // テキスト
                      ComTextBox(hintText: 'テキスト', onChanged: (text) {
                        setState(() {
                          _text = text;
                        });
                      }),

                      // URL
                      ComTextField(hintText: 'URL', onChanged: (text) {
                        setState(() {
                          _url = text;
                        });
                      }),

                      // 画像
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: GestureDetector(
                            child: CustomFileImage(imageFile: imageFile, scale: 2,),
                            onTap: () {
                              setState(() {
                                pickImage();
                              });
                            }
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 70),
                        child: CustomButton(text: 'お知らせを作成',
                          buttonTap: !_isCheckButtonEnable() ? null : () async {
                            setState(() {
                              widget.viewModel.isLoading = true;
                            });
                            try {
                              // 画像をセットした場合のみ、画像を保存する。
                              if (imageFile != null) {
                                await persistImage();
                              } else {
                                for (final user in widget.viewModel.allUsers) {
                                  await persistNotification(user);
                                }
                              }
                              CustomShowSingleDialog(context, '', 'お知らせを作成しました。', null);
                            } catch(e) {
                              CustomShowSingleDialog(context, '', e.toString(), null);
                            } finally {
                              setState(() {
                                widget.viewModel.isLoading = false;
                              });
                            }
                          },
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
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

  /// NotificationをDBに保存
  ///
  /// @param
  /// - user ユーザー情報
  /// @return なし
  Future<void> persistNotification(ChatUser user) async {
    await FirebaseFirestore.instance
        .collection(FirebaseNotification().notifications)
        .doc(user.uid)
        .collection(FirebaseNotification().notification)
        .doc(_title)
        .set({
      FirebaseNotification().title: _title,
      FirebaseNotification().text: _text,
      FirebaseNotification().isRead: false,
      FirebaseNotification().url: _url,
      FirebaseNotification().imageUrl: _imageUrl,
      FirebaseNotification().timestamp: Timestamp.fromDate(DateTime.now()),
    });
  }

  /// 画像をFirebaseStorageに保存
  ///
  /// @param
  /// - doc ドキュメント
  /// @return なし
  Future<void> persistImage() async {
    // 画像をFirebaseStorageにアップロード
    final task = await FirebaseStorage.instance
        .ref('notifications/$_title')
        .putFile(imageFile!);
    _imageUrl = await task.ref.getDownloadURL();

    for (final user in widget.viewModel.allUsers) {
      await persistNotification(user);
    }
  }
}