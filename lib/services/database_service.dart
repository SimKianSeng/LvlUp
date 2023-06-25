import 'package:firebase_database/firebase_database.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/game_logic/xp.dart';

class DatabaseService {
  final String uid;
  static final _database = FirebaseDatabase.instance.ref();

  DatabaseService({required this.uid});

  ///Update realtime database with the registration of a new user
  static Future createUser(Map<String, Object?> newUser) {
    return _database.child('users').update(newUser);
  }

  ///Retrieve user data stored in database and convert it into appUser
  Stream<AppUser?> get userData {
    return _database.child('users/$uid').onValue.map((event) {
      return AppUser.fromJson(
          uid, event.snapshot.value as Map<dynamic, dynamic>);
    });
  }

  //TODO update database information when evolve, level up, earn exp etc

  ///Retrieve the saved quest from firebase
  Stream<List<Session>?> get quest {
    return _database
        .child('quests/$uid')
        .onValue
        .map((event) => _questFromDatabase(event.snapshot));
  }

  List<Session> _questFromDatabase(DataSnapshot snapshot) {
    return snapshot.children.map((sessionData) {
      return Session.fromJson(sessionData.value as Map<dynamic, dynamic>);
    }).toList();
  }

  /// Remove the user data when they delete their account
  Future<void> deleteUserData() {
    return _database.child('quests/$uid').remove();
  }

  ///Update firebase with the newly generated user Quest
  Future<void> updateQuest(List<Session> quest) {
    //only accept string, bool, double, map or list
    List<Map<String, dynamic>> questMap = quest
        .map((session) => {
              'day': session.dateTime.day,
              'minutesDuration': session.minutesDuration,
              'startHour': session.dateTime.hour,
              'startMin': session.dateTime.minutes,
              'task': session.task
            })
        .toList();

    return _database.child('quests/$uid').set(questMap);
  }

  Future<void> updateXP(int currentXP, Duration duration) {
    
    currentXP = Xp.incrXP(duration, currentXP);

    return _database.child('users/$uid').update({'xp': currentXP});
  }

  Future<void> evolve(AppUser currentUser, String imagePath) {
    currentUser.evoState = currentUser.evoState! + 1;
    currentUser.evoImage = imagePath;
    return _database.child('users/$uid').update(currentUser.toJson());
  }
}
