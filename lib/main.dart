import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskManager(),
    );
  }
}

class TaskManager extends StatefulWidget {
  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  // Function to add a new task
  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
    });
    _taskController.clear();
  }

  // Function to edit an existing task
  void _editTask(int index, String updatedTask) {
    setState(() {
      _tasks[index] = updatedTask;
    });
    _taskController.clear();
  }

  // Function to remove a task
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Display a dialog for adding or editing tasks
  Future<void> _showTaskDialog({int? index}) async {
    if (index != null) {
      _taskController.text = _tasks[index];
    } else {
      _taskController.clear();
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Add Task' : 'Edit Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(hintText: 'Enter task'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  if (index == null) {
                    _addTask(_taskController.text);
                  } else {
                    _editTask(index, _taskController.text);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(index == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.task_alt, color: Colors.white, size: 28), // Custom icon
            SizedBox(width: 8),
            Text(
              'Task Manager',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                _tasks[index],
                style: TextStyle(fontSize: 18),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => _showTaskDialog(index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _removeTask(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
