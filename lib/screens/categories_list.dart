import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project_2/models/category.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/screens/add_category.dart';
import 'package:project_2/screens/tasks_list.dart';
import 'package:project_2/widgets/list_category.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<Task> tasks = [];
  List<Category> availableCategories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadTasks();
  }

  // Get Task Count
  int getTaskCountByCategory(int cid) {
    int taskCount = 0;
    for (final task in tasks) {
      if (task.categoryId == cid) {
        taskCount++;
      }
    }
    return taskCount;
  }

  // Navigate to a specific screen
  void navigateToItemsScreen(Category category) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return TasksListScreen(
            category: category,
            categories: availableCategories,
          );
        },
      ),
    );
    setState(() {
      loadCategories();
      loadTasks();
    });
  }

  void addCategorySheet() async {
    await showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return const AddCategory();
        });
    setState(() {
      loadCategories();
    });
  }

  void loadCategories() async {
    // const url = 'http://to-do-db.infy.uk/getCategories.php';
    const url = 'http://todo-db.atwebpages.com/getCategories.php';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          availableCategories = data.map<Category>((category) {
            return Category(
              cid: int.parse(category['db_cid']),
              name: category['db_name'].toString(),
              color: category['db_color'].toString(),
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Exception : $e');
    }
  }

  void loadTasks() async {
    const url = 'http://todo-db.atwebpages.com/getTasks.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tasks = data.map<Task>((task) {
            String startTimeString = task['db_startTime'] ?? '';
            List<String> timeParts = startTimeString.split(':');
            TimeOfDay startTime = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );

            bool isDone = task['db_isDone'] == "1";
            return Task(
              id: int.parse(task['db_id']),
              desc: task['db_description'] ?? '',
              date: DateTime.parse(task['db_date'] ?? ''),
              isImportant: task['db_isImportant'] == "1",
              categoryId: int.tryParse(task['db_categoryId'] ?? '0') ?? 0,
              startTime: startTime,
              isDone: isDone,
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Exception : $e');
    }
  }

  void deleteCategory(dismissed, Category category) async {
    String url =
        'http://todo-db.atwebpages.com/deleteCategoryAction.php?cid=${category.cid}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        ScaffoldMessenger(
          child: Scaffold(
            body: Text('${category.name} Category was deleted.'),
          ),
        );
      }
    } catch (e) {
      print('Delete Category Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Lists'),
        leading: const Icon(Icons.checklist_rounded),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '${availableCategories.length} categories',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              for (var category in availableCategories)
                Dismissible(
                  key: Key(category.cid.toString()),
                  onDismissed: (dismissed) {
                    deleteCategory(dismissed, category);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        navigateToItemsScreen(category);
                      },
                      child: ListCategory(
                        title: category.name,
                        itemsCount: getTaskCountByCategory(category.cid),
                        color: Category.hexToColor(category.color),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCategorySheet,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
