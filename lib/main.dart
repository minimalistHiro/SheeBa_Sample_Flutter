import 'package:flutter/material.dart';
import 'package:sheeba_sample/view_model/view_model.dart';
import 'package:sheeba_sample/views/entry_pages/entry_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase初期化処理
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
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
      home: EntryPage(viewModel: viewModel),
    );
  }
}
