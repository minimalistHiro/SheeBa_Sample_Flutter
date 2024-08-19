import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sheeba_sample/util/util.dart';
import 'package:sheeba_sample/views/home_pages/app_bar_pages/notification_list_page.dart';
import 'package:sheeba_sample/views/home_pages/menu_bar_pages/money_transfer_pages/money_transfer_page.dart';
import 'package:sheeba_sample/views/home_pages/menu_bar_pages/qr_code_page.dart';
import 'package:sheeba_sample/views/home_pages/menu_bar_pages/ranking_page.dart';
import 'package:sheeba_sample/views/home_pages/menu_bar_pages/store_get_point_page.dart';
import '../../util/firebase_constants.dart';
import '../../view_model/view_model.dart';

class HomePage extends StatefulWidget {
  final ViewModel viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.viewModel.fetchCurrentUser(),
      builder: (context, snapshot) {
        // 初期化
        // widget.viewModel.init();
        
        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'images/cleartitle.png',
              width: 150,
            ),
            actions: [
              IconButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationListPage(viewModel: widget.viewModel, snapshot: snapshot,),
                  ),
                );
              },
                  icon: Icon(Icons.notifications)),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(viewModel: widget.viewModel, snapshot: snapshot,),
                MenuButtons(viewModel: widget.viewModel, snapshot: snapshot,),
              ],
            ),
          ),
        );
      }
    );
  }
}

// カード
class Card extends StatefulWidget {
  final ViewModel viewModel;
  final AsyncSnapshot<DocumentSnapshot<Object?>> snapshot;
  const Card({super.key, required this.viewModel, required this.snapshot});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Util().sheebaYellow,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                )
              ],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          Column(
            children: [
              // 獲得ポイント
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  '獲得ポイント',
                  style: TextStyle(
                    fontSize: 15,
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 80.0),
                      child: widget.snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : Text(
                        widget.snapshot.data?.get(FirebaseChatUser().point).toString() ??  Util().defaultChatUser.point.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                        ),),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'pt',
                        style: TextStyle(
                          fontSize: 20,
                        ),),
                    ),
                    // リロードボタン
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: IconButton(
                          onPressed: () {
                            // setState(() {
                            //   widget.viewModel.fetchCurrentUser();
                            // });
                          },
                          icon: Icon(Icons.replay, color: Colors.black,)),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// メニューボタン
class MenuButtons extends StatefulWidget {
  final ViewModel viewModel;
  final AsyncSnapshot<DocumentSnapshot<Object?>> snapshot;
  const MenuButtons({super.key, required this.viewModel, required this.snapshot});

  @override
  State<MenuButtons> createState() => _MenuButtonsState();
}

class _MenuButtonsState extends State<MenuButtons> {
  final double iconSize = 35;
  final double textSize = 11;
  final double padding = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 350,
              height: 80,
              decoration: BoxDecoration(
                color: Util().sheebaDarkGreen,
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QRコード
                Padding(
                  padding: EdgeInsets.only(left: padding, right: padding),
                  child: Column(
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRCodePage(
                              viewModel: widget.viewModel,
                              username: widget.snapshot.data?.get(FirebaseChatUser().username),
                              imageUrl: widget.snapshot.data?.get(FirebaseChatUser().profileImageUrl),
                              uid: widget.snapshot.data?.get(FirebaseChatUser().uid),
                            ),
                          ),
                        );
                      }, icon: Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: iconSize,
                      )),
                      Text('QRコード', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: textSize,
                      ),),
                    ],
                  ),
                ),
                // 送る
                Padding(
                  padding: EdgeInsets.only(left: padding, right: padding),
                  child: Column(
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoneyTransferPage(viewModel: widget.viewModel),
                          ),
                        );
                      }, icon: Icon(
                        Icons.currency_yen,
                        color: Colors.white,
                        size: iconSize,
                      )),
                      Text('送る', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: textSize,
                      ),),
                    ],
                  ),
                ),
                // ランキング
                Padding(
                  padding: EdgeInsets.only(left: padding, right: padding),
                  child: Column(
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RankingPage(viewModel: widget.viewModel),
                          ),
                        );
                      }, icon: Icon(
                        Icons.emoji_events_outlined,
                        color: Colors.white,
                        size: iconSize,
                      )),
                      Text('ランキング', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: textSize,
                      ),),
                    ],
                  ),
                ),
                // 本日の獲得
                Padding(
                  padding: EdgeInsets.only(left: padding, right: padding),
                  child: Column(
                    children: [
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreGetPointPage(viewModel: widget.viewModel),
                          ),
                        );
                      }, icon: Icon(
                        Icons.store_outlined,
                        color: Colors.white,
                        size: iconSize,
                      )),
                      Text('本日の獲得', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: textSize,
                      ),),
                    ],
                  ),
                )
              ],
            )
          ]
      ),
    );
  }
}
