import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:time_planner/time_planner.dart';

//to run, call "flutter test test/generator_test.dart" in terminal

void main() {

  //Example
  /*
  test("check", () {
    var string = 'foo,bar,baz';
    expect(string.split(','), equals(['foo', 'bar', 'baz']));
  });
  */
  

  test("Generator is a singleton class", () {
    Generator generator = Generator();
    Generator generator2 = Generator();
    
    expect(true, generator == generator2);
  });

  test("Generator removes duplicate sessions", () {
    Generator gen = Generator();

    TimePlannerDateTime startTime = TimePlannerDateTime(day: 0, hour: 1, minutes: 30);

    List<Session> sessions = [
      Session(dateTime: startTime),
      Session(dateTime: startTime),
      Session(dateTime: startTime),
      Session(dateTime: startTime),
      Session(dateTime: startTime)
    ];

    List<Session> uniqueSessions = gen.removeDuplicateSessions(sessions);


    expect(1, uniqueSessions.length);
  });

  test("Generator removes duplicate sessions from empty list", () {
    Generator gen = Generator();

    List<Session> uniqueSessions = gen.removeDuplicateSessions([]);


    expect(0, uniqueSessions.length);
  });
}