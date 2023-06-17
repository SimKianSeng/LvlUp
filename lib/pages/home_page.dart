import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

//TODO: work on homepage to match figma prototype
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//TODO: update home page so that it displays the upcoming stuff to study
class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  //TODO how to update from quest page?
  List<TimePlannerTask>? _daytasks;

  //TODO: based on user account
  Image _avatar() {
    return Image.asset("assets/Avatars/Basic Sprite.png");
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

//TODO: listview to display cards
///shows the upcoming tasks for today
  Widget dayTasks() {

    //TODO what does _daytasks contains? Modules, sessions, periods???
    return Expanded(
      child: ListView.builder(
        itemCount: _daytasks?.length?? 0,
        itemBuilder: (context, index) => Card(
          child: Row(
            children: <Widget>[
              _daytasks?.elementAt(index).child ?? Text('Nothing for today'),
            ],
          ),
        )
      )
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
      onPressed: () {
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
      body: Container(
        decoration: bgColour,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            Expanded(child: _avatar()),
            Expanded(
              flex: 3,
              child: Container(
                decoration: contentContainerColour(brRadius: 0.0, blRadius: 0.0),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    _userUid(),
                    dayTasks(),
                  ],
                ),))
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 50.0,
        backgroundColor: Colors.white30,
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
