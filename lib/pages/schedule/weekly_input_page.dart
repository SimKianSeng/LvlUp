import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';

//TODO make it possible to remove sessions if wrongly input
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
    //TODO: make it such that time can only be added in blocks of 30mins
    return FloatingActionButton(
      onPressed: () async {
        TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0), confirmText: 'Add start');
        
        if (newTime == null) {
          return;
        }

        TimeOfDay? endTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0), confirmText: 'Add end');

        if (endTime != null) {
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
        }
      },
        child: const Icon(Icons.add_alarm),
      );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add free periods'),
        centerTitle: true,
        ),
      body: _body(_index),
      bottomNavigationBar: _bottomNavigationBar(_index),
      floatingActionButton: _addSession(),
    );
  }
}