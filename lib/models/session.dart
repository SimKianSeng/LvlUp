import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

//TODO transfer into external file?
extension on TimeOfDay {
  TimeOfDay plusMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = this.hour * 60 + this.minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }
}

class Session extends TimePlannerTask {
  static const int _interval = 30;
  final String? task;

  Session({super.key, super.minutesDuration = _interval, required super.dateTime, super.color = Colors.green, super.daysDuration, super.onTap, this.task, super.child}) {}

  TimeOfDay _startTime() {
    return TimeOfDay(hour: super.dateTime.hour, minute: super.dateTime.minutes);
  }

  TimeOfDay _endTime() {
    return TimeOfDay(hour: super.dateTime.hour, minute: super.dateTime.minutes).plusMinutes(super.minutesDuration);
  }

  Session assignTask(String task) {
    //unable to set child field in TimePlannerTask after instanciating
    return Session(dateTime: dateTime, minutesDuration: minutesDuration, task: task, child: Text(task, style: const TextStyle(fontSize: 10.0),),);
  }

  int compareTo(Session other) {
    int otherStartInt = (other._startTime().hour * 60 + other._startTime().minute) * 60;
    int startTimeInt = (_startTime().hour * 60 + _startTime().minute) * 60;

    return startTimeInt - otherStartInt;
  }

  List<Session> splitIntoBlocks() {
    int numOfBlocks = minutesDuration ~/ _interval;

    List<Session> children = List.generate(numOfBlocks, 
      (index) => Session(
        minutesDuration: _interval,
        dateTime: TimePlannerDateTime(
          day: super.dateTime.day, 
          hour: _startTime().plusMinutes(_interval * index).hour, 
          minutes: _startTime().plusMinutes(_interval * index).minute),
      ));

    return children;
  }

  ///For weekly_input_page
  Widget displayTime(BuildContext context) {
    TimeOfDay start = _startTime();
    TimeOfDay end = _endTime();

    return GestureDetector(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Start:'),
            Text(start.format(context)),
            const SizedBox(width: 50.0,),
            const Text('End:'),
            Text(end.format(context)),
          ],
        ),
      ),
    );
  }
}