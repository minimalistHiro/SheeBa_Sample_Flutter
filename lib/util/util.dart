import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/model/chat_user.dart';

class Util {
  // 設定値
  final int regisrationPoint = 20;            // 初回登録時付与ポイント
  final int minPasswordLength = 8;            // パスワードの最小長さ

  // Colors
  final Color sheebaYellow = Color(0xfffffbd2);
  final Color sheebaGreen = Color(0xff8eff77);
  final Color sheebaDarkGreen = Color(0xff61a746);
  final Color sheebaBrown = Color(0xffad7045);


  // デフォルト値
  final defaultChatUser = ChatUser(
    '',                     // uid
    'sheeba@gmail.com',     // email
    '',                     // profileImageUrl
    0,                      // point
    '芝太郎',                // username
    '20代',                  // age
    '川口市（芝が付く地域）',    // address
    false,                  // isStore
    false,                  // isOwner
    'iOS',                  // os
  );
}