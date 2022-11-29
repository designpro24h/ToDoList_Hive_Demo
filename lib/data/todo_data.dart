import 'package:hive_flutter/hive_flutter.dart';

class TodoData {
  List toDoList = [];

  var _myBox = Hive.box('todoBox');

  void createInitialData() {
    toDoList = [
      ['Flutter Tutorial', false],
      ['Python Tutorial', false],
    ];
  }

  void loadData() {
    toDoList = _myBox.get("TO_DO_LIST");
  }

  //update data
  void updateData() {
    _myBox.put("TO_DO_LIST", toDoList);
  }
}
