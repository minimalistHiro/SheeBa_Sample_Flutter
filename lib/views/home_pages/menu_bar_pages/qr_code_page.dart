import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sheeba_sample/views/app_components/custom_icon_image.dart';
import '../../../view_model/view_model.dart';

class QRCodePage extends StatefulWidget {
  final ViewModel viewModel;
  final String uid;
  final String username;
  final String imageUrl;
  const QRCodePage({super.key, required this.viewModel, required this.username, required this.imageUrl, required this.uid});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // カード背景
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // トップ画像
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CustomWebIcon(imageUrl: widget.imageUrl, scale: 0.5,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(widget.username,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: QrImageView(data: widget.uid, size: 200,),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}