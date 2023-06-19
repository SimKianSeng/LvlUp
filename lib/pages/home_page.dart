import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:lvlup/services/generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  List<Session>? _daytasks;

  //TODO: based on user account
  Image _avatar() {
    return Image.asset("assets/Avatars/Basic Sprite.png");
  }

  //TODO: change this to reflect the user account name not their email
  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  IconButton _startSessionButton (BuildContext context) {
    bool study = true; 

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

//TODO: update _dayTasks to show day remaining task and not all task in the day
  void _updateDayTask() {
    final now = DateTime.now();

    //TODO: .hour bool not working as intended, seems like it looks at PM and AM not 24h format
    _daytasks = Generator().quest?.where((session) => 
      session.dateTime.day == now.weekday - 1 && 
      session.dateTime.hour >= now.hour)
    .toList();
  }


///shows the upcoming tasks for today
  Widget dayTasks() {
    if (_daytasks == null) {
      return Center(
        child: Text("There are no tasks for today",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _daytasks?.length,
        itemBuilder: (context, index) => Card(
          elevation: 0,
          color: Colors.transparent,
          child: _daytasks?[index].displayDayTask(context)
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
      onPressed: () async {
        await Navigator.pushNamed(context, '/scheduleGen');

        setState(() {
          print(_daytasks);
          _updateDayTask();
          print(_daytasks);
        });
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
                    const Text('Task', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
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
