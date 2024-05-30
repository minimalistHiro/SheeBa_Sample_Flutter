import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:sheeba_sample/util/firebase_constants.dart';
import 'package:sheeba_sample/util/util.dart';
import 'package:sheeba_sample/views/account_pages/update_profileImage_page.dart';
import 'package:sheeba_sample/views/account_pages/update_username_page.dart';
import 'package:sheeba_sample/views/app_components/custom_dialog.dart';
import 'package:sheeba_sample/views/app_components/custom_icon.dart';
import 'package:sheeba_sample/views/entry_pages/entry_page.dart';
import '../../view_model/view_model.dart';

class AccountPage extends StatefulWidget {
  final ViewModel viewModel;
  const AccountPage({super.key, required this.viewModel});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  // @override
  // void initState() {
  //   super.initState();
  //   widget.viewModel.init();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   setState(() {
    //     widget.viewModel.fetchCurrentUser();
    //   });
    // });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.viewModel.fetchCurrentUser(),
      builder: (context, snapshot) {
        // 初期化
        widget.viewModel.init();

        return Scaffold(
          appBar: AppBar(
            title:
            snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : Column(
              children: [
                // トップ画像
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                      child: CustomWebIcon(imageUrl: snapshot.data?.get(FirebaseChatUser().profileImageUrl), scale: 1,),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProfileImagePage(viewModel: widget.viewModel, profileImageUrl: snapshot.data?.get(FirebaseChatUser().profileImageUrl),),
                          ),
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  // child: Text(widget.viewModel.currentChatUser?.username ?? Util().defaultChatUser.username,
                  // child: Text('',
                  child: Text(snapshot.data?.get(FirebaseChatUser().username) ?? Util().defaultChatUser.username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text('しばID：${snapshot.data?.get(FirebaseChatUser().uid) ?? Util().defaultChatUser.uid}',
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 300),
                  child: Text('設定',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            toolbarHeight: 250,
          ),
          body: ListView(children: [
            _menuList('ユーザー名を変更', Colors.black, context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateUsernamePage(viewModel: widget.viewModel),
                ),
              );
            }),
            _menuList('公式サイト', Colors.black, context, null),
            _menuList('プライバシーポリシー', Colors.black, context, null),
            _menuList('ログアウト', Colors.red, context, () {
              CustomShowDoubleDialog(context, '', 'ログアウトしますか？', 'ログアウト', Colors.red, () async {
                setState(() {
                  widget.viewModel.isLoading = true;
                });
                try {
                  await widget.viewModel.logout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => EntryPage(viewModel: widget.viewModel)
                    ),
                  );
                } catch(e) {
                  CustomShowSingleDialog(context, '', 'ログアウトに失敗しました。', null);
                } finally {
                  setState(() {
                    widget.viewModel.isLoading = false;
                  });
                }
              });
            }),
            _menuList('退会する', Colors.red, context, null),
          ],),
        );
      }
    );
  }

  /// メニューリスト
  ///
  /// @param
  /// - title - タイトル
  /// - color - テキストカラー
  /// - context - コンテキスト
  /// - action - 実行処理
  /// @return Widget
  Widget _menuList(String title, Color color, BuildContext context, VoidCallback? buttonTap) {
    return GestureDetector(
      onTap: buttonTap,
      child:Container(
          padding: const EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
          child: Text(
            title,
            style: TextStyle(
                color: color,
                fontSize: 18.0
            ),
          ),
      ),
    );
  }
}