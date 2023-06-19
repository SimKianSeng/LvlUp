import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

//TODO implement gamified features, pausing feature and ability to change page without destroying current page and progress earned
class _TimerState extends State<Timer> {
  late int hour;
  late int min;
  late int seconds;

  Widget timer(Duration time) {
    hour = time.inHours;
    min = time.inMinutes % 60;
    seconds = time.inSeconds % 60;

    return Text("$hour : $min : $seconds",
    style: TextStyle(fontSize: 45.0));
  }

  @override
  Widget build(BuildContext context) {

    final duration = ModalRoute.of(context)!.settings.arguments as Duration;


    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text('Timer'), centerTitle: true,),
      body: Container(
        decoration: bgColour,
        child: Column(
          children: [
            SizedBox(width: double.infinity,),
            timer(duration)
          ]),
      ),
    );
  }
}