import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/util/util.dart';
import 'package:sheeba_sample/views/account_pages/account_page.dart';
import 'package:sheeba_sample/views/home_pages/home_page.dart';
import 'package:sheeba_sample/views/qr_scan_pages/qr_scan_page.dart';
import '../view_model/view_model.dart';
import 'entry_pages/entry_page.dart';

class BottomTabPage extends StatefulWidget {
  final ViewModel viewModel;
  const BottomTabPage({super.key, required this.viewModel});

  @override
  State<BottomTabPage> createState() => _BottomTabPageState();
}

class _BottomTabPageState extends State<BottomTabPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // 未サインインの場合、EntryPageに画面遷移。
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => EntryPage(viewModel: widget.viewModel)
          ),
        );
      // } else {
        // ユーザー情報を取得する。
        // WidgetsBinding.instance.addPostFrameCallback((_) async {
        //   setState(() {
        //     widget.viewModel.isLoading = true;
        //   });
        //   try {
        //     await widget.viewModel.fetchCurrentUser();
        //   } catch(e) {
        //     CustomShowSingleDialog(context, '', 'ユーザー情報の取得に失敗しました。', null);
        //   } finally {
        //     setState(() {
        //       widget.viewModel.isLoading = false;
        //     });
        //   }
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ((){
          switch(_currentIndex) {
            case 0:
              return HomePage(viewModel: widget.viewModel);
            case 1:
              return QRScanPage(viewModel: widget.viewModel,);
            default:
              return AccountPage(viewModel: widget.viewModel,);
          }
        })(),
      ),
      // body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'スキャン'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
        ],
        currentIndex: _currentIndex,
        fixedColor: Util().sheebaDarkGreen,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// ボタンタップ時の処理
  ///
  /// @param
  /// - index タブ番号
  /// @return なし
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}