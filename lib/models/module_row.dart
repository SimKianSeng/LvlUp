import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/services/generator.dart';

class ModuleRow extends StatefulWidget {
  int index;
  Generator generator = Generator();

  ModuleRow({required this.index, required this.generator, super.key});

  @override
  State<ModuleRow> createState() => _ModuleRowState();
}

class _ModuleRowState extends State<ModuleRow> {
  String module = '';
  // bool error = false;

  void updateModule(String module) {
    if (widget.generator.alreadyInput(module)) {
      //module has been input, do not update
      // setState(() {
      //   error = true;
      // });
      const message = SnackBar(
        content: Text('Module has been entered previously'),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(message);
    } else {
      //module has not been previously input, update
      // setState(() {
      //   error = false;
      // });

      this.module = module;
      widget.generator.addModuleRanked(module, widget.index);  
    }
  }

  //TODO
  ///To move up and down the rank column and delete the module
  // Widget _additionalStuff() {
  //   return GestureDetector(
  //     child: const Icon(Icons.menu, color: Colors.black,),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.menu, color: Colors.black,),
          SizedBox(width: widget.index == 1 ? 68.0 : 135.0,),
          widget.index == 1 ? const Text('Module 1 (Weakest):') : Text('Module ${widget.index}:'),
          const SizedBox(width: 25.0,),
          SizedBox(
            height: 50.0,
            width: 100.0,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: customTextField(''),
              onChanged: (value) {
                if (module != '' && value != module) {
                  widget.generator.removeModule(module);
                }
                
                module = value;
                updateModule(module);
              },
              onSubmitted: (value) => updateModule(value),
              onTapOutside: (event) {
                if (!widget.generator.alreadyInput(module)) {
                  widget.generator.addModuleRanked(module, widget.index);
                }
              },
            ),
          ),
          // SizedBox(
          //   width: 20.0,
          //   child: error ? Icon(Icons.error, color: Colors.red[300],) : const Placeholder(),
          // )
        ],
      ),
    );
  }
}