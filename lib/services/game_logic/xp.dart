import 'package:lvlup/models/app_user.dart';
import 'dart:math';

/// XP = 5 * pow(Level, 2)
class Xp {
  static int getLevel(int xp) {
    return (sqrt(xp / 5)).floor() + 1;
  }

  /// Take the total exp that the user has and find the current level progress.
  static int getCurXp(int xp) {
    int curLevel = getLevel(xp);
    return xp - (5 * pow(curLevel - 1, 2)).floor();
  }

  static int getCurXpCap(int xp) {
    int curLevel = getLevel(xp);
    int loXp = 5 * pow(curLevel - 1, 2).floor();
    int hiXp = 5 * pow(curLevel, 2).floor();
    return hiXp - loXp;
  }

  static int incrXP(Duration duration, AppUser currentUser) {
    const rate = 25; // 100 exp per hour
    const unitTime = 15; // 15mins per unit Time

    int xp = currentUser.xp!;

    xp = xp + (duration.inMinutes ~/ unitTime) * rate;

    return xp;
  }
}
