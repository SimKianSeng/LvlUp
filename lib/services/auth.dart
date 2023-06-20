// import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lvlup/models/user.dart';

/// Handles the logic of the different authentication cases to modularise the project
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  User? get currentUser => _firebaseAuth.currentUser;

  //authStateChanges() returns a stream of User; 'get' keyword is to declare as a getter
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Future<UserApp?> _userFromFirebase(User? user) async {
  //   const String databaseTree = 'users';

  //   if (user == null) {
  //     return null;
  //   }

  //   DataSnapshot userData = await _database.child(databaseTree).child(user.uid).get();

  //   return userData.exists ? UserApp(userData) : null;
  // }

  // Stream<UserApp?> get user {
  //   return _firebaseAuth.authStateChanges().map((user) => _userFromFirebase(user));   
  // }

  //TODO instanciate user account
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  //Todo: Create user also allows for accountname input
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required BuildContext context,
  }) async {
    try {
      if (password != passwordConfirmation) {
        throw FirebaseAuthException(code: 'Password mismatched');
      }

      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      }
      if (e.code == 'Password mismatched') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Passwords do not match!')));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email, required BuildContext context}) async {
    try {
      if (email == "") {
        throw FirebaseAuthException(code: 'No-email');
      }
      
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("A password reset email has been sent to your email account"),
        duration: Duration(seconds: 3),
        ));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The email account is invalid.')));
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account does not exist.')));
      } else if (e.code == 'No-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please input your email in the email text field.')));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteUser() async {
    await currentUser?.delete();
  }
}
