import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_planner/time_planner.dart';
import 'package:time_range_picker/time_range_picker.dart';

//TODO: additional feature - edit sessions time if wrongly input, rn can just delete
class WeeklyInput extends StatefulWidget {
  final List<String> days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
  final Generator generator = Generator();

  WeeklyInput({super.key});

  @override
  State<WeeklyInput> createState() => _WeeklyInputState();
}

class _WeeklyInputState extends State<WeeklyInput> {
  int _index = 0;
  late List<Session> sessions;

  @override
  void initState() {
    super.initState();
    sessions = widget.generator.sessions[_index];
  }

  Widget _bottomNavigationBar(int selectedIndex) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      items: widget.days
          .map<BottomNavigationBarItem>( (e) => BottomNavigationBarItem(icon: const Icon(Icons.calendar_today), label: e, backgroundColor: Colors.black))
          .toList(),

      onTap: (value) {
        setState(() {
          _index = value;
          sessions = widget.generator.sessions[value];
        });
      },
    );
  }

  Widget _body(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Text(
              widget.days[index], 
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        Expanded(
          flex: 9,
          child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: sessions[index].displayTime(context),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: "Tap to remove input session",
                    onPressed: () {
                      setState(() {
                        widget.generator.removeSession(_index, sessions[index]);
                      });
                    },
                  ),
                );
              },
            ),
        ),
      ],
    );
  }

  
  void _add(TimeRange? period) {
    if (period == null) {
      return;
    }

    TimeOfDay newTime = period.startTime;
    TimeOfDay endTime = period.endTime;

    if (endTime.format(context) == "12:00 AM") {
      //To allow us to add from xxxxH to 0000H
      endTime = const TimeOfDay(hour: 23, minute: 59);
    }

    int startTimeInt = newTime.hour * 60 + newTime.minute;
    int endTimeInt = endTime.hour * 60 + endTime.minute;
    int minutesDuration = endTimeInt - startTimeInt;

    if (minutesDuration <= 0) {
      const message = SnackBar(
        content: Text('End time must be after Start time!'),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(message);
    } else {
      setState(() { 
        widget.generator.updateSessions(_index, Session(
          dateTime: TimePlannerDateTime(day: _index, hour: newTime.hour, minutes: newTime.minute),
          minutesDuration: minutesDuration));
      });
    }
  }

  Widget _addSession() {
    return FloatingActionButton(
      onPressed: () async {
        const TimeOfDay defaultTime = TimeOfDay(hour: 10, minute: 30);
        const Duration periodInterval = Duration(minutes: 30);
        final List<ClockLabel> clocklabels = ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"]
          .asMap().entries.map((e) => ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value))
          .toList();

        TimeRange? period = await showTimeRangePicker(
          context: context,
          start: defaultTime,
          interval: periodInterval,
          ticks: 24,
          clockRotation: 180,
          labels: clocklabels,
          );

        _add(period);
      },
        child: const Icon(Icons.add_alarm),
      );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add free periods'),
        centerTitle: true,
        actions: const <Widget>[
          Tooltip(
            message: 'Free periods are periods of time whereby you are available for your study session to be generated at',
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(Icons.help),
          )
        ],
        ),
      body: _body(_index),
      bottomNavigationBar: _bottomNavigationBar(_index),
      floatingActionButton: _addSession(),
    );
  }
}