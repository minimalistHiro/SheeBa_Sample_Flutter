import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class CustomSingleDialog extends StatelessWidget {
//   final String title;
//   final String text;
//
//   const CustomSingleDialog({
//     super.key,
//     required this.title,
//     required this.text,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(text),
//       actions: [
//         TextButton(
//           child: Text('OK'),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ],
//     );
//   }
// }

/// シングルダイアログを表示する
///
/// @param
/// - context - コンテキスト
/// - title - タイトル
/// - text - テキスト
/// @return ダイアログWidget
Future<void> CustomShowSingleDialog(
    BuildContext context,
    String title,
    String text,
    VoidCallback? action
    ) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => action ?? Navigator.pop(context),
            ),
          ],
        );
      }
  );
}

// class CustomDoubleDialog extends StatelessWidget {
//   final String title;
//   final String text;
//   final String okText;
//   final Color textColor;
//   final VoidCallback? action;
//
//   const CustomDoubleDialog({
//     super.key,
//     required this.title,
//     required this.text,
//     required this.okText,
//     required this.textColor,
//     required this.action
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(text),
//       actions: [
//         TextButton(
//           child: const Text('キャンセル'),
//           onPressed: () => Navigator.pop(context),
//         ),
//         TextButton(
//           onPressed: action,
//           child: Text(okText, style: TextStyle(color: textColor),),
//         ),
//       ],
//     );
//   }
// }


/// ダブルダイアログを表示する
///
/// @param
/// - context - コンテキスト
/// - title - タイトル
/// - text - テキスト
/// - okText - 実行処理テキスト
/// - textColor - 実行処理テキストカラー
/// - action - 実行処理
/// @return ダイアログWidget
Future<void> CustomShowDoubleDialog(
    BuildContext context,
    String title,
    String text,
    String okText,
    Color textColor,
    VoidCallback? action
    ) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              onPressed: action,
              child: Text(okText, style: TextStyle(color: textColor),),
            ),
          ],
        );
      }
  );
}