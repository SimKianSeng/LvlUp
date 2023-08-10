import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/quest.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_planner/time_planner.dart';


class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  List<Session> _task = [];
  final Generator _generator = Generator();
  late bool _acceptedQuest;
  bool generated = false;

  @override
  void initState() {
    super.initState();
    _acceptedQuest = true;
  }

  Future<void> _setUpGenerator(AppUser user) async {
    await user.retrievePreviousGenInputs().then((value) => _generator.retrievePreviousData(value));
  }

  
  Widget _editQuestButton() {
    //TODO  the 'OR' logic operator seems buggy
    bool allowedToEnter = _generator.modules.isNotEmpty || _task.isNotEmpty;

    return allowedToEnter
      ? IconButton(
      onPressed: () async {
        bool edited = await Navigator.pushNamed(context, '/questEdit') as bool;

        setState(() {
          _task.clear();
          _task.addAll(Quest().retrieveQuest());
        });

        if (edited) {
          const SnackBar message = SnackBar(content: Text('Quest has been updated. Do remember to save your quest before exiting!'));

          ScaffoldMessenger.of(context).showSnackBar(message);
        }

        //If not yet accept, do not depend on edited. Else check if there are edits
        _acceptedQuest = !_acceptedQuest ? _acceptedQuest : !edited;
      }, 
      icon: const Icon(Icons.edit))
      : IconButton(
        onPressed: () {
          const SnackBar message = SnackBar(content: Text('Please input your modules into the generator'));

          ScaffoldMessenger.of(context).showSnackBar(message);
        },
        icon: const Icon(Icons.edit));
  }

  Widget _saveQuestButton(AppUser user) {
    return IconButton(
      onPressed: _acceptedQuest
          ? null
          : () {
              user.acceptQuest(_task);
              setState(() {
                _acceptedQuest = !_acceptedQuest;
              });

               const SnackBar message = SnackBar(content: Text('Quest saved!'));
          
          ScaffoldMessenger.of(context).showSnackBar(message);

            },
      icon: const Icon(Icons.save),
      color: Colors.black,
      disabledColor: Colors.grey,
      tooltip: 'Accept quest');
  }

  ///Provides a button that brings user to the generator input page
  Widget _generatorButton(AppUser user) {
    return ElevatedButton(
      style: customButtonStyle(),
      onPressed: () async {
        String? message = await Navigator.pushNamed(context, '/scheduleInput', arguments: user) as String?;

        if (message != null) {
          SnackBar updatedNotification = SnackBar(
            content: Text(message),
          );
          
          ScaffoldMessenger.of(context).showSnackBar(updatedNotification);
        }
      },
      child: const Text("Generator"),
    );
  }

  ///Provides a button for user to generate a schedule based on previous input to the generator
  Widget _generateButton() {
    return ElevatedButton(
      style: customButtonStyle(),
      onPressed: () {
        if (_generator.hasNoInput()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Please input your modules and free periods in generator")));
        } else {
          if (_task.isNotEmpty) {
            showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: const Text('Warning'),
                content: const Text('Do you wish to overwrite the current existing quest?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                     Navigator.pop(context);
                    }, 
                    child: const Text('Cancel')
                  ),
                  TextButton(
                    onPressed: () {
                      //Proceed to update quest
                      setState(() {
                        _task.clear();
                        _task.addAll(_generator.generateSchedule());
                        Quest().set(_task);
                        _acceptedQuest = false;
                        generated = true;
                      });

                      //Close the alertdialog
                      Navigator.pop(context);
                    }, 
                    child: const Text('Yes'))
                ],
              );
            });
          } else {
            setState(() {
              _task.clear();
              _task.addAll(_generator.generateSchedule());
              Quest().set(_task);
              _acceptedQuest = false;
              generated = true;
            });
          }
          
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

    if (!(_generator.retrievedPreviousData)) {
      //Update generator with the saved input if it has no input and page is build
      _setUpGenerator(user);
    }

    if (_task.isEmpty && !generated) {
      //Retrieving saved quest
      //TODO Can place under initState if not for the need to retrieve user first
      _task.addAll(user.getSavedQuest());
    }
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Quest"),
        centerTitle: true,
        actions: [ 
          _editQuestButton(),
          _saveQuestButton(user)
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
          _generatorButton(user),
          _generateButton(),
        ],
      ),
    );
  }
}
