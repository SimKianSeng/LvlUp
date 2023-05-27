import 'package:firebase_auth/firebase_auth.dart';

/// Handles the logic of the different authentication cases to modularise the project
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  //authStateChanges() returns a stream of User; 'get' keyword is to declare as a getter
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password  ,
    );
  }

  //Todo: Create user also allows for accountname input
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await currentUser?.sendEmailVerification(
      
    ); //Sends verification email, but never wait for user to verify before letting them enter
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //TODO: Reset password
}
