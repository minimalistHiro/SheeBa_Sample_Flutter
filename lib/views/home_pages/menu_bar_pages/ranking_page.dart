import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/model/chat_user.dart';
import 'package:sheeba_sample/views/app_components/components.dart';
import '../../../view_model/view_model.dart';
import '../../app_components/custom_icon_image.dart';

class RankingPage extends StatefulWidget {
  final ViewModel viewModel;
  const RankingPage({super.key, required this.viewModel});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatUser>>(
      stream: widget.viewModel.fetchAllUsersOrderByMoney(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Scaffold(
          appBar: AppBar(
            title: ComAppBarText(text: 'ランキング'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 5,right: 20),
            child: ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return ListTile(
                  leading: CustomWebIcon(imageUrl: data.profileImageUrl, scale: 0.5),
                  title: Text(data.username,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data.point.toString(), maxLines: 1,),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(color: Colors.white,);
              },
            ),
          ),
        );
      }
    );
  }
}