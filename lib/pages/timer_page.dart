import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/game_logic/xp.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerState();
}

//TODO find ways to navigate app without removing progress and session
class _TimerState extends State<TimerPage> {
  late Session session;
  late DateTime _start;
  Duration? _duration;
  Timer? _timer;
  Duration? _breakDuration;
  bool _resting = false;
  int xpGain = 0;

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

        xpGain = Xp.studyTimeToXp(DateTime.now().difference(_start));

        //TODO when _breakDuration passes 0seconds, it resets to 1minute
        _breakDuration = _resting
            ? Duration(seconds: _breakDuration!.inSeconds - 1)
            : _breakDuration; //Countdown
      }
    });
  }

  ///Toggle break mode
  void _pauseResumeTimer() {
    _resting = !_resting;
  }

  void _stopTimer() {
    setState(() => _timer!.cancel());

    Navigator.pop(context, [xpGain, session]);
    // Navigator.pop(context, DateTime.now().difference(_start));
  }

  Widget xpDisplay() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "XP gained:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            xpGain.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ]);
  }

  Widget time() {
    int hour = _duration!.inHours % 24;
    int min = _duration!.inMinutes % 60;
    int seconds = _duration!.inSeconds % 60;

    return Text(
        "${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
        style: const TextStyle(fontSize: 45.0));
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
        ? Text(
            "Exceeded break time: ${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 25.0, color: Colors.red[900]))
        : Text(
            "Remaining break time: ${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 25.0, color: Colors.green[800]));
  }

  Widget breakButton() {
    return _resting
      ? TextButton(
        onPressed: _pauseResumeTimer, 
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
          )
        ),
        child: const Text(
          'Resume session',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0
          ),
          )
        )
      : TextButton(
        onPressed: _pauseResumeTimer, 
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
          )
        ),
        child: const Text(
          'Take break',
          style:TextStyle(
            color: Colors.white,
            fontSize: 20.0
          )
        )
        );
  }

  //TODO monitor, does not seem entirely responsive
  Widget stopButton() {
    return TextButton(
        onPressed: _stopTimer,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red[900]!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
          )
        ),
        child: const Text(
          'End session',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    
    Map<String, dynamic> durations = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    session = durations['session'] as Session;
    _duration ??= durations['duration'] as Duration;
    _breakDuration ??= durations['break'] as Duration;

    _startTimer();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: BackButton(
        //   onPressed: () {
        //     _stopTimer();
        //   },
        // ),
        title: const Text('Timer'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        decoration: bgColour,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: xpDisplay(),
              ),
            ),
            const SizedBox(height: 100),
            time(),
            const SizedBox(height: 35.0,),
            breakTime(),
            const SizedBox(width: double.infinity,height: 100.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                stopButton(),
                const SizedBox(width: 55.0),
                breakButton(),
              ],
            )
          ]),
      ),
    );
  }
}
