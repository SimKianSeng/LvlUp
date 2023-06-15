import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';

import 'package:time_planner/time_planner.dart';

///Generator is a singleton class that takes in the input for the schedule consisting:
///modules (ranked), intensity and free sessions.
///Using these inputs, generator will utilise 'weighted random selection' algorithm
///and distribute the modules across the free sessions based on level of intensity
class Generator {

  static final Generator _instance = Generator._internal();
  static const freePeriod = 'free';
  static const duplicate = 'duplicate';

  List<String> _modules = [];

  List<String> _modulesNoDup = [];
  int _intensity = 5;
  //TODO ensure that sessions can only be in blocks of 30minutes and start on xx00 or xx30
  List<List<Session>> _sessions = List.generate(7, (index) => []);

  List<String> _allocations = [];

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

  List<TimePlannerTask> periods() {
    return _sessions.expand(
      (daySessions) => daySessions.map(
        (session) => TimePlannerTask(
          color: Colors.green,
          minutesDuration: session.minutesDuration, 
          dateTime: TimePlannerDateTime(day: session.day, hour: session.startTime.hour, minutes: session.startTime.minute)))
      ).toList();
  }

  List<String> generateSchedule() {
    int numberOfFreeSessions = 10; //sessions.length;

    //Reset allocations for each generateSchedule call
    _allocations = [];
    _modulesNoDup = List.from(_modules);
    _modulesNoDup.removeWhere((element) => element == duplicate || element == freePeriod);


    while (numberOfFreeSessions != 0) {
      String module = selectModule();

      _allocations.add(module);

      numberOfFreeSessions -= 1;
    }

    return _allocations;
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