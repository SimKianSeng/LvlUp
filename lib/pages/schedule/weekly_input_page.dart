import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_range_picker/time_range_picker.dart';

//TODO make it possible to remove sessions if wrongly input
//TODO ensure that no overlaps are possible
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
            child: Container(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return sessions[index];
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _addSession() {
    return FloatingActionButton(
      onPressed: () async {
        //TODO: currently not possible to add 12am as end
        const TimeOfDay defaultTime = TimeOfDay(hour: 0, minute: 0);
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
          labels: clocklabels
          );

          if (period == null) {
            return;
          }

          TimeOfDay newTime = period.startTime;
          TimeOfDay endTime = period.endTime;

          int startTimeInt = (newTime.hour * 60 + newTime.minute) * 60;
          int endTimeInt = (endTime.hour * 60 + endTime.minute) * 60;

        if (endTimeInt <= startTimeInt) {
          const message = SnackBar(
            content: Text('End time must be after Start time!'),
          );
          
          ScaffoldMessenger.of(context).showSnackBar(message);
        } else {
          setState(() { 
            widget.generator.updateSessions(_index, Session(day: _index,startTime: newTime, endTime: endTime,));
          });
        }
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
        ),
      body: _body(_index),
      bottomNavigationBar: _bottomNavigationBar(_index),
      floatingActionButton: _addSession(),
    );
  }
}