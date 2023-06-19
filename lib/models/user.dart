import 'package:firebase_database/firebase_database.dart';
import 'package:lvlup/models/session.dart';

//TODO: instanciation and passing of data into and retrieving data from
//TODO connect to realtime database
class UserApp {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  final String id;
  final String username;
  String characterName;
  String tierName;
  BigInt xp;
  int evoState;
  String evoImage;
  List<Session>? quest;

  //TODO retrieve user from sign in?
  UserApp(this.id, this.username, this.characterName, this.tierName, this.xp,
      this.evoState, this.evoImage);

  ///Constructor for logging in

  // Consumes JSON
  UserApp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        characterName = json['characterName'],
        tierName = json['tierName'],
        xp = json['xp'],
        evoState = json['evoState'],
        evoImage = json['evoImage'];

  // Produce JSON
  Map<String, dynamic> toJson() => {
        'id': id,
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
}
