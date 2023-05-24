import 'package:lvlup/pages/scheduleGen_page.dart';
import 'package:lvlup/pages/settings_page.dart';
import 'package:lvlup/pages/studyStats_page.dart';
import 'package:lvlup/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WidgetTree(),
        '/settings': (context) => Settings(),
        '/scheduleGen':(context) => ScheduleGen(),
        '/studyStats':(context) => StudyStats(),
      },
    );
  }
}