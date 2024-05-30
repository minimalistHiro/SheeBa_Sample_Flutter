import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sheeba_sample/view_model/view_model.dart';
import 'views/bottom_tab _page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase初期化処理
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ViewModel viewModel = ViewModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SheeBa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff8eff77)),
        useMaterial3: true,
      ),
      home: BottomTabPage(viewModel: viewModel)
      // StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     // if (snapshot.connectionState == ConnectionState.waiting) {
      //     //   // スプラッシュ画面などに書き換えても良い
      //     //   return const SizedBox();
      //     // }
      //     if (snapshot.hasData) {
      //       // Userがnullでなない、つまりサインイン済みのホーム画面へ
      //       return BottomTabPage(viewModel: viewModel,);
      //     }
      //     // Userがnullである、つまり未サインインのサインイン画面へ
      //     return EntryPage(viewModel: viewModel);
      //   },
      // ),
    );
  }
}
