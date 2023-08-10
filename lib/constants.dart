import 'package:flutter/material.dart';

///Provides the background colour for the app
BoxDecoration bgColour = const BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
      Color(0xFF7B5EFE),
      Color(0xFFB88CED),
      Color(0xFFE4AEE1),
    ]));

///Provide the decoration for the background widget of contents in a container widget
BoxDecoration contentContainerColour(
    {double tlRadius = 25.0,
    double trRadius = 25.0,
    double blRadius = 25.0,
    double brRadius = 25.0,
    Color color = Colors.white60}) {
  return BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(tlRadius),
      topRight: Radius.circular(trRadius),
      bottomLeft: Radius.circular(blRadius),
      bottomRight: Radius.circular(brRadius),
    ),
    color: color,
  );
}

///Provides the decoration property for a textfield
InputDecoration customTextField({String initText = ''}) {
  return InputDecoration(
      labelText: initText,
      labelStyle: const TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white38,
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ));
}

///Customised button style for ElevatedButton
ButtonStyle customButtonStyle(
    {Color? color = Colors.purple, double radius = 25.0}) {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(color),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))));
}

///Tooltip to inform user the purpose of that feature and/or how to use it
Tooltip useHint(String hint, {Color color = Colors.grey}) {
  return Tooltip(
    message: hint,
    triggerMode: TooltipTriggerMode.tap,
    child: Icon(Icons.help, color: color),
  );
}