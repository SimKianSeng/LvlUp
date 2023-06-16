import 'package:flutter/material.dart';

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

  List<Session> splitIntoBlocks() {
    //minutesDuration will be in multiples of 30
    int numOfBlocks = minutesDuration ~/ _interval;

    //TODO issues with splitting
    List<Session> children = List.generate(numOfBlocks, 
      (index) => Session(
        day: day, 
        startTime: startTime.replacing(hour: startTime.hour, minute: startTime.minute + (_interval * index)), 
        endTime: endTime.replacing(hour: startTime.hour, minute: startTime.minute + (_interval * index) + _interval)));

    return children;
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