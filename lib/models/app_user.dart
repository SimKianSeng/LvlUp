import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/database_service.dart';

class AppUser {
  late final String uid;

  String? username;
  String? characterName;
  String? tierName;
  int? xp;
  int? evoState;
  String? evoImage;
  List<Session>? _quest;

  AppUser.newUser({
    required this.username,
    this.characterName = 'White Man',
    this.tierName = 'Noob',
    this.xp = 0,
    this.evoState = 0,
    this.evoImage = "assets/avatars/evo0/white_man.png",
  });

  AppUser(
      {required this.uid,
      this.username,
      this.characterName,
      this.tierName,
      this.xp,
      this.evoState,
      this.evoImage});

  ///Constructor for logging in, used in tandem with database_service
  // Consumes JSON
  AppUser.fromJson(String id, Map<dynamic, dynamic> json)
      : uid = id,
        username = json['username'],
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

  //TODO
  void acceptQuest(List<Session> quest) async {
    updateQuest(quest);
    await DatabaseService(uid: uid).updateQuest(quest); //Issue updating Session
  }

  void updateQuest(List<Session> quest) {
    _quest = quest;
  }

  //TODO
  List<Session> getSavedQuest() {
    return _quest ?? [];
  }

  String get imagePath {
    return evoImage ?? "";
  }

  //TODO game logic
  void updateXP(Duration duration) {
    const rate = 100; //100 exp per hour
    const unitTime = 15; //15mins per unit Time

    xp = xp! + (duration.inMinutes ~/ unitTime) * rate;

    //TODO update firebase
  }
}
