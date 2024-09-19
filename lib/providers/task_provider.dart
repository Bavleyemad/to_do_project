import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_project/App_date_utilts.dart';
import 'package:to_do_project/database/task_collection.dart';
import 'package:to_do_project/database/task_name.dart';

class TaskProvider extends ChangeNotifier {
  var taskCollection = TaskCollections();

  Future<List<Task>> getAllTasks(String userId, DateTime selectedDate) async {
    var taskList = await taskCollection.getAllTasks(userId,selectedDate.dateOnly());

    return taskList;
  }

  Future<void> addTask(String userId, Task task) async {
    await taskCollection.CreateTask(userId, task);
    notifyListeners();
    return;
  }

  Future<void> removeTask(String userId, Task task) async {
    await taskCollection.removeTask(userId, task);
    notifyListeners();
    return;
  }
  Future<void> editTask(String userId, Task task) async {
    await taskCollection.editTask(userId, task);
    notifyListeners();
  }
  Future<void> toggleTaskDone(String userId, Task task) async {
    task.isDone = true;
    await taskCollection.editTask(userId, task);
    notifyListeners();
  }
  static TaskProvider getInstance(BuildContext context, {bool listen = true}) {
    return Provider.of<TaskProvider>(context, listen: listen);
  }
}
