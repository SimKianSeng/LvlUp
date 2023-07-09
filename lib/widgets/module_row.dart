import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/services/generator.dart';

class ModuleRow extends StatefulWidget {
  final int index;
  final Generator generator = Generator();

  ModuleRow({required this.index, super.key});

  @override
  State<ModuleRow> createState() => _ModuleRowState();
}

class _ModuleRowState extends State<ModuleRow> {
  String module = '';

  bool hasNoInput() {
    return module == '';
  }

 void updateModule(String module) {
    if (widget.generator.alreadyInput(module)) {
      //module has been input, do not update
      const message = SnackBar(
        content: Text('Module has been entered previously'),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(message);
    } else if (module != '' && this.module != module) {
      //module has not been previously input, update
      this.module = module;
    }
    
    widget.generator.updateModule(module, widget.index);  
  }

  //TODO removing the module input
  // Widget _removeModuleInput() {
  //   return GestureDetector(
  //     child: const Icon(Icons.menu, color: Colors.black,),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: widget.index == 1 ? 68.0 : 135.0),
          widget.index == 1 ? const Text('Module 1 (Weakest):') : Text('Module ${widget.index}:'),
          const SizedBox(width: 25.0,),
          SizedBox(
            width: 100.0,
            height: 35.0,
            child: TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              onChanged: (value) => updateModule(value),
              decoration: customTextField(),
            ),
          ),
        ],
      ),
    );
  }
}