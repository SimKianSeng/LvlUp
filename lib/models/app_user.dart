import 'package:lvlup/models/session.dart';

class AppUser {

  late final String uid;

  String? username;
  String? characterName;
  String? tierName;
  int? xp;
  int? evoState;
  String? evoImage;
  List<Session>? quest;

  AppUser.newUser({
    required this.username,
    this.characterName = 'white man',
    this.tierName = 'Noob',
    this.xp = 0,
    this.evoState = 0,
    this.evoImage = "assets/Avatars/Basic Sprite.png",
  });

  AppUser(
      {required this.uid});

  ///Constructor for logging in, used in tandem with database_service
  // Consumes JSON
  AppUser.fromJson(Map<dynamic, dynamic> json)
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

  String get imagePath {
    return evoImage??"";
  }

  //TODO game logic
  void updateXP(Duration duration) {
    const rate = 100; //100 exp per hour
    const unitTime = 15; //15mins per unit Time

    // xp += (duration.inMinutes ~/ unitTime) * rate;
  }
}
