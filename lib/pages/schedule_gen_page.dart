import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';

class ScheduleGen extends StatefulWidget {
  const ScheduleGen({super.key});

  @override
  State<ScheduleGen> createState() => _ScheduleGenState();
}

Widget _GeneratorButton() {
  return ElevatedButton(
    style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
    onPressed: () {

    },
    child: const Text("Generator"),);
}

class _ScheduleGenState extends State<ScheduleGen> {

  Widget _editButton() {
    return ElevatedButton(
    style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
    onPressed: () {

    },
    child: const Text("Edit"),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule")),
      body: Container(
        decoration: bgColour,
      ),
      bottomNavigationBar: NavigationBar(
        height: 50.0,
        backgroundColor: Colors.white30,
        destinations: [
          _GeneratorButton(),
          _editButton(),
        ],
      ),
    );
  }
}