import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:project_2/models/category.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/screens/add_task.dart';
import 'package:project_2/widgets/list_task.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({
    super.key,
    required this.category,
    required this.categories,
  });

  final Category category;
  final List<Category> categories;
  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  final todayDateFormatted = DateFormat('yMd').format(DateTime.now());
  List<Task> _tasks = [];
  int _doneTasks = 0;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    const url = 'http://todo-db.atwebpages.com/getTasks.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _tasks = data.map<Task>((taskJson) {
            String startTimeString = taskJson['db_startTime'] ?? '';
            List<String> timeParts = startTimeString.split(':');
            TimeOfDay startTime = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );

            bool isDone = taskJson['db_isDone'] == "1";

            return Task(
              id: int.parse(taskJson['db_id']),
              desc: taskJson['db_description'] ?? '',
              date: DateTime.parse(taskJson['db_date'] ?? ''),
              isImportant: taskJson['db_isImportant'] == "1",
              categoryId: int.tryParse(taskJson['db_categoryId'] ?? '0') ?? 0,
              startTime: startTime,
              isDone: isDone,
            );
          }).toList();

          _doneTasks = _tasks
              .where(
                (task) => task.isDone && task.categoryId == widget.category.cid,
              )
              .length;

          _tasks = _tasks
              .where((task) => task.categoryId == widget.category.cid)
              .toList();
        });
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Failed Load Tasks: $e');
    }
  }

  void taskStatus(value, int taskId) async {
    String url =
        'http://todo-db.atwebpages.com/doneTaskAction.php?taskId=$taskId&isDone=$value&categoryId=${widget.category.cid}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _doneTasks = data['doneCount'];
          });
        } else {
          print('Failed to update task status');
        }
      } else {
        print('Failed to update task status');
      }
    } catch (e) {
      print('Status Error: $e');
    }
    setState(() {
      loadTasks();
    });
  }

  void deleteTask(Task task) async {
    String url =
        'http://todo-db.atwebpages.com/deleteTaskAction.php?taskId=${task.id}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        ScaffoldMessenger(
          child: Scaffold(
            body: Text('${task.desc} Task was deleted.'),
          ),
        );
      }
    } catch (e) {
      print('Delete Task Error: $e');
    }
    setState(() {
      loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 150),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(100),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    "Date: $todayDateFormatted",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Category: ${widget.category.name}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$_doneTasks of ${_tasks.length} items done',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (ctx, index) {
            return ListTask(
              task: _tasks[index],
              deleteTask: () {
                deleteTask(_tasks[index]);
              },
              isDone: (value) {
                taskStatus(value, _tasks[index].id);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return AddTaskScreen(
                  categories: widget.categories,
                  specificCategory: widget.category,
                );
              },
            ),
          );
          setState(() {
            loadTasks();
          });
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
