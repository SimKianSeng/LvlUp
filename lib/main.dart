import 'package:lvlup/models/user.dart';
import 'package:lvlup/pages/schedule/quest_page.dart';
import 'package:lvlup/pages/schedule/schedule_input.dart';
import 'package:lvlup/pages/schedule/available_time_input_page.dart';
import 'package:lvlup/pages/settings_page.dart';
import 'package:lvlup/pages/study_stats_page.dart';
import 'package:lvlup/pages/timer_page.dart';
import 'package:lvlup/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lvlup/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: Auth().authStateChanges,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WidgetTree(),
          '/settings': (context) => const Settings(),
          '/scheduleGen': (context) => const Quest(),
          '/studyStats': (context) => const StudyStats(),
          '/scheduleInput': (context) => const ScheduleInput(),
          '/weeklyInput': (context) => WeeklyInput(),
          '/timer': (context) => Timer()
        },
      ),
    );
  }
}
