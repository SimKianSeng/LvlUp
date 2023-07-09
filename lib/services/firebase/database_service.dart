import 'package:firebase_database/firebase_database.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/game_logic/xp.dart';

class DatabaseService {
  final String uid;
  static final _database = FirebaseDatabase.instance.ref();

  //Used to help minimise typo error in updating and retrieving from database
  static final List<String> directory = [
    "users",
    "quests",
    "generator",
  ];

  DatabaseService({required this.uid});

  ///Update realtime database with the registration of a new user
  static Future createUser(Map<String, Object?> newUser) {
    return _database.child(directory[0]).update(newUser);
  }

  ///Retrieve user data stored in database and convert it into appUser
  Stream<AppUser?> get userData {
    return _database.child('${directory[0]}/$uid').onValue.map((event) {
      if (event.snapshot.value == null) {
        return null;
      }

      return AppUser.fromJson(
          uid, event.snapshot.value as Map<dynamic, dynamic>);
    });
  }

  ///Retrieve the saved quest from firebase
  Stream<List<Session>?> get quest {
    return _database
        .child('${directory[1]}/$uid')
        .onValue
        .map((event) => _questFromDatabase(event.snapshot));
  }

  List<Session> _questFromDatabase(DataSnapshot snapshot) {
    return snapshot.children.map((sessionData) {
      return Session.fromJson(sessionData.value as Map<dynamic, dynamic>);
    }).toList();
  }

  ///Update firebase with the current input
  Future<void> updateGeneratorInputs(List<String> modules, List<Session> freePeriods, int intensity) {
    //Convert freePeriods into a database-friendly type
    List<Map<String, dynamic>> periods = freePeriods.map((session) => 
      {
        'day' : session.dateTime.day,
        'minutesDuration': session.minutesDuration,
        'startHour': session.dateTime.hour,
        'startMin': session.dateTime.minutes,
      }).toList();

    //Convert input into a map to update firebase with
    Map<String, dynamic> inputs = {'modules': modules, 'freePeriods': periods, 'intensity': intensity};

    return _database.child("${directory[2]}/$uid").update(inputs);
  }

  ///Retrieve previous inputs from firebase
  Stream retrieveGeneratorInputs() {
    //TODO retrieve from database modules, list of freeperiods and intensity
    return _database.child("${directory[2]}/$uid").onValue.map((event) => event.snapshot);
  }

  /// Remove the user data when they delete their account
  Future<void> deleteUserData() async {
    await _database.child('${directory[0]}/$uid').remove();

    return _database.child('${directory[1]}/$uid').remove();
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

  Future<void> updateXP(Duration duration, AppUser currentUser) {
    final int newXp = Xp.incrXP(duration, currentUser);

    return _database.child('users/$uid').update({'xp': newXp});
  }

  Future<void> evolve(AppUser currentUser, String imagePath) {
    currentUser.evoState = currentUser.evoState! + 1;
    currentUser.evoImage = currentUser.evoImage!;
    currentUser.evoImage = currentUser.evoImage!;
    return _database.child('users/$uid').update(currentUser.toJson());
  }
}
