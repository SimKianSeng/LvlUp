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
          Text('Start: ${start.format(context).padLeft(8, '0')}'),
          const SizedBox(width: 50.0,),
          Text('End: ${end.format(context).padLeft(8, '0')}'),
        ],
      );
  }

  ///Dialog box for user to edit the session
  AlertDialog _editSessionDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit session'),
      content: Placeholder(), //TODO add stuff to change the session info
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            //TODO pop off alertdialog and update the session field
          }, 
          child: const Text('Accept changes'))
      ],
    );
  }

  ///Display quest sessions in editable mode for edit_quest page
  Widget displayEditQuest(BuildContext context) {
    return ListTile(
      title: Text(task?? 'No assigned task'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Start: ${startTime().format(context).padLeft(8, '0')}"),
          Text("End: ${endTime().format(context).padLeft(8, '0')}"),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          //TODO remove session, edit time or edit task in dialog box
          showDialog(
            context: context, 
            builder: (_) {
              return _editSessionDialog(context);
            },
            barrierDismissible: false
            );
        }, 
        icon: const Icon(Icons.edit)),
    );
  }
}