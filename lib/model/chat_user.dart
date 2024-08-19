import 'package:flutter/material.dart';
import 'package:sheeba_sample/util/firebase_constants.dart';

class ChatUser {
  ChatUser({
    required this.uid,
    required this.email,
    required this.profileImageUrl,
    required this.point,
    required this.username,
    required this.age,
    required this.address,
    required this.isStore,
    required this.isOwner,
    required this.os,
  });

  final String uid;
  final String email;
  final String profileImageUrl;
  final int point;
  final String username;
  final String age;
  final String address;
  final bool isStore;
  final bool isOwner;
  final String os;

  factory ChatUser.fromMap(Map<String, dynamic> data) {
    return ChatUser(
        uid: data[FirebaseChatUser().uid],
        email: data[FirebaseChatUser().email],
        profileImageUrl: data[FirebaseChatUser().profileImageUrl],
        point: data[FirebaseChatUser().point],
        username: data[FirebaseChatUser().username],
        age: data[FirebaseChatUser().age],
        address: data[FirebaseChatUser().address],
        isStore: data[FirebaseChatUser().isStore],
        isOwner: data[FirebaseChatUser().isOwner],
        os: data[FirebaseChatUser().os]);
  }
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