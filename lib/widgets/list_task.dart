import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_2/models/task.dart';

class ListTask extends StatefulWidget {
  const ListTask({
    super.key,
    required this.task,
    required this.isDone,
    required this.deleteTask,
  });

  final Task task;
  final Function(bool) isDone;
  final Function() deleteTask;

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    // Initialize _isDone with the task's current state
    _isDone = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    int day = widget.task.date.day;
    int month = widget.task.date.month;
    final timeOfDay = DateTime(
      widget.task.date.year,
      widget.task.date.month,
      widget.task.date.day,
      widget.task.startTime.hour,
      widget.task.startTime.minute,
    );
    String formattedTime = DateFormat('HH:mm').format(timeOfDay);
    String date = '$day/$month at $formattedTime';

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.desc,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: _isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: const Color.fromARGB(255, 137, 137, 137),
                  decoration: _isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              if (widget.task.isImportant)
                Text(
                  'Important',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    decoration: _isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.deleteTask,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
          ),
          Checkbox(
            value: _isDone,
            onChanged: (value) {
              setState(() {
                _isDone = value ?? false;
                widget.isDone(_isDone);
              });
            },
            activeColor: Colors.greenAccent,
            checkColor: Colors.black,
            side: widget.task.isImportant && !_isDone
                ? const BorderSide(width: 2, color: Colors.red)
                : null,
          ),
        ],
      ),
    );
  }
}
