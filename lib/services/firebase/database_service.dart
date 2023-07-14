import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/game_logic/xp.dart';
import 'package:time_planner/time_planner.dart';

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
    final Map<String, dynamic> inputs = {'modules': modules, 'freePeriods': periods, 'intensity': intensity};

    return _database.child("${directory[2]}/$uid").update(inputs);
  }

  ///Retrieve previous inputs from firebase
  Future<Map<String, dynamic>> retrieveGeneratorInputs() async {
    //TODO retrieve from database modules, list of freeperiods and intensity
    final String userBranch = '${directory[2]}/$uid';

    return _database.child(userBranch).get()
    .then((snapshot) {
      if (!(snapshot.exists)) {
        List<String> modules = [];
        List<Session> freePeriods = [];

        //User has no previous data saved for the generator
        return {'modules' : modules, 'freePeriods' : freePeriods, 'intensity' : 5};
      }

      return _retrieveInputs(snapshot);
    });
  }

  Future<Map<String, dynamic>> _retrieveInputs (DataSnapshot dataSnapShot) async {

    Map<dynamic, dynamic> data = dataSnapShot.value as Map<dynamic, dynamic>;
    
    List<Object?> moduleData = data['modules'];
    List<Object?> freePeriodData = data['freePeriods'];

    int intensity = data['intensity'];

    List<String> modules = moduleData.map((e) => e.toString()).toList();

    List<Session> freePeriods = freePeriodData
      .map((e) => e as Map<dynamic, dynamic>)
      .map((e) {
        return Session(
          minutesDuration: e['minutesDuration'],
          dateTime: TimePlannerDateTime(day: e['day'], hour: e['startHour'], minutes: e['startMin'])
        );
      })
      .toList();
    
    return {
      'modules' : modules, 'freePeriods' : freePeriods, 'intensity' : intensity
      };
  }

  /// Remove the user data when they delete their account
  Future<void> deleteUserData() async {
    //Remove user data
    await _database.child('${directory[0]}/$uid').remove();

    //Remove quest data
    await _database.child('${directory[1]}/$uid').remove();

    //Finally remove genereator data
    return _database.child('${directory[2]}/$uid').remove();
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
