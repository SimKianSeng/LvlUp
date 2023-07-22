import 'package:lvlup/models/quest.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/firebase/database_service.dart';

class AppUser {
  late final String uid;

  String? username;
  String? characterName;
  String? tierName;
  int? xp;
  int? evoState;
  String? evoImage;
  Quest newQuest = Quest();
  Map<dynamic, dynamic>? stoppedSessionInfo;
  
  AppUser.newUser({
    required this.username,
    this.characterName = 'White Man',
    this.tierName = 'Nooby Noob',
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
        evoImage = json['evoImage'],
        stoppedSessionInfo = json['stoppedSession'];

  // Produce JSON
  Map<String, dynamic> toJson() => {
        'username': username,
        'characterName': characterName,
        'tierName': tierName,
        'xp': xp,
        'evoState': evoState,
        'evoImage': evoImage,
      };

  void acceptQuest(List<Session> quest) async {
    updateQuest(quest);
    await DatabaseService(uid: uid).updateQuest(quest);
  }

  void updateQuest(List<Session> quest) {
    newQuest.set(quest);
  }

  Future<Map<String, dynamic>> retrievePreviousGenInputs() {
    return DatabaseService(uid: uid).retrieveGeneratorInputs();
  }

  List<Session> getSavedQuest() {
    return newQuest.retrieveQuest();
  }

  String get imagePath {
    return evoImage ?? "";
  }

  ///Take note of the given session to avoid including it in the dayTasks for home page
  void noteStoppedSession(Session session) async {
    stoppedSessionInfo = {
      'Module': session.task,
      'day': session.dateTime.day,
      'startTimeHour': session.dateTime.hour,
      'startTimeMin': session.dateTime.minutes
    };

    //Update database too
    await DatabaseService(uid: uid).updateStoppedSession(stoppedSessionInfo!);
  }

  void removeStoppedSession() async {
    stoppedSessionInfo = null;
    
    await DatabaseService(uid: uid).removeStoppedSession();
  }

  ///Checks if the given session matches that of the stoppedSession
  bool isStoppedSession(Session session) {
    if (stoppedSessionInfo == null) {
      return false;
    }

    bool isSameModule = stoppedSessionInfo!['Module'] == session.task;
    bool isSameStartTime = stoppedSessionInfo!['day'] == session.dateTime.day 
      && stoppedSessionInfo!['startTimeHour'] == session.dateTime.hour 
      && stoppedSessionInfo!['startTimeMin'] == session.dateTime.minutes;

    return isSameModule && isSameStartTime;
  }
}
