import 'package:flutter/material.dart';
import 'package:lvlup/models/quest.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/utils/timeofday_extensions.dart';
import 'package:time_planner/time_planner.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditSessionDialog extends StatefulWidget {
  static const Map<String, String> actions = {'Add' : 'New task', 'Edit': 'Edit session'};
  final String action;
  final String originalTask;
  final int originalMinutesDuration;
  final TimePlannerDateTime startTime;

  const EditSessionDialog({required this.action, required this.originalTask, required this.originalMinutesDuration, required this.startTime, super.key});

  @override
  State<EditSessionDialog> createState() => _EditSessionDialogState();
}

class _EditSessionDialogState extends State<EditSessionDialog> {
  late String newTask;
  late TimePlannerDateTime newStartTime;
  late int newMinutesDuration;
  late List<DropdownMenuItem<String>> modules;
  String message = '';
  
  @override
  void initState() {
    super.initState();
    newTask = widget.originalTask;
    newStartTime = widget.startTime;
    newMinutesDuration = widget.originalMinutesDuration;
    modules = Generator().modules
              .where((module) => module != '' && module != 'duplicate' && module != 'free')
              .map((module) => DropdownMenuItem(
                value: module,
                child: Text(module)))
              .toList();

    if (!(Generator().modules.contains(widget.originalTask))) {
      //original task does not exist in generator, to add into list
      modules.add(DropdownMenuItem(
        value: widget.originalTask,
        child: Text(widget.originalTask),
      ));
    }
  }

  void _changeTime(TimeRange? period) {
    if (period == null) {
      // No change
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
      setState(() {
        message = 'End time must be after Start time!';
      });
    } else if (Quest().timeOverlaps(newTime, endTime, widget.startTime, originalMinutesDuration: widget.action == 'Add' ? 0 : widget.originalMinutesDuration)) {
      setState(() {
        message = 'Chosen timing collide with other tasks!';
      });
    } else {
      setState(() {
        message = ''; //Reset message

        //Same day
        newStartTime = TimePlannerDateTime(day: newStartTime.day, hour: newTime.hour, minutes: newTime.minute);
        newMinutesDuration = minutesDuration;
      });
    }
  }

  Widget _timePicker() {
    TimeOfDay startTime = TimeOfDay(hour: newStartTime.hour, minute: newStartTime.minutes);
    TimeOfDay endTime = startTime.plusMinutes(newMinutesDuration);
    const Duration periodInterval = Duration(minutes: 30);
    final List<ClockLabel> clocklabels = ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"]
          .asMap().entries.map((e) => ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value))
          .toList();

    return TextButton(
      onPressed: () async {
        TimeRange? period = await showTimeRangePicker(
          context: context,
          start: startTime,
          end: endTime,
          interval: periodInterval,
          ticks: 24,
          clockRotation: 180,
          labels: clocklabels
        );

        //Period change
        _changeTime(period);
      }, 
      child: const Text('Change time period')
      );
  }

  Widget _selectedTime() {
    String startTime = TimeOfDay(hour: newStartTime.hour, minute: newStartTime.minutes).format(context);
    String endTime = TimeOfDay(hour: newStartTime.hour, minute: newStartTime.minutes).plusMinutes(newMinutesDuration).format(context);

    return Text('$startTime to $endTime');
  }
  
  Widget _moduleSelections() {
    return DropdownButton(
      items: modules, 
      onChanged: (dynamic selectedValue) {
        setState(() {
          //Display
          newTask = selectedValue;
        });
      },
      value: newTask,
    );
  }

  List<Widget> actionsBar() {
    if (widget.action == 'Add') {
      return <Widget>[
        TextButton(
          //Pops off the edit actiondialog and returns the newly added session
          onPressed: () {
            Navigator.pop(context, 
            Session(
              task: newTask, 
              minutesDuration: newMinutesDuration, 
              dateTime: newStartTime, 
              child: Text(
                newTask, 
                style: const TextStyle(fontSize: 10.0),
                ),
              ));
          },
          child: const Text('Done')
        ),
        TextButton(
          //Pops off the edit actiondialog and returns the newly edited session no matter whether it has been edited
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel')
        )
      ];
    } else if (widget.action == 'Edit') {
      return <Widget>[
        TextButton(
          //Pops off the edit actiondialog and returns the newly edited session no matter whether it has been edited
          onPressed: () {
            Navigator.pop(context, 
            Session(
              task: newTask, 
              minutesDuration: newMinutesDuration, 
              dateTime: newStartTime, 
              child: Text(
                newTask, 
                style: const TextStyle(fontSize: 10.0),
                ),
              ));
          },
          child: const Text('Done')
        ), 
        IconButton(
          onPressed: () {
            //Deleting the current session returns null
            Navigator.pop(context, null);
          }, 
          icon: const Icon(Icons.delete)
        )
      ];
    }

    return [
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.close))
    ];
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(EditSessionDialog.actions[widget.action] ?? 'Error'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Module', style: TextStyle(fontWeight: FontWeight.bold),),
          _moduleSelections(),
          const SizedBox(height: 35.0,),
          const Text('Time of session', style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 15.0,),
          _selectedTime(),
          _timePicker(),
          Text(message, style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red[900]),)
        ],
      ), 
      actions: actionsBar(),
    );
  }
}