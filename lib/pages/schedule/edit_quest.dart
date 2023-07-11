import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/session.dart';

class EditQuest extends StatefulWidget {
  const EditQuest({super.key});

  @override
  State<EditQuest> createState() => _EditQuestState();
}

class _EditQuestState extends State<EditQuest> {
  final List<String> days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
  int _currentIndex = 0;
  List<Session> _quest = [];

  Widget _day(String heroTag, int index) {
    if (index < 0 || index > 6) {
      //Not within bounds, set index to 0 (Mon)
      index = 0;
    }

    bool selected = _currentIndex == index;

    //mon is indexed 0(default value) and sunday is indexed 6
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.5),
      child: FloatingActionButton(
            heroTag: heroTag,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            backgroundColor: selected ? Colors.purple[400] : Colors.purple[100], // Selected day will be darker in colour
            elevation: 0.0,
            onPressed: () {
              setState(() {
                //Update display of sessions to be of the current day
                _currentIndex = index;
              });
            },
            child: Text(days[index]),
            ),
    );

  }

  Widget _daysOption() {
    List daysIndex = List.generate(7, (index) => index, growable: false);

    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: daysIndex.map((index) => _day('Button $index', index)).toList(),
      ),
    );
  }

  Widget _daySessions() {
    List<Widget> currentDaySession = _quest.where((session) => session.dateTime.day == _currentIndex)
    .map((session) => session.displayEditQuest(context))
    .toList();

    return Expanded(
      flex: 9,
      child: Container(
        decoration: contentContainerColour(blRadius: 0.0, brRadius: 0.0),
        child: ListView(
          children: currentDaySession,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _quest = ModalRoute.of(context)!.settings.arguments as List<Session>;


    return Scaffold(
      appBar: AppBar(title: const Text('Edit quest')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _daysOption(),
          _daySessions(),
        ],
        ),
      );
  }
}