import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
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
      child: const Text('RESET', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),));
  }

  
  Widget _moduleInput(BuildContext context, ) {
    bool hasNoModuleRow = _moduleCount == 0;

    return hasNoModuleRow
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text('Please click on the add button to begin filling in your modules', 
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17.0),),
          _addModuleButton()
        ],
      )
      : SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: _moduleCount,
            itemBuilder: (context, index) => ModuleRow(
              index: index + 1, 
              originalInput: index >= _modules.length ? '' : _modules[index],
              focusNode: index == _moduleCount - 1 ? focusNode : null
            )
          ),
          _addModuleButton()
        ],
      ),
    );


      //Extension
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

    return SizedBox(
      width: 300,
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
        appBar: AppBar(automaticallyImplyLeading: false),
        body: Container(
          decoration: bgColour,
          child: Stepper(
            type: StepperType.horizontal,
            elevation: 0.0,
            controlsBuilder: (context, details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 37.5,
                    child: resetButton()
                  ),
                  SizedBox(
                    height: 37.5,
                    child: TextButton(
                      onPressed: details.onStepCancel, 
                      child: const Text('BACK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),)),
                  ),
                  SizedBox(
                    height: 37.5,
                    child: TextButton(
                      onPressed: details.onStepContinue, 
                      child: const Text('NEXT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),)),
                  )
                ],
              );
            },
            onStepCancel: () {
              return currentStep == 0
                ? Navigator.pop(context, null)
                : setState(() {
                  currentStep--;
                });
            },
            onStepContinue: () {
              bool isLastStep = (currentStep == steps().length - 1);

              if (!isLastStep) {
                bool hasNoInputs = currentStep == 0
                ? _generator.modules.isEmpty //Check that module list contains at least 1 module
                : sessions.isEmpty;//Check that free Periods list has at least 1 session in it

                if (hasNoInputs) {
                  const message = SnackBar(
                    content: Text('Please fill in the inputs for the current step!'),
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(message);
                } else {
                  //Move to the next step
                  setState(() {
                    currentStep++;
                  });
                }

                return;
              }

              //Last step does not require us to check for any inputs, continue callback should save the new inputs and exit the page
              //Save generator new settings
              _generator.saveToDatabase(user);

              //Exit input page
              const String generatorUpdatedMessage = 'Generator has been updated!';
              Navigator.pop(context, generatorUpdatedMessage);
           },
            onStepTapped: (newStep) {
              if (steps()[newStep].isActive) {
                setState(() {
                  currentStep = newStep;
                });
              }
            },
            steps: steps(),
            currentStep: currentStep,
            )
          )
        )
      );
  }
}


class ModuleRow extends StatefulWidget {
  final int index;
  final Generator generator = Generator();
  final String originalInput;
  final FocusNode? focusNode;

  ModuleRow({required this.index, required this.focusNode, this.originalInput = '', super.key});

  @override
  State<ModuleRow> createState() => _ModuleRowState();
}

class _ModuleRowState extends State<ModuleRow> {
  String module = '';

  bool hasNoInput() {
    return module == '' && widget.originalInput == '';
  }

 void updateModule(String module) {
    if (widget.generator.alreadyInput(module)) {
      //module has been input, do not update
      const message = SnackBar(
        content: Text('Module has been entered previously'),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(message);
    } else if (module != '' && this.module != module) {
      //module has not been previously input, update
      this.module = module;
    }
    
    widget.generator.updateModule(module, widget.index);  
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: widget.index == 1 ? 68.0 : 135.0),
          widget.index == 1 ? const Text('Module 1 (Weakest):') : Text('Module ${widget.index}:'),
          const SizedBox(width: 25.0,),
          SizedBox(
            width: 100.0,
            height: 35.0,
            //we can use textformfield to accomplish the task of auto populating the input
            child: TextFormField(
              textAlign: TextAlign.center,
              focusNode: widget.focusNode,
              autofocus: true,
              onChanged: (value) => updateModule(value),
              decoration: customTextField(),
              initialValue: widget.originalInput,
            ),
          ),
        ],
      ),
    );
  }
}