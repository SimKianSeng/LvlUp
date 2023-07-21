import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';
import 'package:time_planner/time_planner.dart';

///Quest is a singleton class that encapsulates the user's tasks and methods related to it.
///It is a singleton as a user will only have 1 quest at any point in time
class Quest {
  static final Quest _instance = Quest._internal();
  List<List<Session>> _quest = List.generate(7, (index) => [], growable: false);

  Quest._internal();

  factory Quest() {
    return _instance;
  }

  /// Sort each daySessions in _quest according to startTime 
  void _sortSessions() {
    for (List<Session> daySessions in _quest) {
      daySessions.sort((a, b) => a.compareTo(b));
    }
  }

  /// Update _quest according to the data saved in database or updated
  void set(List<Session> sessions) {
    for (List<Session> daySessions in _quest) {
      daySessions.clear();
    }
    for (Session session in sessions) {
      _quest[session.dateTime.day].add(session);
    }

    _sortSessions();
  }

  /// Output _quest in a form that can be added and displayed using TimePlanner
  List<Session> retrieveQuest() {
    return _quest.expand((daySessions) => daySessions).toList();
  }

  /// Update Quest with the input session
  void add(Session session) {
    _quest[session.dateTime.day].add(session);
    _sortSessions();
  }

  /// Remove particular session from the _quest
  void removeSession(Session session) {
    _quest[session.dateTime.day].remove(session);
  }

  /// Replace session with newSession
  void replaceSession(Session session, Session newSession) {
    removeSession(session);
    add(newSession);
  }

  ///Check through the day tasks for that particular dayIndex and check if there is any overlapping time periods
  bool timeOverlaps(TimeOfDay startTime, TimeOfDay endTime, TimePlannerDateTime originalStartTime, int minutesDuration) {
    int originalStart = (originalStartTime.hour * 60) + originalStartTime.minutes;
    int originalEnd = originalStart + minutesDuration;

    //Retrieve list of Sessions for that particular day
    List<Session> daySessions = _quest[originalStartTime.day];
    int start = (startTime.hour * 60) + startTime.minute;
    int end = (endTime.hour * 60) + endTime.minute;

    for (Session session in daySessions) {
      int sessionStart = (session.dateTime.hour * 60) + session.dateTime.minutes;
      int sessionEnd = sessionStart + session.minutesDuration;

      if (sessionStart == originalStart && sessionEnd == originalEnd) {
        //This is the current session that we are editing
        continue;
      }

      //To not overlap, startTime and endTime must not be between sessionStart and sessionEnd exclusive
      bool startInBetween = start > sessionStart && start < sessionEnd;
      bool endInBetween = end > sessionStart && end < sessionEnd;
      bool sessionInBetween = sessionStart > start && sessionStart < sessionEnd;

      if (startInBetween || endInBetween || sessionInBetween) {
        return true;
      }
    }
    
    //No collisions
    return false;
  }

}