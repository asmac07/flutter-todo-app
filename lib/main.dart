
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'categories_page.dart';

void main() {
  runApp(const TodoApp());
}

// Main app
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoHomePage(),
    );
  }
}

// To-do screen
class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  // Store task names
  final List<String> tasks = [];

  final List<bool> isCompleted = [];

  final List<String> taskCategories = [];

  // Controllers for Add and Search
  final TextEditingController taskController =
      TextEditingController();

  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';
  String selectedFilter = 'All';
  String selectedCategory = 'Study';
  String selectedTaskCategoryFilter = 'All';

  @override
    void initState() {
      super.initState();
      loadTasks();
    }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = prefs.getString('tasks');

    if (savedData != null) {
      final List<dynamic> decodedData = jsonDecode(savedData);

      setState(() {
        
for (final item in decodedData) {
  tasks.add(item['title'] as String);
  isCompleted.add(item['completed'] as bool);

  taskCategories.add(
    item['category'] as String? ?? 'Study',
  );
}

      });
    } else {
      // Sample tasks for the first launch only
      tasks.addAll([
        'Learn Dart',
        'Build Flutter UI',
        'Create To-do App',
      ]);

      isCompleted.addAll([false, false, false]);

      taskCategories.addAll(['Study', 'Study', 'Study']);
      await saveTasks();
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final data = List.generate(
      tasks.length,
      (index) => {
        'title': tasks[index],
        'completed': isCompleted[index],
        'category': taskCategories[index],

      },
    );

    await prefs.setString('tasks', jsonEncode(data));
  }


  // Edit a task
   void editTask(int index) {
      taskController.text = tasks[index];

      String editCategory = taskCategories[index];

      showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Edit Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter new task name',
                        labelText: 'Task Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: editCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Study', 'Work', 'Personal']
                          .map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            editCategory = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      taskController.clear();
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final updatedTask =
                          taskController.text.trim();

                      if (updatedTask.isNotEmpty) {
                        setState(() {
                          tasks[index] = updatedTask;
                          taskCategories[index] = editCategory;
                        });

                        saveTasks();
                        taskController.clear();
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

  // Add a new task
  void addTask() {
    final String newTask = taskController.text.trim();

    if (newTask.isEmpty) {
      return;
    }

    setState(() {
      tasks.add(newTask);
      isCompleted.add(false);
      taskCategories.add(selectedCategory);
      taskController.clear();
    });

    saveTasks();
  }

  @override
  void dispose() {
    taskController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Find tasks matching the search text
        
  final filteredTasks = tasks
    .asMap()
    .entries
    .where((entry) {
      final matchesSearch = entry.value
          .toLowerCase()
          .contains(searchText);

      final matchesFilter =
          selectedFilter == 'All' ||
          (selectedFilter == 'Active' &&
              !isCompleted[entry.key]) ||
          (selectedFilter == 'Completed' &&
              isCompleted[entry.key]);

      // NEW: Check the selected category
      final matchesCategory =
          selectedTaskCategoryFilter == 'All' ||
          taskCategories[entry.key] ==
              selectedTaskCategoryFilter;

      // Updated: All three conditions must match
      return matchesSearch &&
          matchesFilter &&
          matchesCategory;
    })
    .toList();

    return Scaffold(
      
        appBar: AppBar(
          title: const Text('My Tasks'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
           IconButton(
                icon: const Icon(Icons.category),
                tooltip: 'Categories',
                onPressed: () async {
                  final categoryFromPage = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesPage(),
                    ),
                  );

                  if (categoryFromPage != null) {
                    setState(() {
                      selectedTaskCategoryFilter = categoryFromPage;
                    });
                  }
                },
              ),
          ],
        ),


      body: Column(
        children: [
          // Task input and Add button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Study', 'Work', 'Personal']
                    .map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 12),


          // Search tasks
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase().trim();
                });
              },
            ),
          ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (final filter in ['All', 'Active', 'Completed'])
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontWeight: selectedFilter == filter
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),


          const SizedBox(height: 8),

          // Display filtered tasks
          
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.checklist,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No tasks found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try adding a task or changing your filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final taskIndex = filteredTasks[index].key;
                        final taskName = filteredTasks[index].value;

                        return ListTile(
                          leading: Checkbox(
                            value: isCompleted[taskIndex],
                            onChanged: (bool? value) {
                              setState(() {
                                isCompleted[taskIndex] = value ?? false;
                              });

                              saveTasks();
                            },
                          ),

                         
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  taskName,
                                  style: TextStyle(
                                    decoration: isCompleted[taskIndex]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  taskCategories[taskIndex],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),


                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  editTask(taskIndex);
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    tasks.removeAt(taskIndex);
                                    isCompleted.removeAt(taskIndex);
                                    taskCategories.removeAt(taskIndex);

                                  });

                                  saveTasks();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

        ],
      ),
    );
  }
}
