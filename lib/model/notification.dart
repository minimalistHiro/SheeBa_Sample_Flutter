import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sheeba_sample/util/firebase_constants.dart';

class NotificationModel {
  NotificationModel({
    required this.title,
    required this.text,
    required this.isRead,
    required this.url,
    required this.imageUrl,
    required this.timestamp,
  });

  final String title;
  final String text;
  final bool isRead;
  final String url;
  final String imageUrl;
  final Timestamp timestamp;

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
        title: data[FirebaseNotification().title],
        text: data[FirebaseNotification().text],
        isRead: data[FirebaseNotification().isRead],
        url: data[FirebaseNotification().url],
        imageUrl: data[FirebaseNotification().imageUrl],
        timestamp: data[FirebaseNotification().timestamp]);
  }
}