import 'package:flutter/material.dart';
import 'package:to_do_project/App_date_utilts.dart';
import 'package:to_do_project/database/task_name.dart';

class EditTaskForm extends StatefulWidget {
  final Task task;
  final void Function(Task) onSave;

  EditTaskForm({required this.task, required this.onSave});

  @override
  _EditTaskFormState createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  late TextEditingController _titleController;
  late DateTime dates;
  late TimeOfDay times;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title ?? '');
    dates = widget.task.data is DateTime ? widget.task.data as DateTime : DateTime.now();
    times = widget.task.time is TimeOfDay ? widget.task.time as TimeOfDay : TimeOfDay.now();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dates,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dates) {
      setState(() {
        dates = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: times,
    );
    if (picked != null && picked != times) {
      setState(() {
        times = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Task Title'),
        ),
        TextButton(
          onPressed: _selectDate,
          child: Text('Pick Date: ${dates.toLocal().toString().split(' ')[0]}'),
        ),
        TextButton(
          onPressed: _selectTime,
          child: Text('Pick Time: ${times.format(context)}'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Task updatedTask = Task(
                  id: widget.task.id,
                  title: _titleController.text,
                  data: dates.dateOnly(),
                  time: times.timeSinceEpoch(),
                );
                widget.onSave(updatedTask);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
