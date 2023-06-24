class Tier {
  static String getTierName(int level) {
    switch (level) {
      case >= 1 && <= 10:
        {
          return "Nooby Noob";
        }
      case >= 11 && <= 20:
        {
          return "Little Boi";
        }
      case >= 21 && <= 30:
        {
          return "Child Adventurer";
        }
      case >= 31 && <= 40:
        {
          return "Rising Rookie";
        }
      case >= 41 && <= 50:
        {
          return "Game Boi";
        }
      case >= 51 && <= 60:
        {
          return "Finally a Normie";
        }
      case >= 61 && <= 70:
        {
          return "Grown Up";
        }
      case >= 71 && <= 80:
        {
          return "Tryhard Grinder";
        }
      case >= 81 && <= 90:
        {
          return "God-like Pro";
        }
      case >= 91 && <= 100:
        {
          return "Game Addict";
        }
      case >= 101 && <= 110:
        {
          return "Sweaty CS Student";
        }
      default:
        {
          return "no tier name";
        }
    }
  }
}
