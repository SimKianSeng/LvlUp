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
  FocusNode? focusNode;

  int currentStep = 0;
         
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

  List<Step> steps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text('Modules', style: TextStyle(fontSize: 10.0),),
        content: _moduleInput(context)
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text('Weekly Free Time', style: TextStyle(fontSize: 10.0),), 
        content: _freePeriodInput()
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text('Intensity', style: TextStyle(fontSize: 10.0),), 
        content: _intensityInput()
      )
    ];
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
          currentStep = 0; //Brings user back to the first step
        });
      }, 
      child: const Text('Reset', style: TextStyle(color: Colors.black),));
  }

  
  Widget _moduleInput(BuildContext context, ) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: _moduleCount,
            itemBuilder: (context, index) => ModuleRow(
              index: index + 1, 
              originalInput: _modules.length > index ? _modules[index] : '',
              focusNode: index == _moduleCount - 1 ? focusNode : null
            )
          ),
          _addModuleButton()
        ],
      ),
    );
      //TODO: refinement

      // child: Column(
      //   children: <Widget>[
      //     ReorderableListView.builder(
      //         itemCount: _moduleCount,
      //         onReorder: (oldIndex, newIndex) {
      //           //todo: order is updated in generator, but not in UI
      //           setState(() {
      //             if (oldIndex < newIndex) {
      //               newIndex -= 1;
      //             }
      //           });
      //           _generator.swapModules(oldIndex, newIndex);
      //         },
      //         itemBuilder: (context, index) => ModuleRow(key: Key(index.toString()), index: index + 1,)),
      //     _addModuleButton()
      //   ]
      // );
  }

  IconButton _addModuleButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _moduleCount += 1;

          //Switch focus to newly added moduleRow
          if (focusNode != null) {
            focusNode!.unfocus();
          }
          focusNode = FocusNode();
          focusNode!.requestFocus();
        });
      },
      icon: const Icon(Icons.add)
    );
  }
  
  Widget _freePeriodInput() {
    TextButton addFreePeriodButton = TextButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/weeklyInput');
        _updateSession();
      },
      child: Text(
        'Add free period',
        style: TextStyle(
          color: Colors.blue[100]
        )
      )
    );

    return Column(
      children: <Widget>[
        addFreePeriodButton,
        _weeklyInput()
      ],
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

    //TODO stick to this UI?
    return SizedBox(
      width: 600,
      height: 800,
      child: TimePlanner(
        startHour: startHour,
        endHour: lastHour,
        headers: header,
        style: style,
        tasks: sessions,
      ),
    );
  }


  Widget _intensityInput() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Intensity scale', 
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            useHint("Intensity determines the proportion of free sessions that will be assigned.", color: Colors.grey[800]!),
          ],
        ),
        const SizedBox(height: 40.0,),
        _intensityScale()
      ],
    );
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
          ],
        ),
        body: Container(
          decoration: bgColour,
          child: Stepper(
            type: StepperType.horizontal,
            elevation: 0.0,
            onStepCancel: () {
              return currentStep == 0
                ? Navigator.pop(context)
                : setState(() {
                  currentStep--;
                });
            },
            onStepContinue: () {
              //TODO Update database and generator, move on afterwards
              bool isLastStep = (currentStep == steps().length - 1);

              if (isLastStep) {
                //Save generator new settings
                _generator.saveToDatabase(user);

                //Exit input page
                Navigator.pop(context);
              } else {
                //Move to the next step
                setState(() {
                  currentStep++;
                });
              }
            },
            onStepTapped: (newStep) => setState(() {
              currentStep = newStep;
            }),
            steps: steps(),
            currentStep: currentStep,
            )
          )
        )
      );
  }
}