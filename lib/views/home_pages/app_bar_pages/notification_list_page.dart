import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/model/notification.dart';
import 'package:sheeba_sample/views/app_components/components.dart';
import 'package:sheeba_sample/views/home_pages/app_bar_pages/notification_detail_page.dart';
import '../../../view_model/view_model.dart';

class NotificationListPage extends StatefulWidget {
  final ViewModel viewModel;
  final AsyncSnapshot<DocumentSnapshot<Object?>> snapshot;
  const NotificationListPage({super.key, required this.viewModel, required this.snapshot});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationModel>>(
      stream: widget.viewModel.fetchNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const ComAppBarText(text: 'お知らせ')
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return ListTile(
                  title: Text(data.title,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data.text, maxLines: 1,),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailPage(
                            viewModel: widget.viewModel,
                            title: data.title,
                            text: data.text,
                            imageUrl: data.imageUrl,
                            url: data.url),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
        );
      }
    );
  }
}