import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/quest.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:lvlup/widgets/session_add_edit.dart';
import 'package:time_planner/time_planner.dart';

class EditQuest extends StatefulWidget {
  const EditQuest({super.key});

  @override
  State<EditQuest> createState() => _EditQuestState();
}

class _EditQuestState extends State<EditQuest> {
  final List<String> _days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
  int _currentIndex = 0;
  List<Session> _quest = [];
  bool edited = false;

  @override
  void initState() {
    super.initState();
    _quest = Quest().retrieveQuest();
  }

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
            child: Text(_days[index]),
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

  ///Converts the session information into a listTile that we can interact with to edit
  Widget _displayEditQuest(Session session) {
    return ListTile(
      title: Text(session.task?? 'No assigned task'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text("Start: ${session.startTime().format(context).padLeft(8, '0')}"),
          Text("End: ${session.endTime().format(context).padLeft(8, '0')}"),
        ],
      ),
      trailing: IconButton(
        onPressed: () async {
          Session? newSession = await showDialog(
            context: context, 
            builder: (_) => EditSessionDialog(
                action: 'Edit',
                originalTask: session.task ?? '',
                originalMinutesDuration: session.minutesDuration,
                startTime: session.dateTime
              ),
            barrierDismissible: false
          );

          if (newSession == null) {
            //Delete
            setState(() {
              Quest().removeSession(session);
              _quest.clear();
              _quest.addAll(Quest().retrieveQuest());
            });
          } else {
            //Replace this session with newSession            
            setState(() {
              Quest().replaceSession(session, newSession);
              _quest.clear();
              _quest.addAll(Quest().retrieveQuest());
            });
          }

          edited = true;
        }, 
        icon: const Icon(Icons.edit)),
    );
  }

  Widget _daySessions() {
    List<Widget> currentDaySession = _quest.where((session) => session.dateTime.day == _currentIndex)
    .map((session) => _displayEditQuest(session))
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

  Widget _addTask() {
    return FloatingActionButton(
      onPressed: () async {
        Session? newSession = await showDialog(
          context: context, 
          builder: (_) => EditSessionDialog(
            action: 'Add',
            originalTask: Generator().modules[0], 
            originalMinutesDuration: 30, //Min interval
            startTime: TimePlannerDateTime(day: _currentIndex, hour: 0, minutes: 0)),
          barrierDismissible: false
          );

        if (newSession != null) {
          setState(() {
            Quest().add(newSession);
            _quest.clear();
              _quest.addAll(Quest().retrieveQuest());
            // _quest.add(newSession);
          });
        }

        edited = true;
      },
      child: const Icon(Icons.add),
      );
  }

  @override
  Widget build(BuildContext context) {    
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit quest'), 
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: useHint('To be able to change to a certain module, do ensure that it has been inputted into generator'),
            ),
          ],),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _daysOption(),
            _daySessions(),
          ],
          ),
        floatingActionButton: _addTask(),
        ), 
      onWillPop: () async {
        //Returns the updated quest to quest_page
        Navigator.pop(context, edited);
        return false;
      }
    );
  }
}