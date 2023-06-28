import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup/models/app_user.dart';

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

  MockFirebaseDatabase.instance.ref().child("users/$uid").set(fakeData);
  setUp(() {
    firebaseDatabase = MockFirebaseDatabase.instance;
    userRepo = UserRepo(firebaseDatabase: firebaseDatabase);
  });

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

}