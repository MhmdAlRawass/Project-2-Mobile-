import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:project_2/models/category.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
    required this.categories,
    required this.specificCategory,
  });

  final List<Category> categories;
  final Category specificCategory;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _enteredDesc = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool isImportant = false;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.specificCategory;
  }

  void _selectDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: now,
        lastDate: now.add(
          const Duration(days: 30),
        ),
        currentDate: now,
        initialDate: _selectedDate ?? now,
        barrierColor: Colors.black54,
        builder: (ctx, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                ),
              ),
              child: child!);
        });
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime() async {
    final currentTime = TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? currentTime,
      barrierColor: Colors.black54,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void addTask() async {
    if (_enteredDesc.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedCategory == null) {
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    String formattedTime = _selectedTime != null
        ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
        : '00:00';

    Map<String, dynamic> taskData = {
      'desc': _enteredDesc.text,
      'date': formattedDate,
      'startTime': formattedTime,
      'isImportant': isImportant ? 1 : 0,
      'categoryId': _selectedCategory == null
          ? widget.specificCategory.cid
          : _selectedCategory!.cid,
    };

    const url = 'http://todo-db.atwebpages.com/addTaskAction.php';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(taskData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${_enteredDesc.text}" added successfully!'),
          ),
        );
        Navigator.of(context).pop();
      } else {
        print(responseData['message']);
      }
    } else {
      print('Failed to add task');
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedDateFormatted =
        DateFormat('yMd').format(_selectedDate ?? DateTime.now());
    String selectedTimeFormatted = _selectedTime == null
        ? 'Select Date'
        : DateFormat.Hm().format(
            DateTime(0, 0, 0, _selectedTime!.hour, _selectedTime!.minute),
          );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).size.height * 0.2),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(150),
              bottomLeft: Radius.circular(150),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Description can't be empty!";
                    }
                    return '';
                  },
                  controller: _enteredDesc,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Add a description',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Category>(
                    value: _selectedCategory,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    hint: Text(
                      'Select Category',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onChanged: (Category? value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    dropdownColor: Theme.of(context).colorScheme.secondary,
                    items: widget.categories
                        .map<DropdownMenuItem<Category>>((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Category.hexToColor(category.color),
                                borderRadius: BorderRadius.circular(36),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    _selectDate();
                  },
                  child: Row(
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : selectedDateFormatted,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    _selectTime();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTimeFormatted,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.timer_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Important?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Switch(
                      value: isImportant,
                      onChanged: (bool value) {
                        setState(() {
                          isImportant = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: addTask,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
