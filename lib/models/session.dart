import 'package:flutter/material.dart';

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

//Seems very similar to TimePlannerTask, to extend from it?
class Session extends StatelessWidget {
  //TODO: OOP this
  final int day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  late final int minutesDuration;
  static const int _interval = 30;

  Session({required this.day, required this.startTime, required this.endTime, super.key}) {
    int startTimeInt = (startTime.hour * 60 + startTime.minute);
    int endTimeInt = (endTime.hour * 60 + endTime.minute);

    minutesDuration = endTimeInt - startTimeInt;    
  }

  Widget _startTime(BuildContext context) {
    return Text(startTime.format(context).toString());
  }

  Widget _endTime(BuildContext context) {
    return Text(endTime.format(context));
  }

  //TODO monitor impact on app
  List<Session> splitIntoBlocks() {
    int numOfBlocks = minutesDuration ~/ _interval;

    List<Session> children = List.generate(numOfBlocks, 
      (index) => Session(
        day: day, 
        startTime: startTime.plusMinutes(_interval * index),//startTime.replacing(hour: startTime.hour, minute: startTime.minute + (_interval * index)), 
        endTime: startTime.plusMinutes(_interval * (index + 1))));//endTime.replacing(hour: startTime.hour, minute: startTime.minute + (_interval * index) + _interval)));

    return children;
  }

  int compareTo(Session other) {
    int otherStartInt = (other.startTime.hour * 60 + other.startTime.minute) * 60;
    int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;

    return startTimeInt - otherStartInt;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          const Text('Start:'),
          _startTime(context),
          const SizedBox(width: 50.0,),
          const Text('End:'),
          _endTime(context),
          ],
        )
      ) 
    );
  }
}