import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_project/App_date_utilts.dart';
import 'package:to_do_project/database/task_name.dart';
import 'package:to_do_project/ui/widgets/dialodgists.dart';

typedef OnTaskDeleteClick = void Function(Task task);
typedef OnTaskEditClick = void Function(Task task);

class TaskItem extends StatelessWidget {
  final Task task;
  final OnTaskDeleteClick onDeleteClick;
  final OnTaskEditClick onTaskEditClick;

  TaskItem({
    required this.task,
    required this.onDeleteClick,
    required this.onTaskEditClick,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          // Delete action
          SlidableAction(
            onPressed: (buildContext) {
              showMessageDialog(context, "Are you sure you want to delete?",
                  posButtonTitle: "Yes", posButtonAction: () {
                    onDeleteClick(task);
                  });
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            label: "Delete",
          ),
          // Edit action
          SlidableAction(
            onPressed: (buildContext) {
              onTaskEditClick(task);
            },
            icon: Icons.edit,
            backgroundColor: Colors.lightBlue,
            label: "Edit",
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:  Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title ?? "",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.watch_later_outlined),
                        const SizedBox(width: 8),
                        Text(
                          task.data?.formatDate() ?? "No Date",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          task.time?.formatTime() ?? "No Time",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () async {
                  showMessageDialog(context, "Task marked as done.",
                      posButtonTitle: "OK", posButtonAction: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        task.isDone = true;
                        onDeleteClick(task);
                      });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
