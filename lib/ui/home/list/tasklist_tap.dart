import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_project/database/task_collection.dart';
import 'package:to_do_project/database/task_name.dart';
import 'package:to_do_project/providers/authproviders.dart';
import 'package:to_do_project/providers/task_provider.dart';
import 'package:to_do_project/ui/home/list/task_item.dart';
import 'package:to_do_project/ui/widgets/dialodgists.dart';
import 'package:to_do_project/ui/widgets/edit_task_form.dart';

class TaskListTap extends StatefulWidget {
  const TaskListTap({super.key});

  @override
  State<TaskListTap> createState() => _TaskListTapState();
}

class _TaskListTapState extends State<TaskListTap> {
  late AuthProviders authProvider;
  late TaskProvider taskProvider;
  DateTime selectedDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthProviders>(context);
    taskProvider = Provider.of<TaskProvider>(context);
  }

  Future<List<Task>> _fetchTasks() async {
    return await taskProvider.getAllTasks(authProvider.authUser?.uid ?? "", selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyDateTimeLine(
          initialDate: selectedDate,
          onDateChange: (clickedDate) {
            setState(() {
              selectedDate = clickedDate;
            });
          },
        ),
        Expanded(
          child: FutureBuilder<List<Task>>(
            future: _fetchTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong: ${snapshot.error}"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var tasksList = snapshot.data;
              if (tasksList == null || tasksList.isEmpty) {
                return const Center(child: Text("No tasks mwgoda"));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: tasksList[index],
                      onDeleteClick: deleteTask,
                      onTaskEditClick: editTask,
                    );
                  },
                  separatorBuilder: (_, __) => Container(height: 24),
                  itemCount: tasksList.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void deleteTask(Task task) async {
    showLoadingDialog(context, message: "Please wait");
    try {
      await taskProvider.removeTask(authProvider.authUser?.uid ?? "", task);
    } catch (e) {
      showMessageDialog(
        context,
        "${e.toString()}",
        posButtonTitle: "retry",
        posButtonAction: () => deleteTask(task),
      );
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {});
    }
  }
  void editTask(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (dialogContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: EditTaskForm(
                  task: task,
                  onSave: (updatedTask) async {
                    if (!mounted) return;

                    showLoadingDialog(context, message: "Updating...");

                    try {
                      await taskProvider.editTask(authProvider.authUser?.uid ?? "", updatedTask);
                    } catch (e) {
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                        showMessageDialog(
                          context,
                          "${e.toString()}",
                          posButtonTitle: "Retry",
                          posButtonAction: () {
                            editTask(updatedTask);
                          },
                        );
                      }
                    } finally {
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                        setState(() {});
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
