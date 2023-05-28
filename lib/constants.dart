import 'package:flutter/material.dart';

///Provides the decoration property of a container
BoxDecoration bgColour = const BoxDecoration(
                          gradient: LinearGradient(
                            begin:Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF7B5EFE),
                              Color(0xFFB88CED),
                              // Color(0xFFCF9EE7),
                              Color(0xFFE4AEE1),
                            ]
                          )
                        );


///Provides the decoration property for a textfield
InputDecoration customTextField(String initText) {
  return InputDecoration(
    labelText: initText,
    labelStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white38,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
  );
}