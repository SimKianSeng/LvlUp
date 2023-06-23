import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/models/session.dart';
import 'package:lvlup/services/generator.dart';
import 'package:provider/provider.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => UserDataState();
}

class UserDataState extends State<UserData> {

  List<Session>? _daytasks;

  @override
  void initState() {
    super.initState();
    _updateDayTask();
  }

  void _updateDayTask() {
    //For android emulator, take note that DateTime.now() is based on the virtual device
    final now = DateTime.now();

    //TODO change to app_user
    _daytasks = Generator()
        .quest
        ?.where((session) =>
            session.dateTime.day == now.weekday - 1 &&
            session.dateTime.hour >= now.hour)
        .toList();
  }

  Image _avatar(String imagePath) {
    return Image.asset(imagePath);
  }


  Widget _userData(AppUser currentUser) {
    const maxExp = 1000;

    Widget names = SizedBox(
      width: 150,
      child: Column(
        children: <Widget>[
          Text(currentUser.username!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0)),
          Text(currentUser.tierName!,
            style: TextStyle(
              color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 15.0)),
          Text(currentUser.characterName!,
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
          Text("${currentUser.xp} / $maxExp"),
          LinearProgressIndicator(
            value: currentUser.xp! / maxExp,
            color: Colors.greenAccent,
            minHeight: 10.00,
          ),
        ],
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        names,
        exp
      ],
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
        ),
      );
    }

    return Expanded(
        child: ListView.builder(
            itemCount: _daytasks?.length,
            itemBuilder: (context, index) => Card(
                elevation: 0,
                color: Colors.transparent,
                child: _daytasks?[index].displayDayTask(context))));
  }

   IconButton _startSessionButton(BuildContext context) {
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

    if (!taskAvail) {
      //No need for us to time, allow us to save resources
      timerSubscriber.cancel();
    }

    Duration duration = endTime.difference(currentTime);

    return IconButton(
      iconSize: 30.0,
      onPressed: isStudyTime
          ? () async {
              //TODO: update exp, level up if hit 1000xp, evolution etc as required
              //TODO: remove the task
              final timeStudied = await Navigator.pushNamed(context, '/timer',
                  arguments: duration) as Duration;

              // setState(() {
              //   //TODO how am i going to test this feature without spending 25minutes
              //   //Perhaps can add in some sort of cheat code? Unit testing perhaps
              //   //TODO current issue in assigning currentAppUser
              //   currentAppUser!.updateXP(timeStudied);
              // });
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

  IconButton _scheduleGenButton(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/scheduleGen', /*arguments: currentAppUser!.quest*/
          );

          setState(() {
            _updateDayTask();
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
    final userData = Provider.of<AppUser?>(context);

    return userData == null
      ? const CircularProgressIndicator()
      : Scaffold(
        body: Container(
          decoration: bgColour,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              Expanded(child: _avatar(userData.imagePath)),
              Expanded(
                  flex: 3,
                  child: Container(
                    decoration: contentContainerColour(
                        brRadius: 0.0, blRadius: 0.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _userData(userData),
                        const SizedBox(height: 25.0),
                        const Text('Task',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
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
            _startSessionButton(context),
            _scheduleGenButton(context),
            // _studyStatsButton(context), //Will uncomment after implementation
            _settingsButton(context),
          ],
        ));
  }
}