import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/time_planner.dart';

//TODO: add in edit generated quest functionality
//TODO update firebase on module
class Quest extends StatefulWidget {
  const Quest({super.key});

  @override
  State<Quest> createState() => _QuestState();
}

class _QuestState extends State<Quest> {
  List<Session> _task = [];
  late bool _acceptedQuest;

  @override
  void initState() {
    super.initState();
    // _task = Generator().getSavedQuest();
    _acceptedQuest = true;
  }

  ///Provides a button that brings user to the generator input page
  Widget _generatorButton() {
    return ElevatedButton(
      style: customButtonStyle(),
      onPressed: () {
        Navigator.pushNamed(context, '/scheduleInput');
      },
      child: const Text("Generator"),
    );
  }

  ///Provides a button for user to generate a schedule based on previous input to the generator
  Widget _generateButton() {
    return ElevatedButton(
      style: customButtonStyle(),
      onPressed: () {
        if (Generator().hasNoInput()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Please input your modules and free periods in generator")));
        } else {
          setState(() {
            _task.clear();
            _task.addAll(Generator().generateSchedule());
            _acceptedQuest = false;
          });
        }
      },
      child: const Text("Generate"),
    );
  }

  Widget _schedule() {
    const int start = 0;
    const int end = 23;
    List<TimePlannerTitle> headers = [
      'Mon',
      'Tues',
      'Wed',
      'Thurs',
      'Fri',
      'Sat',
      'Sun'
    ].map((day) => TimePlannerTitle(title: day)).toList();
    TimePlannerStyle style = TimePlannerStyle(cellWidth: 46);

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
    final user = ModalRoute.of(context)!.settings.arguments as AppUser;

    if (_task.isEmpty) {
      _task.addAll(user.getSavedQuest());
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Quest"),
        centerTitle: true,
        actions: [ 
          IconButton(
              onPressed: _acceptedQuest
                  ? null
                  : () {
                      user.acceptQuest(_task);
                      setState(() {
                        _acceptedQuest = !_acceptedQuest;
                      });
                    },
              icon: const Icon(Icons.save),
              color: Colors.black,
              disabledColor: Colors.grey,
              tooltip: 'Accept quest')
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
