import 'package:firebase_database/firebase_database.dart';
import 'package:lvlup/models/app_user.dart';


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
      return AppUser.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }


  //TODO update database information when evolve, level up, earn exp etc

  //TODO retrieve quest

  //TODO upload quest

}