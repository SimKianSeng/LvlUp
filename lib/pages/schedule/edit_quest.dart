import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:lvlup/widgets/edit_session_alertdialog.dart';
import 'package:time_planner/time_planner.dart';


//TODO update quest_page with the newly updated quest from this page, pass back through navigator?
//TODO add in edit session actiondialog
//TODO add in a session, but not clash timing with other sessions
class EditQuest extends StatefulWidget {
  const EditQuest({super.key});

  @override
  State<EditQuest> createState() => _EditQuestState();
}

class _EditQuestState extends State<EditQuest> {
  final List<String> _days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
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
        children: [
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
            print('deleting');
            setState(() {
              _quest.remove(session);
            });
          } else {
            //Replace this session with newSession            
            setState(() {
              _quest.replaceRange(_quest.indexOf(session), _quest.indexOf(session) + 1, [newSession]);  
            });
          }
        }, 
        icon: const Icon(Icons.edit)),
    );
  }

  //TODO what if i place this in a new file under a stateful widget
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
    String module = Generator().modules[0];

    return FloatingActionButton(
      onPressed: () async {
        Session? newSession = await showDialog(
        context: context, 
        builder: (_) => EditSessionDialog(
          action: 'Add',
          originalTask: module, 
          originalMinutesDuration: 30, //Min interval
          startTime: TimePlannerDateTime(day: _currentIndex, hour: 0, minutes: 0)),
        barrierDismissible: false
        );

        if (newSession != null) {
          setState(() {
            //TODO sort the ordering based on start time 
            _quest.add(newSession);
          });
        }
      },
      child: const Icon(Icons.add),
      );
  }

  @override
  Widget build(BuildContext context) {
    _quest = ModalRoute.of(context)!.settings.arguments as List<Session>;

    //TODO WillPopScope prevents us from viewing the _quest passed as argument to the page the first time we build it
    return Scaffold(
        appBar: AppBar(title: const Text('Edit quest')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _daysOption(),
            _daySessions(),
            // _quest[0].displayEditQuest(context)
          ],
          ),
        floatingActionButton: _addTask(),
        );
    /*
    return WillPopScope(
      onWillPop: () async {
        //Returns the updated quest to quest_page
        Navigator.pop(context, _quest);
        return false;
      },
      child:  Scaffold(
        appBar: AppBar(title: const Text('Edit quest')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _daysOption(),
            _daySessions(),
            // _quest[0].displayEditQuest(context)
          ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context, 
              builder: (_) {
                return AlertDialog(
                  title: Text('New task'),
                  content: Column(
                    children: <Widget>[
                      DropdownButton(
                        items: Generator().modules
                        .where((module) => module != '' && module != 'duplicate' && module != 'free')
                        .map((module) => DropdownMenuItem(
                          value: module,
                          child: Text(module)))
                        .toList(), 
                        onChanged: (String? selectedModule) {
                          //TODO display selected module
                        })
                    ],
                  ),
                );
              },
              barrierDismissible: false
              );
          }, 
          child: const Icon(Icons.add),
          ),
        ));
        */
  }
}