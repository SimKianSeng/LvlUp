import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/module_row.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_planner/time_planner.dart';


class ScheduleInput extends StatefulWidget {
  const ScheduleInput({super.key});

  @override
  State<ScheduleInput> createState() => _ScheduleInputState();
}

class _ScheduleInputState extends State<ScheduleInput>{
  final Generator _generator = Generator();
  static int _moduleCount = 1;
  int _intensity = 5;
  List<TimePlannerTask> sessions = [];

  @override
  void initState() {
    // TODO: when enter page, previous inputs should still remain, rn is due to the thing being removed and all
    // TODO: and able to edit the current saved inputs in generator also
    //automatickeepclientalivemixin does not seem to solve this
    super.initState();
  }

  void _updateSession() {
      setState(() {
        sessions.clear();
        sessions.addAll(_generator.periods());
      });
    }
    
  Slider _intensityScale() {
    return Slider(
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
        //todo: after settling other main stuff
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
        //       child: _addModule()
        //     ),
        //   ]
        // ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: ListView.builder(
                itemCount: _moduleCount,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ModuleRow(index: index + 1,),
                )),
            ),
            Expanded(
              child: _addModule()
            ),
          ]
        ),
      ),
    );
  }

  IconButton _addModule() {
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentNode = FocusScope.of(context);
        currentNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
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
                      ),)),
                ],
              ),
              _weeklyInput(),
              _heading('Intensity'),
              _intensityScale(),
              // _check(),
            ],
          ),
        ),
      ),
    );
  }
}