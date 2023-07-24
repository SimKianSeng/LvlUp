import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/services/game_logic/tier.dart';
import 'package:lvlup/services/game_logic/xp.dart';

void main() {

  group('Retrieval of tierName', () {
    test('Retrieval of tier name at level 10', () {
      const level = 10;
      final tierName = Tier.getTierName(level);

      expect( "Nooby Noob", tierName);
    });

    test('Retrieval of tier name at level 50', () {
        const level = 50;
        final tierName = Tier.getTierName(level);

        expect( "Game Boi", tierName);
      });

  });

  group('Retrieval of level and displaying tierName', () {
    test('Getting level of user at exp 32533', () {
      const xp = 500;

      final int level = Xp.getLevel(xp);

      expect(11, level);
    });

    test('Displaying tierName of user with exp 32533', () {
      const int level = 11;

      final tierName = Tier.getTierName(level);

      expect("Little Boi", tierName);

    });
  });
}
