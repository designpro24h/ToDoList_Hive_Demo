import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive_app/data/todo_data.dart';
import 'package:todo_hive_app/utils/dialogbox_widget.dart';
import 'package:todo_hive_app/utils/todo_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _txtController = TextEditingController();
  // reference the hive box
  var _myBox = Hive.box('todoBox');
  TodoData db = TodoData();
  //
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_txtController.text, false]);
      _txtController.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

// function create
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBoxWidget(
            controller: _txtController,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  //
  void deletedTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  //
  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get("TO_DO_LIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO APP'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTitle(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deletedTask(index),
          );
        },
      ),
    );
  }
}
