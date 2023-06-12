import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/module_row.dart';
import 'package:lvlup/services/generator.dart';


class ScheduleInput extends StatefulWidget {
  const ScheduleInput({super.key});

  @override
  State<ScheduleInput> createState() => _ScheduleInputState();
}

class _ScheduleInputState extends State<ScheduleInput> {
  Generator generator = Generator();
  // Schedule schedule = Schedule();
  static int _moduleCount = 1;
  int _intensity = 5;

  Slider _intensityScale() {
    return Slider(
      max: 10.0,
      divisions: 10,
      label: _intensity.toString(),
      value: _intensity.toDouble(), 
      onChanged: (newIntensity) {
        setState(() {
          _intensity = newIntensity.toInt();
          generator.updateIntensity(newIntensity.toInt());
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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: Colors.white60,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: ListView.builder(
                itemCount: _moduleCount,
                itemBuilder: (context, index) => ModuleRow(index: index + 1,)),
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
                    onPressed: () {}, 
                    child: Text(
                      'Add free period',
                      style: TextStyle(
                        color: Colors.blue[100]
                      ),)),
                ],
              ),
              // _weeklyInput(),
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