import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/services/game_logic/xp.dart';


void main() {

  group("Updating exp with varying durations of study", () {

    final AppUser currentAppUser = AppUser(uid: 'test', xp: 500);

    test("Updating of exp with 1h of study", () {
      const testDuration = Duration(hours: 1);      
      
      final int result = Xp.incrXP(testDuration, currentAppUser);

      expect(600, result); //Expect only an increment of 100xp
    });

    test("Updating of exp with 15 minutes of study", () {
      const testDuration = Duration(minutes: 15);
      
      final int result = Xp.incrXP(testDuration, currentAppUser);

      expect(525, result); //Expect only an increment of 25xp
    });

    test("Updating of exp with 1h30minutes of study with duration initialised in seconds", () {
      const testDuration = Duration(seconds: 5400); //90minutes
      
      final int result = Xp.incrXP(testDuration, currentAppUser);

      expect(650, result);//Expect only an increment of 150xp
    });

    test("Updating of exp with 5 minutes of study", () {
      const testDuration = Duration(minutes: 5);
      
      final int result = Xp.incrXP(testDuration, currentAppUser);

      expect(500, result); //Expect no change to exp
    });

    test("Updating of exp with 17 minutes of study in seconds", () {
      const testDuration = Duration(seconds: 1020);
      
      final int result = Xp.incrXP(testDuration, currentAppUser);

      expect(525, result); //Expect only an increment of 25xp
    });
  });
  

  test("Getting level of user", () {
    const int testXP = 15328;
    int expectedLevel = 1 + sqrt(testXP / 5).floor();

    final int result = Xp.getLevel(testXP);

    expect(expectedLevel, result);
  });
}
