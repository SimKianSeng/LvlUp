import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';

import 'package:time_planner/time_planner.dart';

///Generator is a singleton class that takes in the input for the schedule consisting:
///modules (ranked), intensity and free sessions.
///Using these inputs, generator will utilise 'weighted random selection' algorithm
///and distribute the modules across the free sessions based on level of intensity
class Generator {
  //TODO break the input periods into blocks of 30minutes
  //TODO link to homepage, timer
  //TODO link to firebase
  static final Generator _instance = Generator._internal();
  static const freePeriod = 'free';
  static const duplicate = 'duplicate';

  List<String> _modules = [];

  List<String> _modulesNoDup = [];
  int _intensity = 5;
  List<List<Session>> _sessions = List.generate(7, (index) => []);

  factory Generator() {
    return _instance;
  }

  Generator._internal();

  bool alreadyInput(String module) {
    return _modules.contains(module.toUpperCase());
  }

  void updateModule(String module, int rank) {
    if (alreadyInput(module)) {
      //Removed the partially filled module
      _modules.replaceRange(rank - 1, rank, [duplicate]);
      return;
    }

    //Module at current ranking is another module
    if (_modules.length >= rank && _modules.elementAt(rank - 1) != module.toUpperCase()) {
      _modules.removeAt(rank - 1);
    }

    _modules.insert(rank - 1, module.toUpperCase());
  }

  //for reorderablelistview once changed
  // void swapModules(int oldIndex, int newIndex) {
  //   String tmp = modules[oldIndex];
  //   modules[oldIndex] = modules[newIndex];
  //   modules[newIndex] = tmp;
  // }

  void updateSessions(int index, Session session) {
    sessions[index].add(session);
    sessions[index].sort((a, b) => a.compareTo(b));
  }

  void updateIntensity(int intensity) {
    _intensity = intensity;
  }

  List<List<Session>> get sessions {
    return _sessions;
  }

  ///Insert the generated modules into the respective timeslots available
  List<TimePlannerTask> _slotTasks(List<String> allocations) {
    //TODO
    //split input sessions into blocks of 30minutes interval
    List<Session> sessionsExpanded = _sessions.expand(
      (element) => element.expand((session) => session.splitIntoBlocks()))
      .toList();

    List<TimePlannerTask> slottedTasks = [];

    for (int i = 0; i < allocations.length; i++) {
      //TODO: find a list method that can combine 2 different lists into a list of different generic type

      // slottedTasks = sessionsExpanded
      //   .map(
      //     (session) => TimePlannerTask(
      //       minutesDuration: session.minutesDuration, 
      //       dateTime: TimePlannerDateTime(day: session.day, hour: session.startTime.hour, minutes: session.startTime.minute)))
      //   .toList();
      if (allocations[i] == freePeriod) {
        //no need to show freeperiods on the schedule
        continue;
      }

      slottedTasks.add(TimePlannerTask(
        minutesDuration: sessionsExpanded[i].minutesDuration, 
        dateTime: TimePlannerDateTime(
          day: sessionsExpanded[i].day, 
          hour: sessionsExpanded[i].startTime.hour, 
          minutes: sessionsExpanded[i].startTime.minute),
        color: Colors.green,
        child: Text(
          allocations[i],
          style: const TextStyle(
            fontSize: 20.0
          ),
        )));
    }

    return slottedTasks;
  }

  List<TimePlannerTask> periods() {
    return _sessions.expand(
      (daySessions) => daySessions.map(
        (session) => TimePlannerTask(
          color: Colors.green,
          minutesDuration: session.minutesDuration, 
          dateTime: TimePlannerDateTime(day: session.day, hour: session.startTime.hour, minutes: session.startTime.minute)))
      ).toList();
  }

  List<TimePlannerTask> generateSchedule() {
    int numberOfFreeSessions = _sessions.expand((element) => element).length;

    List<String> allocations = [];
    _modulesNoDup = List.from(_modules);
    _modulesNoDup.removeWhere((element) => element == duplicate || element == freePeriod);


    while (numberOfFreeSessions != 0) {
      String module = selectModule();

      allocations.add(module);

      numberOfFreeSessions -= 1;
    }

    List<TimePlannerTask> generatedTask = _slotTasks(allocations);

    return generatedTask;
  }

  
  String selectModule() {
    //Save the need to compute everytime if there are no modules or zero intensity
    if (_modulesNoDup.isEmpty || _intensity == 0) {
      return 'free';
    }

    int moduleWeightage = ((_modulesNoDup.length + 1) * _modulesNoDup.length) * 5; // (/ 2 * 10)
    int totalWeightage = 0; // will increment as we iterate through

    List<int> prefixSum = [];


    for (int i = 0; i < _modulesNoDup.length; i++) {
      int rank = _modulesNoDup.length - i;
      rank *= 10;
      totalWeightage += rank;
      prefixSum.add(totalWeightage);
    }

    if (_intensity != 10) {
      int freePeriodWeightage = (moduleWeightage * (10 - _intensity)) ~/ _intensity;
      _modulesNoDup.add(freePeriod);
      prefixSum.add(freePeriodWeightage + moduleWeightage);
    }

    int target = 1 + Random().nextInt(prefixSum.last);


    //Binary search to find smallest index corresponding to prefix sum greater than target
    int start = 0;
    int end = prefixSum.length - 1;

    while(start < end) {
      int mid = (start + end) ~/ 2;
      if (prefixSum[mid] < target) {
        start = mid + 1;
      } else if (prefixSum[mid] > target) {
        end = mid;
      } else {
        start = mid;
        break;
      }
    }


    String module = _modulesNoDup[start];
    return module;
  }
  
}