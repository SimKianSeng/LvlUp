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
  late DateTime _start;
  Duration? _duration;
  Timer? _timer;
  Duration? _breakDuration;
  bool _resting = false;

  @override
  void initState() {
    super.initState();
    _start = DateTime.now();
  }

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

        //TODO when _breakDuration passes 0seconds, it resets to 1minute
        _breakDuration = _resting ? Duration(seconds: _breakDuration!.inSeconds - 1) : _breakDuration; //Countdown
      }
    });
  }

  ///Toggle break mode
  void _pauseResumeTimer() {
    _resting = !_resting;
  }


  void _stopTimer() {
    //TODO end the study session and remove it from study sessions for the day in home
    setState(() => _timer!.cancel());
    Navigator.pop(context, DateTime.now().difference(_start));
  }

  Widget time() {
    int hour = _duration!.inHours % 24;
    int min = _duration!.inMinutes % 60;
    int seconds = _duration!.inSeconds % 60;

    return Text("${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 45.0)
    );
  }

  Widget breakTime() {
    bool hasExceededBreak = _breakDuration!.isNegative;

    int hour, min, seconds;

    if (hasExceededBreak) {
      hour = 24 - (_breakDuration!.inHours % 24);
      min = 60 - (_breakDuration!.inMinutes % 60);
      seconds = 60 - (_breakDuration!.inSeconds % 60);

      //Fix formatting
      hour = hour == 24 ? 0 : hour;
      min = min == 60 ? 0 : min;
      seconds = seconds == 60 ? 0 : seconds;
    } else {
      hour = _breakDuration!.inHours % 24;
      min = _breakDuration!.inMinutes % 60;
      seconds = _breakDuration!.inSeconds % 60;
    }
    
    return hasExceededBreak
      ? Text("Exceeded break time: ${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
      style: TextStyle(fontSize: 25.0, color: Colors.red[900]))
      : Text("Remaining break time: ${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
      style: TextStyle(fontSize: 25.0, color: Colors.green[800])
    );
  }

  Widget breakButton() {
    //TODO find and replace with a better icon to illustrate taking a break and resume study
    return IconButton(
      onPressed: _pauseResumeTimer,
      icon: _resting ? const Icon(Icons.play_arrow_rounded, size: 75.0, color: Colors.green,) : const Icon(Icons.pause_circle_rounded, size: 75.0, color: Colors.red,));
  }

  //TODO monitor, does not seem entirely responsive
  Widget stopButton() {
    return IconButton(
      onPressed: _stopTimer,
      icon: const Icon(Icons.stop_circle_rounded, size: 75.0,));
  }

  @override
  Widget build(BuildContext context) {
    
    Map<String, Duration> durations = ModalRoute.of(context)!.settings.arguments as Map<String, Duration>;
    _duration ??= durations['duration'];
    _breakDuration ??= durations['break'];

    _startTimer();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            _stopTimer();
          },
        ),
        title: const Text('Timer'),
        centerTitle: true,),
      body: Container(
        decoration: bgColour,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            time(),
            const SizedBox(height: 35.0,),
            breakTime(),
            const SizedBox(width: double.infinity,height: 150.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // stopButton(),
                const SizedBox(width: 105.0),
                breakButton(),
              ],
            )

          ]),
      ),
    );
  }
}
