import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/views/app_components/custom_icon_image.dart';
import '../../../model/chat_user.dart';
import '../../../util/firebase_constants.dart';
import '../../../util/util.dart';
import '../../../view_model/view_model.dart';
import '../../app_components/components.dart';
import '../../app_components/custom_button.dart';
import '../../app_components/custom_dialog.dart';

class NotificationDetailPage extends StatefulWidget {
  final ViewModel viewModel;
  final String title;
  final String text;
  final String imageUrl;
  final String url;
  const NotificationDetailPage({super.key, required this.viewModel, required this.title, required this.text, required this.imageUrl, required this.url});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {

  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Util().sheebaYellow,
      appBar: AppBar(
        backgroundColor: Util().sheebaYellow,
        title: const ComAppBarText(text: 'お知らせを作成'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: widget.viewModel.fetchCurrentUser(),
        builder: (context, snapshot) {
          return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // テキスト
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            width: double.infinity,
                            child: Text(widget.text),
                          ),
                        ),

                        // URL
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                              width: double.infinity,
                              child: Text(widget.url,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent
                                ),
                              )
                          ),
                        ),

                        // 画像
                        if (widget.imageUrl != '')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: CustomWebImage(imageUrl: widget.imageUrl, scale: 2),
                        ),

                        if(snapshot.data?.get(FirebaseChatUser().isOwner))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 70),
                          child: CustomButton(text: '削除',
                            buttonTap: () async {
                              CustomShowDoubleDialog(context, '', 'このお知らせを削除しますか？', '削除',
                                  Colors.red, () async {
                                    Navigator.pop(context);
                                    setState(() {
                                      widget.viewModel.isLoading = true;
                                    });
                                    try {
                                      // 画像が存在する（画像URLが空でない）場合のみ、画像を削除する。
                                      if (widget.imageUrl != '') {
                                        await deleteImage(widget.imageUrl);
                                      } else {
                                        for (final user in widget.viewModel.allUsers) {
                                          await deleteNotification(user);
                                        }
                                      }
                                    } catch(e) {
                                      CustomShowSingleDialog(context, '', e.toString(), null);
                                    } finally {
                                      setState(() {
                                        widget.viewModel.isLoading = false;
                                      });
                                      CustomShowSingleDialog(context, '', '削除しました。', null);
                                    }
                                  });
                            },
                            color: Colors.red,
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
          );
        }
      ),
    );
  }

  /// Notificationを削除
  ///
  /// @param
  /// - user ユーザー情報
  /// @return なし
  Future<void> deleteNotification(ChatUser user) async {
    await FirebaseFirestore.instance
        .collection(FirebaseNotification().notifications)
        .doc(user.uid)
        .collection(FirebaseNotification().notification)
        .doc(widget.title)
        .delete();
  }


  /// 画像をFirebaseStorageから削除
  ///
  /// @param
  /// - doc ドキュメント
  /// @return なし
  Future<void> deleteImage(String imageUrl) async {
    await FirebaseStorage.instance
        .refFromURL(imageUrl)
        .delete();
    for (final user in widget.viewModel.allUsers) {
      await deleteNotification(user);
    }
  }
}