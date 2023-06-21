import 'package:firebase_database/firebase_database.dart';
import 'package:lvlup/models/session.dart';

//TODO: instanciation and passing of data into and retrieving data from
//TODO connect to realtime database
class AppUser {
  String username;
  String characterName;
  String tierName;
  int xp;
  int evoState;
  String evoImage;
  List<Session>? quest;

  AppUser.newUser({
    required this.username,
    this.characterName = 'white man',
    this.tierName = 'Noob',
    this.xp = 0,
    this.evoState = 0,
    this.evoImage = 'default',
  });

  //TODO retrieve user from sign in?
  AppUser(
      {required this.username,
      required this.characterName,
      required this.tierName,
      required this.xp,
      required this.evoState,
      required this.evoImage,
      this.quest});

  ///Constructor for logging in

  // Consumes JSON
  AppUser.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        characterName = json['characterName'],
        tierName = json['tierName'],
        xp = json['xp'],
        evoState = json['evoState'],
        evoImage = json['evoImage'];

  // Produce JSON
  Map<String, dynamic> toJson() => {
        'username': username,
        'characterName': characterName,
        'tierName': tierName,
        'xp': xp,
        'evoState': evoState,
        'evoImage': evoImage,
      };

  set acceptQuest(List<Session> acceptedQuest) {
    quest = acceptedQuest;
  }

  void updateXP(Duration duration) {
    const rate = 100; //100 exp per hour
    const unitTime = 25; //25mins per unit Time

    xp += (duration.inMinutes ~/ unitTime) * rate;
  }

  void test() {}
}
