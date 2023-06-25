
import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/services/game_logic/xp.dart';


void main() {
  test("Updating of exp with 1h of study", () {
    const testDuration = Duration(hours: 1);
    int currentXp = 500;
    
    int result = Xp.incrXP(testDuration, currentXp);

    expect(600, result);
  });

  test("Getting level of user", () {
    const int testXP = 15328;
    int result = Xp.getCurXp(testXP);

    expect(328, result);
  });
}