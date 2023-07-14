import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';

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
          return {'modules': [], 'freePeriods': [], 'intensity': 5};
        }

        return _retrieveInputs(snapshot);
      });
  }

  Map<String, dynamic> _retrieveInputs(DataSnapshot snapshot) {
    List<DataSnapshot> data = snapshot.children.toList();

    //Some error regarding range here

    // List<Session> freePeriods = data[0].children
    //   .map((sessionDataSnapShot) {

    //     Map<String, dynamic> sessionData = sessionDataSnapShot.value as Map<String, dynamic>;
        
    //     return Session(
    //       minutesDuration: sessionData['minutesDuration'], 
    //       dateTime: TimePlannerDateTime(day: sessionData['day'], hour: sessionData['startHour'], minutes: sessionData['startMin'])
    //     );
    //     })
    //   .toList();
    List<Session> freePeriods = [];

    int intensity = data[1].value as int;

    //Some error regarding range here
    Map<dynamic, String> moduleBranch = data[2].value as Map<dynamic, String>;
    List<String> modules = moduleBranch.values.toList();
    // List<String> modules = [];
    
    return {'modules': modules, 'freePeriods': freePeriods, 'intensity': intensity};
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

  group('Updating and retrieving generator inputs', () {
    test('Retrieval of inputs', () async {
      final data = await userRepo.getGeneratorInputs(uid);
    });
  });

}