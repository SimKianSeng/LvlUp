import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:time_planner/time_planner.dart';

class UserRepo {
  FirebaseDatabase firebaseDatabase;

  UserRepo({required this.firebaseDatabase});

  Future<AppUser?> getUser(String uid) async {
    final userNameRef = firebaseDatabase.ref().child('users/$uid');
    final dataSnapShot = await userNameRef.get();

    return AppUser.fromJson(uid, dataSnapShot.value as Map<dynamic, dynamic>);
  }

  Future<void> updateXP(String uid, int xp) async {
    final userNameRef = firebaseDatabase.ref().child('users/$uid');

    return userNameRef.update({'xp' : xp});
  }

  Future<Map<String, dynamic>> getGeneratorInputs(String uid) async {
    final generatorRef = firebaseDatabase.ref().child('generator/$uid');

    final datasnapshot = generatorRef.get();


    return datasnapshot.then((snapshot) {
        if (!(snapshot.exists)) {
          //Default values for the 3 inputs
          List<Session> freePeriods = [];
          List<String> modules = [];
          
          return {'modules': modules, 'freePeriods': freePeriods, 'intensity': 5};
        }

        return _retrieveInputs(snapshot);
      });
  }

  Map<String, dynamic> _retrieveInputs(DataSnapshot dataSnapShot) {
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
}

void main() {
  FirebaseDatabase firebaseDatabase;
  late UserRepo userRepo;

  //Fake data
  const uid = 'userUID';
  const fakeData = {
    'username': 'test',
    'characterName': 'White Man',
    'tierName': 'Nooby Noob',
    'xp': 50,
    'evoState': 0,
    'evoImage': "assets/avatars/evo1/morty.png",
  };

  const freePeriodOne = 
  {
    'day' : 0,
    'minutesDuration': 120,
    'startHour': 5,
    'startMin': 30,
    };

  const freePeriodTwo = 
  {
    'day' : 1,
    'minutesDuration': 30,
    'startHour': 10,
    'startMin': 30,
    };

  const fakeInputs = {
    'modules': ['TEST1', 'TEST2', 'TEST3'],
    'freePeriods': [freePeriodOne, freePeriodTwo],
    'intensity': 10
  };

  //Update the mockdatabase with the fake user data and fake generator inputs for the user
  MockFirebaseDatabase.instance.ref().child("users/$uid").set(fakeData);
  MockFirebaseDatabase.instance.ref().child("generator/$uid").set(fakeInputs);
  setUp(() {
    firebaseDatabase = MockFirebaseDatabase.instance;
    userRepo = UserRepo(firebaseDatabase: firebaseDatabase);
  });

  //Check if current method for retrieving the data works as intended without errors
  group('Retrieving app user', () {
    test('Retrieving userName', () async {
      final appUser = await userRepo.getUser(uid);
      final username = appUser?.username ?? '';

      expect('test', username);
    });

    test('Updating xp and retrieving', () async {
      final AppUser? appUser = await userRepo.getUser(uid);
      final int xp = (appUser!.xp ?? 0) + 50;

      userRepo.updateXP(uid, xp);
      final AppUser? currentUser = await userRepo.getUser(uid);

      final newXP = currentUser!.xp ?? 0;


      expect(100, newXP);
    });
  });

  group('Retrieving generator inputs', () {
    
    test('Retrieval of modules', () async {
      final data = await userRepo.getGeneratorInputs(uid);
      
      expect(['TEST1', 'TEST2', 'TEST3'], data['modules']);
    });

    test('Retrieval of intensity', () async {
      final data = await userRepo.getGeneratorInputs(uid);

      expect(10, data['intensity']);
    });
  });

}