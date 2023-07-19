import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';
import 'package:time_planner/time_planner.dart';
import 'package:lvlup/services/generator.dart';

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
      //original task does not exist in generator anymore
      modules.add(DropdownMenuItem(
        value: widget.originalTask,
        child: Text(widget.originalTask),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    //TODO time picking

    return AlertDialog(
      title: Text(EditSessionDialog.actions[widget.action] ?? 'Error'),
      content: Column(
        children: <Widget>[
          //TODO ensure that original task appears in the list
          DropdownButton(
            items: modules, 
            onChanged: (dynamic selectedValue) {

              setState(() {
                //Display
                newTask = selectedValue;
              });

              //TODO update the current session time
            },
            value: newTask,
            )
        ],
      ), 
      actions: [
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
            //TODO delete the current session
            Navigator.pop(context, null);
          }, 
          icon: const Icon(Icons.delete)
        )
      ],
    );
  }
}