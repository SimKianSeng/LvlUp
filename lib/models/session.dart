import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';
import 'package:lvlup/utils/timeofday_extensions.dart';


class Session extends TimePlannerTask {
  static const int breakRate = 5; //5 minutes for every multiple of _interval
  static const int _interval = 30;
  final String? task;

  const Session({super.key, super.minutesDuration = _interval, required super.dateTime, super.color = Colors.green, super.daysDuration, super.onTap, this.task, super.child});

  Session.fromJson(Map<dynamic, dynamic> json)
        : task = json['task'],
          super(key: null, minutesDuration: json['minutesDuration'], color: Colors.green, dateTime: TimePlannerDateTime(day: json['day'], hour: json['startHour'], minutes: json['startMin']), child: Text(json['task'], style: const TextStyle(fontSize: 10.0)));

  TimeOfDay startTime() {
    return TimeOfDay(hour: super.dateTime.hour, minute: super.dateTime.minutes);
  }

  TimeOfDay endTime() {
    return TimeOfDay(hour: super.dateTime.hour, minute: super.dateTime.minutes).plusMinutes(super.minutesDuration);
  }

  @visibleForTesting
  int breakDuration() {
    //Does not account for sessions till 2359H
    int breakDurationMinutes= super.minutesDuration ~/ _interval * breakRate;

    return breakDurationMinutes;
  }

  Duration breakRemaining(Duration durationDelayed) {
    int minutesDelayed = durationDelayed.inMinutes; //Minutes used here for leniency, to account for time needed to enter app and start timer
    
    int breakMinutesRemaining = breakDuration() - minutesDelayed;

    return Duration(minutes: breakMinutesRemaining);
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
          Text('Start: ${start.format(context).padLeft(5, '0')}'),
          const SizedBox(width: 50.0,),
          Text('End: ${end.format(context).padLeft(5, '0')}'),
        ],
      );
  }
}