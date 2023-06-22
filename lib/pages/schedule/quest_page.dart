import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_planner/time_planner.dart';

//TODO: edit generated quest functionality
//TODO update firebase on schedule and modules
class Quest extends StatefulWidget {
  const Quest({super.key});

  @override
  State<Quest> createState() => _QuestState();
}

class _QuestState extends State<Quest> {
  List<Session> _task = [];

  @override
  void initState() {
    super.initState();
    _task = Generator().getSavedQuest();
  }

  ///Provides a button that brings user to the generator input page
  Widget _generatorButton() {
  return ElevatedButton(
    style: customButtonStyle(),
    onPressed: () {
      Navigator.pushNamed(context, '/scheduleInput');
    },
    child: const Text("Generator"),);
}

  ///Provides a button for user to generate a schedule based on previous input to the generator
  Widget _generateButton() {
    return ElevatedButton(
      style: customButtonStyle(),
      onPressed: () {
        setState(() {
          _task.clear();
          _task.addAll(Generator().generateSchedule());
        });
      },
      child: const Text("Generate"),
    );
  }

  Widget _schedule() {
    const int start = 0;
    const int end = 23;
    List<TimePlannerTitle> headers = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'].map((day) => TimePlannerTitle(title: day)).toList();
    TimePlannerStyle style = TimePlannerStyle(
      cellWidth: 46
    );

    return TimePlanner(
      startHour: start, 
      endHour: end, 
      headers: headers,
      style: style,
      tasks: _task,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Quest"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              //TODO change to user
              Generator().acceptQuest(_task);
            }, 
            child: const Text('Accept quest', style: TextStyle(color: Colors.black),))
        ],
        ),
      body: Container(
        decoration: bgColour,
        child: _schedule(),
      ),
      bottomNavigationBar: NavigationBar(
        height: 50.0,
        backgroundColor: Colors.white30,
        destinations: [
          _generatorButton(),
          _generateButton(),
        ],
      ),
    );
  }
}