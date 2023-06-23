import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

//TODO transfer into external file?
extension Plus on TimeOfDay {
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

  const Session({super.key, super.minutesDuration = _interval, required super.dateTime, super.color = Colors.green, super.daysDuration, super.onTap, this.task, super.child});

  TimeOfDay startTime() {
    return TimeOfDay(hour: super.dateTime.hour, minute: super.dateTime.minutes);
  }

  TimeOfDay endTime() {
    return TimeOfDay(hour: super.dateTime.hour, minute: super.dateTime.minutes).plusMinutes(super.minutesDuration);
  }

  Session assignTask(String task) {
    //unable to set child field in TimePlannerTask after instanciating
    return Session(dateTime: dateTime, minutesDuration: minutesDuration, task: task, child: Text(task, style: const TextStyle(fontSize: 10.0),),);
  }

  int compareTo(Session other) {
    int otherStartInt = (other.startTime().hour * 60 + other.startTime().minute) * 60;
    int startTimeInt = (startTime().hour * 60 + startTime().minute) * 60;

    return startTimeInt - otherStartInt;
  }

  List<Session> splitIntoBlocks() {
    int numOfBlocks = minutesDuration ~/ _interval;

    if (minutesDuration % _interval == 29) {
      //For sessions that end at 2359h
      numOfBlocks++;
    }

    List<Session> children = List.generate(numOfBlocks,
      (index) => Session(
        minutesDuration: _interval,
        dateTime: TimePlannerDateTime(
          day: super.dateTime.day,
          hour: startTime().plusMinutes(_interval * index).hour,
          minutes: startTime().plusMinutes(_interval * index).minute),
      ));

    return children;
  }

  Session mergeWith(Session other) {
    return Session(dateTime: dateTime, minutesDuration: minutesDuration + other.minutesDuration, task: task, child: child);
  }

  ///For home_page
  Widget displayDayTask(BuildContext context) {
    TimeOfDay start = startTime();
    TimeOfDay end = endTime();

    String todo = "Study $task";
    String timePeriod = "${start.format(context)} - ${end.format(context)}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(todo, style: const TextStyle(fontSize: 20.0)),
            const SizedBox(width: 25.0,),
            Text(timePeriod, style: const TextStyle(fontSize: 20.0)),
          ],
        ),
    );
  }

  ///For available_time_input_page
  Widget displayTime(BuildContext context) {
    TimeOfDay start = startTime();
    TimeOfDay end = endTime();

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Start:'),
          Text(start.format(context)),
          const SizedBox(width: 50.0,),
          const Text('End:'),
          Text(end.format(context)),
        ],
      );
  }
}