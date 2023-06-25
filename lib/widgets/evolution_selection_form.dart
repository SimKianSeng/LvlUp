import 'package:flutter/material.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/services/game_logic/evolution.dart';

Widget evolution_selection_form(AppUser currentUser) {
  return AlertDialog(
    scrollable: true,
    title: const Text("Select evolution path"),
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          children: Evolution.generateAvatars(
              Evolution.getEvolutions(currentUser), currentUser),
        ),
      ),
    ),
  );
}
