
import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/services/game_logic/xp.dart';


void main() {
  test("Updating of exp with 1h of study", () {
    const testDuration = Duration(hours: 1);
    int currentXp = 500;
    
    int result = Xp.incrXP(testDuration, currentXp);

    expect(600, result); //Expect only an increment of 100xp
  });

  test("Updating of exp with 15 minutes of study", () {
    const testDuration = Duration(minutes: 15);
    int currentXp = 500;
    
    int result = Xp.incrXP(testDuration, currentXp);

    expect(525, result); //Expect only an increment of 25xp
  });

  test("Updating of exp with 1h30minutes of study with duration initialised in seconds", () {
    const testDuration = Duration(seconds: 5400); //90minutes
    int currentXp = 500;
    
    int result = Xp.incrXP(testDuration, currentXp);

    expect(650, result);//Expect only an increment of 150xp
  });

  test("Updating of exp with 5 minutes of study", () {
    const testDuration = Duration(minutes: 5);
    int currentXp = 500;
    
    int result = Xp.incrXP(testDuration, currentXp);

    expect(500, result); //Expect no change to exp
  });

  test("Updating of exp with 17 minutes of study in seconds", () {
    const testDuration = Duration(seconds: 1020);
    int currentXp = 500;
    
    int result = Xp.incrXP(testDuration, currentXp);

    expect(525, result); //Expect only an increment of 25xp
  });

  test("Getting level of user", () {
    const int testXP = 15328;
    int result = Xp.getCurXp(testXP);

    expect(328, result);
  });
}