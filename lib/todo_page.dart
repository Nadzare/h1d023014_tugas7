import 'package:flutter/material.dart';
import 'package:h1d023014_tugas7/sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _todoController = TextEditingController();
  List<Map<String, dynamic>> _todos = [];
  String _selectedCategory = 'Pekerjaan';
  final List<String> _categories = ['Pekerjaan', 'Pribadi', 'Belanja', 'Belajar'];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // Load todos dari local storage
  void _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      setState(() {
        _todos = List<Map<String, dynamic>>.from(json.decode(todosString));
      });
    }
  }

  // Save todos ke local storage
  void _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', json.encode(_todos));
  }

  // Tambah todo baru
  void _addTodo() {
    if (_todoController.text.isNotEmpty) {
      setState(() {
        _todos.add({
          'title': _todoController.text,
          'category': _selectedCategory,
          'completed': false,
          'timestamp': DateTime.now().toString(),
        });
        _todoController.clear();
        _saveTodos();
      });
      Navigator.pop(context);
    }
  }

  // Toggle status completed
  void _toggleTodo(int index) {
    setState(() {
      _todos[index]['completed'] = !_todos[index]['completed'];
      _saveTodos();
    });
  }

  // Hapus todo
  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _saveTodos();
    });
  }

  // Dialog untuk tambah todo
  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Tambah Tugas Baru',
                style: TextStyle(
                  color: Color(0xFF00C853),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan tugas...',
                      prefixIcon: const Icon(Icons.edit, color: Color(0xFF00C853)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      prefixIcon: const Icon(Icons.category, color: Color(0xFF00C853)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _todoController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _addTodo,
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Icon berdasarkan kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Pekerjaan':
        return Icons.work;
      case 'Pribadi':
        return Icons.person;
      case 'Belanja':
        return Icons.shopping_cart;
      case 'Belajar':
        return Icons.school;
      default:
        return Icons.task;
    }
  }

  // Warna berdasarkan kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pekerjaan':
        return const Color(0xFF00C853);
      case 'Pribadi':
        return const Color(0xFF00E676);
      case 'Belanja':
        return const Color(0xFF69F0AE);
      case 'Belajar':
        return const Color(0xFFB9F6CA);
      default:
        return const Color(0xFF00C853);
    }
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = _todos.where((todo) => todo['completed'] == true).length;
    int totalCount = _todos.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00C853),
                Color(0xFF00E676),
              ],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF69F0AE),
              Color(0xFFB9F6CA),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Statistik Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total Tugas',
                        totalCount.toString(),
                        Icons.list_alt,
                        const Color(0xFF00C853),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      _buildStatItem(
                        'Selesai',
                        completedCount.toString(),
                        Icons.check_circle,
                        const Color(0xFF00E676),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      _buildStatItem(
                        'Tersisa',
                        (totalCount - completedCount).toString(),
                        Icons.pending,
                        const Color(0xFF69F0AE),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // List Todos
            Expanded(
              child: _todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 100,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada tugas',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap tombol + untuk menambah',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        return Dismissible(
                          key: Key(todo['timestamp']),
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteTodo(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Tugas dihapus'),
                                backgroundColor: const Color(0xFF00C853),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(todo['category'])
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getCategoryIcon(todo['category']),
                                  color: _getCategoryColor(todo['category']),
                                ),
                              ),
                              title: Text(
                                todo['title'],
                                style: TextStyle(
                                  decoration: todo['completed']
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontWeight: FontWeight.w600,
                                  color: todo['completed']
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                              subtitle: Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(todo['category'])
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  todo['category'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getCategoryColor(todo['category']),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              trailing: Checkbox(
                                value: todo['completed'],
                                activeColor: const Color(0xFF00C853),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) {
                                  _toggleTodo(index);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      drawer: const Sidemenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }
}
