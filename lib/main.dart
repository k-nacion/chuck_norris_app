import 'package:chuck_norris_app/chuck_norris/dependency_injection.dart';
import 'package:chuck_norris_app/chuck_norris/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(ChuckNorrisApp());
}

class ChuckNorrisApp extends StatelessWidget {
  const ChuckNorrisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chuck Norris Jokes',
      home: MainPage(),
    );
  }
}
