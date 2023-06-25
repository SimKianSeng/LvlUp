class Xp {
  static const int levelXpCap = 1000;

  static int getLevel(int xp) {
    return (xp / 1000).floor() + 1;
  }

  static int getCurXp(int xp) {
    return xp % 1000;
  }

  static int incrXP(Duration duration, int xp) {
    const rate = 25; //100 exp per hour
    const unitTime = 15; //15mins per unit Time

    xp = xp + (duration.inMinutes ~/ unitTime) * rate;

    return xp; 
  }

//   static int getXP(int level, int curXp) {
//     return level * 1000 + curXp;
//   }

//   static int getXPToNextLevel(int xp) {
//     int level = getLevel(xp);
//     return getXP(level + 1) - xp;
//   }

//   static int getLevelProgress(int xp) {
//     int level = getLevel(xp);
//     int xpToNextLevel = getXPToNextLevel(xp);
//     int xpToCurrentLevel = getXP(level);
//     return xp - xpToCurrentLevel;
//   }

//   static int getLevelProgressPercent(int xp) {
//     int level = getLevel(xp);
//     int xpToNextLevel = getXPToNextLevel(xp);
//     int xpToCurrentLevel = getXP(level);
//     return ((xp - xpToCurrentLevel) / xpToNextLevel * 100).floor();
//   }
}
