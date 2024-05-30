import 'package:flutter/material.dart';

class ChatUser {
  ChatUser(this.uid,
      this.email,
      this.profileImageUrl,
      this.point,
      this.username,
      this.age,
      this.address,
      this.isStore,
      this.isOwner,
      this.os,
      );

  String uid;
  String email;
  String profileImageUrl;
  int point;
  String username;
  String age;
  String address;
  bool isStore;
  bool isOwner;
  String os;
}

List<DropdownMenuItem<String>>? ageItems = const [
  DropdownMenuItem(
    value: '〜19歳',
    child: Text('〜19歳'),
  ),
  DropdownMenuItem(
    value: '20代',
    child: Text('20代'),
  ),
  DropdownMenuItem(
    value: '30代',
    child: Text('30代'),
  ),
  DropdownMenuItem(
    value: '40代',
    child: Text('40代'),
  ),
  DropdownMenuItem(
    value: '50代',
    child: Text('50代'),
  ),
];

List<DropdownMenuItem<String>>? addressItems = const [
  DropdownMenuItem(
    value: '川口市（芝が付く地域）',
    child: Text('川口市（芝が付く地域）'),
  ),
  DropdownMenuItem(
    value: '川口市（芝が付かない地域）',
    child: Text('川口市（芝が付かない地域）'),
  ),
  DropdownMenuItem(
    value: '蕨市',
    child: Text('蕨市'),
  ),
  DropdownMenuItem(
    value: 'さいたま市',
    child: Text('さいたま市'),
  ),
  DropdownMenuItem(
    value: 'その他',
    child: Text('その他'),
  ),
];