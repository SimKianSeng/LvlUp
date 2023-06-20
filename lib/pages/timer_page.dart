import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerState();
}

//TODO implement gamified features, pausing feature and ability to change page without destroying current page and progress earned
//TODO add in grace period for break and link to exp
//TODO add in a stopwatch to track time spent studying
class _TimerState extends State<TimerPage> {
  Duration? _duration;
  Timer? _timer;

  void _startTimer() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      _countDown();
    });
  }
  
  void _countDown() {
    setState(() {
      if (_duration!.inSeconds <= 0) {
        _stopTimer();
      } else {
        _duration = Duration(seconds: _duration!.inSeconds - 1);
      }
    });
  }

  //Toggle break mode
  void _pauseResumeTimer() {
    // TODO pause timer and start grace period timer

  }

  void _stopTimer() {
    //TODO end the study session and remove it from study sessions for the day in home?
    //TODO factor in exp changes
    setState(() => _timer!.cancel());
    Navigator.pop(context);
  }

  Widget time() {
    int hour = _duration!.inHours % 24;
    int min = _duration!.inMinutes % 60;
    int seconds = _duration!.inSeconds % 60;

    return Text("${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 45.0)
    );
  }

  Widget pauseButton() {
    return IconButton(
      onPressed: _pauseResumeTimer, 
      icon: const Icon(Icons.pause_circle_rounded, size: 75.0,));
  }

  
  Widget stopButton() {
    return IconButton(
      onPressed: _stopTimer, 
      icon: const Icon(Icons.stop_circle_rounded, size: 75.0,));
  }

  @override
  Widget build(BuildContext context) {

    _duration ??= ModalRoute.of(context)!.settings.arguments as Duration;

    _startTimer();


    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text('Timer'), centerTitle: true,),
      body: Container(
        decoration: bgColour,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            time(),
            const SizedBox(width: double.infinity,height: 150.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                stopButton(),
                const SizedBox(width: 105.0),
                pauseButton(),
              ],
            )

          ]),
      ),
    );
  }
}