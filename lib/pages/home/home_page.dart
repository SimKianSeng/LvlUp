import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/pages/home/user_data.dart';
import 'package:lvlup/services/firebase/database_service.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppUser? currentAppUser;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppUser?>(context);
    
    if (currentUser == null) {
      return Container(
        child: CircularProgressIndicator(),
      );
    }
    final DatabaseService database = DatabaseService(uid: currentUser.uid);

    return StreamProvider<AppUser?>.value(
      value: database.userData, 
      initialData: null,
      child: StreamProvider<List<Session>?>.value(
        value: database.quest,
        initialData: const [],
        child: const UserData(),));
  }
}
