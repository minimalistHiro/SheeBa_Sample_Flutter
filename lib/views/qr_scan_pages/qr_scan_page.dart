import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sheeba_sample/util/util.dart';
import 'package:sheeba_sample/views/qr_scan_pages/get_point_page.dart';
import 'package:sheeba_sample/views/qr_scan_pages/send_point_page.dart';
import '../../model/chat_user.dart';
import '../../util/firebase_constants.dart';
import '../../view_model/view_model.dart';

class QRScanPage extends StatefulWidget {
  final ViewModel viewModel;
  const QRScanPage({super.key, required this.viewModel});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ChatUser? fetchedUser;            // QRコードスキャンしたユーザー
  bool _isErrorScan = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(flex: 4, child: _buildQrView(context)),
              // Expanded(
              //   flex: 1,
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: <Widget>[
              //         if (result != null)
              //           Text(
              //               'Barcode Type: ${describeEnum(result!.format)}   Data: ${result?.code}')
              //         else
              //           const Text('Scan a code'),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
          // if (_isErrorScan)
          //   Opacity(opacity: 0.5,
          //     child: Container(
          //       decoration: BoxDecoration(color: Colors.red),
          //     ),
          //   ),
          
          // if (_isErrorScan)
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     // ×印
          //     const Opacity(opacity: 0.7,
          //       child: Icon(Icons.close, color: Colors.white, size: 200,),),
          //     // 「誤ったQRコードがスキャンされました。」
          //     Stack(
          //       alignment: Alignment.center,
          //       children: [
          //         Opacity(opacity: 0.7,
          //           child: Container(
          //             width: 300,
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: Colors.black38,
          //               borderRadius: BorderRadius.circular(15),
          //             ),
          //           ),
          //         ),
          //         const Text('誤ったQRコードがスキャンされました。',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  // QRコードを読み取る枠の部分
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Util().sheebaDarkGreen,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  /// QR読み取り実装
  ///
  /// @param
  /// - controller QRViewController
  /// @return なし
  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        print('スキャンデータ：${result?.code}');
      });
      // 二重読み取り阻止のため、カメラを止める。
      await controller.pauseCamera();
      _onScanProcess(controller);

      // 2秒後にカメラを再起動する。
      Future.delayed(const Duration(seconds: 1), () {
        controller.resumeCamera();
        setState(() {
          _isErrorScan = false;
        });
      });
    });
  }

  /// QR読み取り後の処理の場合分け
  ///
  /// @param
  /// - controller QRViewController
  /// @return なし
  void _onScanProcess(QRViewController controller) async {
    if (result != null) {
      if (result!.code.toString().length == 28) {
        await _fetchUser(result!.code.toString());

        // ユーザーの取得に失敗した場合
        if (fetchedUser == null) {
          setState(() {
            _isErrorScan = true;
          });
        } else {
          if (fetchedUser!.isStore) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GetPointPage(viewModel: widget.viewModel)
              ),
            );
          }
        }
      } else {
        setState(() {
          _isErrorScan = true;
        });
      }
    } else {
      setState(() {
        _isErrorScan = true;
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SendPointPage(viewModel: widget.viewModel, isError: _isErrorScan, fetcheduser: fetchedUser,)
      ),
    );
  }

  /// パーミッションのセット
  ///
  /// @param
  /// - context コンテキスト
  /// - ctrl QRViewController
  /// - p bool値
  /// @return なし
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  /// 特定のユーザー情報を取得
  ///
  /// @param なし
  /// @return なし
  Future<void> _fetchUser(String uid) async {
    final docRef = FirebaseFirestore.instance.collection(FirebaseChatUser().users).doc(uid);
    await docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final String uid = doc.id;
        final String email = data[FirebaseChatUser().email];
        final String profileImageUrl = data[FirebaseChatUser().profileImageUrl];
        final int point = data[FirebaseChatUser().point];
        final String username = data[FirebaseChatUser().username];
        final String age = data[FirebaseChatUser().age];
        final String address = data[FirebaseChatUser().address];
        final bool isStore = data[FirebaseChatUser().isStore];
        final bool isOwner = data[FirebaseChatUser().isOwner];
        final String os = data[FirebaseChatUser().os];
        fetchedUser = ChatUser(uid, email, profileImageUrl, point, username, age, address, isStore, isOwner, os);
      },
      onError: (e) {
        _isErrorScan = true;
      },
    );
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}