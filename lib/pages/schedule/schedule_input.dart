import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/widgets/module_row.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_planner/time_planner.dart';


class ScheduleInput extends StatefulWidget {
  const ScheduleInput({super.key});

  @override
  State<ScheduleInput> createState() => _ScheduleInputState();
}

class _ScheduleInputState extends State<ScheduleInput>{
  final Generator _generator = Generator();
  List<String> _modules = [];
  int _moduleCount = 1;
  int _intensity = 5;
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  ///Ensures that the page is displaying the same inputs that generator already has
  void _populateFields() {
    //Update modules
    _modules = _generator.modules;
    _moduleCount = _modules.length;

    //TODO feature to make input more inuitive - bug encountered is that initValue for the textform is not cleared
    //What this does is that if there are no modules input during set up of the page, it will show only 1 moduleRow with initValue ''
    // _moduleCount = _modules.isEmpty ? 1: _modules.length;
    
    //Update sessions
    sessions.clear();
    sessions.addAll(_generator.periods());

    //Update intensity
    _intensity = _generator.intensity;    
  }

  ///Update freeperiods on the page
  void _updateSession() {
    setState(() {
      sessions.clear();
      sessions.addAll(_generator.periods());
    });
  }

  ///Reset generator and input fields
  Widget resetButton() {
    return TextButton(
      onPressed: () {
        _generator.reset();
        setState(() {
          _populateFields();
        });
      }, 
      child: const Text('Reset generator', style: TextStyle(color: Colors.black),));
  }
 

  Widget _saveInputs(AppUser user) {
    return IconButton(
      onPressed: () {
        _generator.saveToDatabase(user);
      }, 
      icon: const Icon(Icons.save));
  }

  Slider _intensityScale() {
    return Slider.adaptive(
      max: 10.0,
      divisions: 10,
      label: _intensity.toString(),
      value: _intensity.toDouble(),
      onChanged: (newIntensity) {
        setState(() {
          _intensity = newIntensity.toInt();
          _generator.updateIntensity(newIntensity.toInt());
        });
      }
    );
  }

  Text _heading(String header) {
    return Text(
      header,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _moduleInput(BuildContext context, ) {
    return Expanded(
      child: Container(
        decoration: contentContainerColour(),
        //TODO: refinement

        // child: Column(
        //   children: [
        //     Expanded(
        //       flex: 6,
        //       child: ReorderableListView.builder(
        //         itemCount: _moduleCount,
        //         onReorder: (oldIndex, newIndex) {
        //           //todo: order is updated in generator, but not in UI
        //           setState(() {
        //             if (oldIndex < newIndex) {
        //               newIndex -= 1;
        //             }
        //           });
        //           generator.swapModules(oldIndex, newIndex);
        //         },
        //         itemBuilder: (context, index) => ModuleRow(key: Key(index.toString()), index: index + 1,)),
        //     ),
        //     Expanded(
        //       child: _addModuleButton()
        //     ),
        //   ]
        // ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: ListView.builder(
                itemCount: _moduleCount,
                itemBuilder: (context, index) => ModuleRow(
                  index: index + 1, 
                  originalInput: _modules.length > index ? _modules[index] : '',)),
            ),
            Expanded(
              child: _addModuleButton()
            ),
          ]
        ),
      ),
    );
  }

  IconButton _addModuleButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _moduleCount += 1;
        });
      },
      icon: const Icon(Icons.add)
    );
  }

  Widget _weeklyInput() {
    const int startHour = 0;
    const int lastHour = 23;
    final List<TimePlannerTitle> header = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'].map((day) => TimePlannerTitle(title: day)).toList();
    TimePlannerStyle style = TimePlannerStyle(
      //cellHeight formatting will not align time on left with their respective cells
      cellWidth: 45,
    );

    return Expanded(
      child: Container(
        decoration: contentContainerColour(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TimePlanner(
            startHour: startHour,
            endHour: lastHour,
            headers: header,
            style: style,
            tasks: sessions,
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as AppUser;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentNode = FocusScope.of(context);
        currentNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            resetButton(),
            _saveInputs(user),
          ],
        ),
        body: Container(
          decoration: bgColour,
          child: Column(
            children: <Widget>[
              _heading('Module Ranking'),
              _moduleInput(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _heading('Weekly Available Time'),
                  TextButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/weeklyInput');
                      _updateSession();
                    },
                    child: Text(
                      'Add free period',
                      style: TextStyle(
                        color: Colors.blue[100]
                      ))),
                ],
              ),
              _weeklyInput(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _heading('Intensity'),
                  Tooltip(
                    message: "Intensity determines the proportion of free sessions that will be assigned.",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(Icons.help, color: Colors.grey[800],),
                  )
                  ]),
              _intensityScale(),
            ],
          ),
        ),
      ),
    );
  }
}