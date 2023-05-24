import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/services/auth.dart';
import 'package:flutter/material.dart';

//TODO: work on homepage to match figma prototype
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  

  Widget _title() {
    return const Text('Home');
  }

  //TODO: change this to reflect the user account name not their email
  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }


  IconButton _startSessionButton (BuildContext context) {
    bool study = false; 

    return IconButton(
            iconSize: 30.0, 
            onPressed: () async {
              //todo: Implement time tracker and link to schedule
              //todo: Create timer page and add to route in main.dart
              if (study) {
                await Navigator.pushNamed(context, '/timer');
              }
            }, 
            icon: study ? Icon(Icons.play_arrow, color: Colors.greenAccent[400],) : Icon(Icons.play_arrow, color: Colors.grey,),
          );  
  }

  IconButton _settingsButton(BuildContext context) {
    return IconButton(
      onPressed: (){
        Navigator.pushNamed(context, '/settings');
      }, 
      icon: const Icon(Icons.settings));
  }

  IconButton _scheduleGenButton(BuildContext context) {
    return IconButton(
      onPressed: (){
        Navigator.pushNamed(context, '/scheduleGen');
      }, 
      icon: const Icon(Icons.calendar_month));
  }

  IconButton _studyStatsButton(BuildContext context) {
    return IconButton(
      onPressed: (){
        Navigator.pushNamed(context, '/studyStats');
      }, 
      icon: const Icon(Icons.wysiwyg));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        actions: <Widget>[

        ], //Buttons on appbar right
      ),
      body: Container(
        decoration: bgColour,
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            // _signOutButton(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          _startSessionButton(context),
          _scheduleGenButton(context),
          _studyStatsButton(context),
          _settingsButton(context),
        ],
      )
    );
  }
}
