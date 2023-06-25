import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:lvlup/services/game_logic/xp.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/services/database_service.dart';

class Evolution {
  static const List<Map<String, List<String>>> _evolutions = [
    // evo0 to evo1
    {
      "assets/avatars/evo0/white_man.png": [
        "assets/avatars/evo1/morty.png",
        "assets/avatars/evo1/dirty.png"
      ],
    },

    // evo1 to evo2
    {
      "assets/avatars/evo1/morty.png": [
        "assets/avatars/evo2/genin_morty.png",
        "assets/avatars/evo2/padawan_morty.png"
      ],
      "assets/avatars/evo1/dirty.png": [
        "assets/avatars/evo2/stony.png",
      ]
    },

    // evo2 to evo3
    {
      "assets/avatars/evo2/genin_morty.png": [
        "assets/avatars/evo3/shinobi_morty.png",
      ],
      "assets/avatars/evo2/padawan_morty.png": [
        "assets/avatars/evo3/jedi_morty.png",
        "assets/avatars/evo3/mercenery_morty.png"
      ],
      "assets/avatars/evo2/stony.png": [
        "assets/avatars/evo3/rocky.png",
        "assets/avatars/evo3/boudy.png"
      ]
    },

    // evo3 to evo4
    {
      "assets/avatars/evo3/shinobi_morty.png": [
        "assets/avatars/evo4/cyborg_shinobi.png",
      ],
      "assets/avatars/evo3/jedi_morty.png": [
        "assets/avatars/evo4/grand_master.png",
      ],
      "assets/avatars/evo3/mercenery_morty.png": [
        "assets/avatars/evo4/gang_leader.png",
      ],
      "assets/avatars/evo3/rocky.png": [
        "assets/avatars/evo4/swordy.png",
      ],
      "assets/avatars/evo3/boudy.png": [
        "assets/avatars/evo4/goldy.png",
      ],
    },
  ];

  static bool canEvolve(int level) {
    if (level == 21 || level == 41 || level == 61 || level == 81) {
      return true;
    }
    return false;
  }

  static int getEvolutionStage(int xp) {
    return ((Xp.getLevel(xp) - 1) / 20).floor();
  }

  static int evolve(int evoState) {
    return evoState + 1;
  }

  static List<String> getEvolutions(AppUser currentUser) {
    return _evolutions[currentUser.evoState!][currentUser.evoImage!]!;
  }

  static List<Widget> generateAvatars(
      List<String> evolutions, AppUser currentUser, BuildContext context) {
    List<Widget> widgets = [];

    evolutions.forEach((imagePath) {
      String filename = basename(imagePath);
      filename = filename.substring(0, filename.length - 4);
      AppUser appUser = AppUser.fromJson(currentUser.uid, currentUser.toJson());
      appUser.characterName = filename;
      appUser.evoImage = imagePath;

      widgets.add(
        Column(children: [
          Image.asset(imagePath),
          ElevatedButton(
            onPressed: () {
              DatabaseService _db = DatabaseService(uid: currentUser.uid);
              _db.evolve(appUser);
              Navigator.pop(context);
            },
            child: Text(currentUser.characterName!),
          ),
          SizedBox(height: 20),
        ]),
      );
    });
    return widgets;
  }
}
