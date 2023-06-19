import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';

import 'package:time_planner/time_planner.dart';

///Generator is a singleton class that takes in the input for the schedule consisting:
///modules (ranked), intensity and free sessions.
///Using these inputs, generator will utilise 'weighted random selection' algorithm
///and distribute the modules across the free sessions based on level of intensity

class Generator {
  //TODO link to homepage, timer
  //TODO link to firebase
  static final Generator _instance = Generator._internal();
  static const freePeriod = 'free';
  static const duplicate = 'duplicate';

  List<String> _modules = [];

  int _intensity = 5;
  List<List<Session>> _sessions = List.generate(7, (index) => []);

  //TODO transfer to user class
  List<Session>? quest;

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

  void removeSession(int dayIndex, Session session) {
    sessions[dayIndex].remove(session);
  }

  void updateIntensity(int intensity) {
    _intensity = intensity;
  }

  List<List<Session>> get sessions {
    return _sessions;
  }

  void acceptQuest(List<Session> quest) {
    this.quest = quest;
  }

  ///Insert the generated modules into the respective timeslots available
  List<Session> _slotTasks(List<String> allocations) {

    //split input sessions into blocks of 30minutes interval and chain into a single list instead of nesting them
    List<Session> sessionsExpanded = _sessions.expand(
      (element) => element.expand((session) => session.splitIntoBlocks()))
      .toList();

    List<Session> slottedTasks = [];
    

    for (int i = 0; i < allocations.length; i++) {
      if (allocations[i] == freePeriod) {
        //no need to show freeperiods on the schedule
        continue;
      }
      slottedTasks.add(sessionsExpanded[i].assignTask(allocations[i]));  
    }
    
    //Note: slottedTasks only contains Session instances that are allocated tasks
    //Sessions that are free periods are not inside slottedTasks
    return slottedTasks;
  }

  void _mergeConsecutiveSessions(List<Session> allocatedTasks) {
    int current = 0;
    int next = 1;

    // Check through the allocated Tasks
    while(next < allocatedTasks.length) {
      TimeOfDay currentStart = TimeOfDay(hour: allocatedTasks[current].dateTime.hour, minute: allocatedTasks[current].dateTime.minutes);
      TimeOfDay nextStart = TimeOfDay(hour: allocatedTasks[next].dateTime.hour, minute: allocatedTasks[next].dateTime.minutes);

      bool hasDifferentTask = (allocatedTasks[current].task != allocatedTasks[next].task);
      bool notConsecutiveTasks = (nextStart != currentStart.plusMinutes(allocatedTasks[current].minutesDuration));
      
      if (hasDifferentTask || notConsecutiveTasks) {
        current++;
        next++;
        continue;
      }

      //Merging of consecutive tasks that have same task assigned
      allocatedTasks[current] = allocatedTasks[current].mergeWith(allocatedTasks[next]);
      allocatedTasks.removeAt(next);
    }
  }

  List<TimePlannerTask> periods() {
    return _sessions.expand(
      (daySessions) => daySessions)
      .toList();
  }

  List<Session> generateSchedule() {
    int numberOfFreeSessions = _sessions.expand((element) => element.expand((session) => session.splitIntoBlocks())).length;

    List<String> allocations = [];
    List<String> modulesNoDup = List.from(_modules);
    modulesNoDup.removeWhere((element) => element == duplicate || element == freePeriod);


    while (numberOfFreeSessions != 0) {
      String module = selectModule(modulesNoDup);

      allocations.add(module);

      numberOfFreeSessions -= 1;
    }

    List<Session> generatedTask = _slotTasks(allocations);
    _mergeConsecutiveSessions(generatedTask);

    return generatedTask;
  }

  
  String selectModule(List<String> modulesNoDup) {
    //Save the need to compute everytime if there are no modules or zero intensity
    if (_modules.isEmpty || _intensity == 0) {
      return 'free';
    }

    int moduleWeightage = ((modulesNoDup.length + 1) * modulesNoDup.length) * 5; // (/ 2 * 10)
    int totalWeightage = 0; // will increment as we iterate through

    List<int> prefixSum = [];


    for (int i = 0; i < modulesNoDup.length; i++) {
      int rank = modulesNoDup.length - i;
      rank *= 10;
      totalWeightage += rank;
      prefixSum.add(totalWeightage);
    }

    if (_intensity != 10) {
      int freePeriodWeightage = (moduleWeightage * (10 - _intensity)) ~/ _intensity;
      modulesNoDup.add(freePeriod);
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


    String module = modulesNoDup[start];
    return module;
  }
  
}