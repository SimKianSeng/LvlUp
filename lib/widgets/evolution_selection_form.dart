import 'package:flutter/material.dart';

Widget evolution_selection_form() {
  return AlertDialog(
    scrollable: true,
    title: const Text("Select evolution path"),
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Row(
          children: [
            // TextFormField(
            //   decoration: const InputDecoration(
            //     labelText: "Name",
            //     icon: Icon(Icons.account_box),
            //   ),
            // ),
            // TextFormField(
            //   decoration: const InputDecoration(
            //     labelText: "Email",
            //     icon: Icon(Icons.email),
            //   ),
            // ),
            // TextFormField(
            //   decoration: const InputDecoration(
            //     labelText: "Message",
            //     icon: Icon(Icons.message),
            //   ),
            // ),
            Column(children: [
              Text("hello"),
              ElevatedButton(
                onPressed: () {},
                child: Text("morty"),
              ),
            ]),
            Column(children: [
              Text("hello"),
              ElevatedButton(
                onPressed: () {},
                child: Text("rick"),
              ),
            ]),
            Column(children: [
              Text("hello"),
              ElevatedButton(
                onPressed: () {},
                child: Text("test"),
              ),
            ]),
          ],
        ),
      ),
    ),
    actions: [
      ElevatedButton(
        child: const Text("submit"),
        onPressed: () {
          // your code
        },
      ),
    ],
  );
}
