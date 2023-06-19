import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';

class Timer extends StatelessWidget {
  // final startTime;

  const Timer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text('Timer'), centerTitle: true,),
      body: Container(
        decoration: bgColour,
        
      ),
    );
  }
}