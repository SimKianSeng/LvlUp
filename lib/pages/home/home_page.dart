import 'package:flutter/material.dart';
import 'package:lvlup/pages/home/user_data.dart';
import 'package:lvlup/services/database_service.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppUser? currentAppUser;
  // final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppUser?>(context);

    return StreamProvider<AppUser?>.value(
      value: DatabaseService(uid: currentUser!.uid).userData, 
      initialData: null,
      child: const UserData());
  }
}
