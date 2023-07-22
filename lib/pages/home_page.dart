import 'package:flutter/material.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/firebase/database_service.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:lvlup/services/game_logic/evolution.dart';
import 'package:lvlup/services/game_logic/xp.dart';
import 'package:lvlup/services/game_logic/tier.dart';
import 'package:lvlup/widgets/evolution_selection_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppUser?>(context);

    if (currentUser == null) {
      return Container(
        color: Colors.white,
        child: const CircularProgressIndicator(),
      );
    }

    //To retrieve data stored in database
    final DatabaseService database = DatabaseService(uid: currentUser.uid);

    return StreamProvider<AppUser?>.value(
        value: database.userData,
        initialData: null,
        child: StreamProvider<List<Session>?>.value(
          value: database.quest,
          initialData: const [],
          child: const UserData(),
        ));
  }
}

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  bool _evolving = false;
  bool updatedDayTask = false;
  AppUser? currentAppUser;
  List<Session>? _daytasks;

  void _updateDayTask(AppUser currentAppUser) {
    //For android emulator, take note that DateTime.now() is based on the virtual device
    final now = DateTime.now();

    _daytasks = currentAppUser
        .getSavedQuest()
        .where((session) =>
            session.dateTime.day == now.weekday - 1 &&
            session.dateTime.hour >= now.hour && 
            !(currentAppUser.isStoppedSession(session))
            )
        .toList();
  }

  Image _avatar(String imagePath) {
    return Image.asset(imagePath);
  }

  Widget _userData(AppUser currentUser) {
    int curLevel = Xp.getLevel(currentUser.xp!);
    int curXp = Xp.getCurXp(currentUser.xp!);
    int curXpCap = Xp.getCurXpCap(currentUser.xp!);
    // int newEvoState = Evolution.getEvolutionStage(currentUser.xp!);
    AppUser updatedUser =
        AppUser.fromJson(currentUser.uid, currentUser.toJson());
    updatedUser.evoState = Evolution.getEvolutionStage(currentUser.xp!);
    updatedUser.tierName = Tier.getTierName(curLevel);

    _evolving = false;
    if (!_evolving &&
        updatedUser.evoState! == currentUser.evoState! + 1 &&
        updatedUser.tierName! != currentUser.tierName!) {
      _evolving = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _evolving = true;
        // currentUser.evoState = currentUser.evoState! + 1;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => evolutionSelectionForm(currentUser, context),
        );
      });
      _evolving = false;
    }

    Widget names = SizedBox(
      width: 150,
      child: Column(
        children: <Widget>[
          Text(currentUser.username!,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          Text(updatedUser.tierName!,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0)),
          Text(updatedUser.characterName!,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0)),
        ],
      ),
    );

    Widget exp = SizedBox(
      width: 200,
      child: Column(
        children: <Widget>[
          Text("Level: $curLevel",
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0)),
          Text("$curXp / $curXpCap"),
          LinearProgressIndicator(
            value: curXp / curXpCap,
            color: Colors.greenAccent,
            minHeight: 10.00,
          ),
        ],
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[names, exp],
    );
  }

  ///shows the upcoming tasks for today
  Widget dayTasks() {
    if (_daytasks == null) {
      return Center(
        child: Text(
          "There are no study sessions today",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      );
    } else if (_daytasks!.isEmpty) {
      return Center(
          child: Text(
        "There are no remaining study sessions today",
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ));
    }

    return Expanded(
        child: ListView.builder(
            itemCount: _daytasks?.length,
            itemBuilder: (context, index) => Card(
                elevation: 0,
                color: Colors.transparent,
                child: _daytasks?[index].displayDayTask(context))));
  }

  IconButton _startSessionButton(BuildContext context, AppUser currentAppUser) {
    DateTime currentTime = DateTime.now();

    //Edge case: _dayTasks is empty
    bool taskAvail = _daytasks != null && _daytasks!.isNotEmpty;

    Session? nextSession;

    if (taskAvail) {
      nextSession = _daytasks![0];
    }

    DateTime startTime = taskAvail
        ? DateTime(currentTime.year, currentTime.month, currentTime.day,
            nextSession!.startTime().hour, nextSession.startTime().minute)
        : DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0);

    DateTime endTime = taskAvail
        ? DateTime(currentTime.year, currentTime.month, currentTime.day,
            nextSession!.endTime().hour, nextSession.endTime().minute)
        : DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0);

    bool isStudyTime =
        currentTime.isAfter(startTime) && currentTime.isBefore(endTime);

    Stream timer = Stream.periodic(const Duration(seconds: 1), (i) {
      currentTime = currentTime.add(const Duration(seconds: 1));
      return currentTime;
    });

    final timerSubscriber = timer.listen((data) {
      setState(() {
        isStudyTime =
            currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
      });
    });

    Duration duration = endTime.difference(currentTime);
    Duration breakRemaining = taskAvail
        ? nextSession!.breakRemaining(currentTime.difference(startTime))
        : const Duration();

    if (duration.inSeconds < 0) {
      // endTime of 1st session is after currentTime
      _updateDayTask(currentAppUser);
    }

    if (!taskAvail) {
      // No need for us to time, allow us to save resources
      timerSubscriber.cancel();
    }

    return IconButton(
      iconSize: 30.0,
      onPressed: isStudyTime
          ? () async {
              final infoReturned = await Navigator.pushNamed(context, '/timer',
                  arguments: {
                    'session': nextSession,
                    'duration': duration,
                    'break': breakRemaining
                  }) as List<Object?>;

              final xpEarned = infoReturned[0] as int;
              
              currentAppUser.noteStoppedSession(infoReturned[1] as Session);

              setState(() {
                updatedDayTask = false;
                DatabaseService(uid: currentAppUser.uid)
                    .updateXpByXp(xpEarned, currentAppUser);
                _updateDayTask(currentAppUser);
              });
            }
          : null,
      icon: const Icon(Icons.play_arrow),
      color: Colors.greenAccent[400],
      disabledColor: Colors.grey,
    );
  }

  IconButton _settingsButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        icon: const Icon(Icons.settings));
  }

  IconButton _scheduleGenButton(BuildContext context, AppUser currentAppUser) {
    return IconButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/scheduleGen',
              arguments: currentAppUser);

          setState(() {
            updatedDayTask = false;
            _updateDayTask(currentAppUser);
          });
        },
        icon: const Icon(Icons.calendar_month));
  }

  IconButton _studyStatsButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/studyStats');
        },
        icon: const Icon(Icons.wysiwyg));
  }

  @override
  Widget build(BuildContext context) {
    final currentAppUser = Provider.of<AppUser?>(context);
    final quest = Provider.of<List<Session>?>(context);

    if (currentAppUser == null || quest == null) {
      //quest is null
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!updatedDayTask) {
      updatedDayTask = !updatedDayTask;
      currentAppUser.updateQuest(quest);
      _updateDayTask(currentAppUser);
    }

    return Scaffold(
        body: Container(
          decoration: bgColour,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              Expanded(child: _avatar(currentAppUser.imagePath)),
              Expanded(
                  flex: 3,
                  child: Container(
                    decoration:
                        contentContainerColour(brRadius: 0.0, blRadius: 0.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _userData(currentAppUser),
                        const SizedBox(height: 25.0),
                        const Text('Task',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold)),
                        dayTasks(),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 50.0,
          backgroundColor: Colors.white30,
          destinations: [
            _startSessionButton(context, currentAppUser),
            _scheduleGenButton(context, currentAppUser),
            // _studyStatsButton(context), //Will uncomment after implementation
            _settingsButton(context),
          ],
        ));
  }
}
