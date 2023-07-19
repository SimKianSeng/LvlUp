import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/utils/timeofday_extensions.dart';
import 'package:lvlup/services/firebase/database_service.dart';

///Generator is a singleton class that takes in the input for the schedule consisting:
///modules (ranked), intensity and free sessions.
///Using these inputs, generator will utilise 'weighted random selection' algorithm
///and distribute the modules across the free sessions based on level of intensity

class Generator {
  static final Generator _instance = Generator._internal();
  static const freePeriod = 'free';
  static const duplicate = 'duplicate';

  List<String> _modules = [];
  int _intensity = 5;
  List<List<Session>> _sessions = List.generate(7, (index) => []);
  bool retrievedPreviousData = false; //To track if generator is currently using saved inputs from database

  factory Generator() {
    return _instance;
  }

  Generator._internal();

  void reset() {
    _modules = [];
    _intensity = 5;
    _sessions = List.generate(7, (index) => []);
    retrievedPreviousData = false;
  }

  void retrievePreviousData(Map<String, dynamic> inputs) async {
    //Update _sessions to be that in previous inputs
    for (List<Session> daySessions in _sessions) {
      daySessions.clear();
    }
    List<Session> previousSession = inputs['freePeriods'] as List<Session>;
    for (Session session in previousSession) {
      _sessions[session.dateTime.day].add(session);
    }

    //update _intensity
    _intensity = inputs['intensity'];
    
    //Update _modules
    _modules = inputs['modules'];

    retrievedPreviousData = true;
  }

  int get intensity {
    return _intensity;
  }

  List<String> get modules {
    return _modules.where((module) => module != '' && module != duplicate).toList();
  }

  bool alreadyInput(String module) {
    return _modules.contains(module.toUpperCase());
  }

  bool hasNoInput() {
    bool noSessionInput = _sessions.every((element) => element.isEmpty);
    return _modules == [] || noSessionInput;
  }

  void saveToDatabase(AppUser user) {
    DatabaseService(uid: user.uid)
      .updateGeneratorInputs(
        _modules.where((module) => module != '' && module != 'duplicate').toList(),
        _sessions.expand((element) => element).toList(), 
        _intensity
        );
  }

  void updateModule(String module, int rank) {
    if (alreadyInput(module)) {
      //Removed the partially filled module
      _modules.replaceRange(rank - 1, rank, [duplicate]);
      return;
    }

    //Module at current ranking is another module
    if (_modules.length >= rank &&
        _modules.elementAt(rank - 1) != module.toUpperCase()) {
      _modules.removeAt(rank - 1);
    }

    //TODO debug, not touching previous ModuleRows and filling the latest one will only result in error
    //Maybe if there is nothing inserted yet, we can just put a placeholder in there that will also be removed from the generating/ saving etc
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

  @visibleForTesting
  ///Remove sessions that share the same time periods, ie same start time and duration
  List<Session> removeDuplicateSessions(List<Session> sessions) {
    int current = 0;

    while (current < sessions.length - 1) {
      Session currentSession = sessions[current];
      Session nextSession = sessions[current + 1];

      bool sameStartTime =
          currentSession.dateTime.day == nextSession.dateTime.day &&
              currentSession.dateTime.hour == nextSession.dateTime.hour &&
              currentSession.dateTime.minutes == nextSession.dateTime.minutes;

      bool sameDuration =
          currentSession.minutesDuration == nextSession.minutesDuration;

      if (sameStartTime && sameDuration) {
        sessions.removeAt(current + 1);
      } else {
        current++;
      }
    }

    return sessions;
  }

  ///Insert the generated modules into the respective timeslots available
  List<Session> _slotTasks(List<String> allocations) {
    //split input sessions into blocks of 30minutes interval and chain into a single list instead of nesting them
    List<Session> sessionsExpanded = _sessions
        .expand(
            (element) => element.expand((session) => session.splitIntoBlocks()))
        .toSet()
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
    while (next < allocatedTasks.length) {
      TimeOfDay currentStart = TimeOfDay(
          hour: allocatedTasks[current].dateTime.hour,
          minute: allocatedTasks[current].dateTime.minutes);
      TimeOfDay nextStart = TimeOfDay(
          hour: allocatedTasks[next].dateTime.hour,
          minute: allocatedTasks[next].dateTime.minutes);

      bool hasDifferentTask =
          (allocatedTasks[current].task != allocatedTasks[next].task);
      bool notConsecutiveTasks = (nextStart !=
          currentStart.plusMinutes(allocatedTasks[current].minutesDuration));

      if (hasDifferentTask || notConsecutiveTasks) {
        current++;
        next++;
        continue;
      }

      //Merging of consecutive tasks that have same task assigned
      allocatedTasks[current] =
          allocatedTasks[current].mergeWith(allocatedTasks[next]);
      allocatedTasks.removeAt(next);
    }
  }

  ///Retrieve the free periods that has been input in generator
  List<Session> periods() {
    return _sessions.expand((daySessions) => daySessions).toList();
  }

  List<Session> generateSchedule() {
    List<Session> uniqueSessions = removeDuplicateSessions(_sessions
        .expand(
            (element) => element.expand((session) => session.splitIntoBlocks()))
        .toList());
    int numberOfFreeSessions = uniqueSessions.length;

    List<String> allocations = [];
    List<String> modulesNoDup = List.from(_modules);
    modulesNoDup.removeWhere(
        (element) => element == duplicate || element == freePeriod);

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

    int moduleWeightage =
        ((modulesNoDup.length + 1) * modulesNoDup.length) * 5; // (/ 2 * 10)
    int totalWeightage = 0; // will increment as we iterate through

    List<int> prefixSum = [];

    for (int i = 0; i < modulesNoDup.length; i++) {
      int rank = modulesNoDup.length - i;
      rank *= 10;
      totalWeightage += rank;
      prefixSum.add(totalWeightage);
    }

    if (_intensity != 10) {
      int freePeriodWeightage =
          (moduleWeightage * (10 - _intensity)) ~/ _intensity;
      modulesNoDup.add(freePeriod);
      prefixSum.add(freePeriodWeightage + moduleWeightage);
    }

    int target = 1 + Random().nextInt(prefixSum.last);

    //Binary search to find smallest index corresponding to prefix sum greater than target
    int start = 0;
    int end = prefixSum.length - 1;

    while (start < end) {
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
