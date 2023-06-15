import 'package:flutter/material.dart';

class Session extends StatelessWidget {
  final int day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  late int minutesDuration;

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

  int compareTo(Session other) {
    int otherStartInt = (other.startTime.hour * 60 + other.startTime.minute) * 60;
    int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;

    return startTimeInt - otherStartInt;
  }

  @override
  Widget build(BuildContext context) {
    // return Text('${_startTime()}');
    
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