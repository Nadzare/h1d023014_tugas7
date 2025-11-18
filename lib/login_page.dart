import 'package:flutter/material.dart';
import 'package:h1d023014_tugas7/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var namasuer;

  // Fungsi untuk menyimpan username ke local storage
  void _saveUsername() async {
    // Inisialisasi Shared Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Simpan Username ke local storage
    prefs.setString('username', _usernameController.text);
  }

  // Fungsi untuk menampilkan input form
  Widget _showInput(TextEditingController namacontroller, String placeholder, bool isPassword) {
    return TextField(
      controller: namacontroller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(
          isPassword ? Icons.lock_outline : Icons.person_outline,
          color: const Color(0xFF00C853),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog alert
  void _showDialog(String pesan, Widget alamat) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pesan),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => alamat,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00C853),
              Color(0xFF00E676),
              Color(0xFF69F0AE),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C853), Color(0xFF00E676)],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.account_circle,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C853),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Login to continue',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _showInput(_usernameController, 'Masukkan Username', false),
                      const SizedBox(height: 16),
                      _showInput(_passwordController, 'Masukkan Password', true),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (_usernameController.text == 'admin' &&
                                _passwordController.text == 'admin') {
                              // Simpan username
                              _saveUsername();
                              // Tampilkan alert berhasil
                              _showDialog('Anda Berhasil Login', const HomePage());
                            } else {
                              // Tampilkan alert gagal
                              _showDialog('Username dan Password Salah', const LoginPage());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
