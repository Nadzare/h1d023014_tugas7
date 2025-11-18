# Tugas 7 Pertemuan 9

## 📱 Aplikasi Todo List

**Nama**: Nadare Kafah Alfatiha  
**NIM**: H1D023014  
**Shift**: A >> F

---

## 📝 Deskripsi Aplikasi

Aplikasi Flutter modern dengan tema gradasi hijau yang mengimplementasikan **Routing**, **Sidemenu**, **Login System**, dan **Local Storage** menggunakan SharedPreferences. Aplikasi ini memungkinkan user untuk mengelola daftar tugas (to-do list) dengan fitur lengkap CRUD operations.

---

## ✨ Fitur Utama

### 🔐 **Login System**
- Form login dengan validasi (username: `admin`, password: `admin`)
- Penyimpanan kredensial ke local storage
- Tracking waktu login terakhir
- Dialog alert yang cantik untuk feedback

### 🏠 **Home Page**
- Tampilan sambutan personal dengan username
- Quick action buttons untuk akses cepat ke fitur
- Statistik dan informasi user
- Design modern dengan gradasi hijau

### ✅ **To-Do List (Fitur Utama)**
- **Tambah Tugas** dengan kategori (Pekerjaan, Pribadi, Belanja, Belajar)
- **Tandai Selesai** dengan checkbox interaktif
- **Hapus Tugas** dengan swipe gesture
- **Statistik Real-time**: Total tugas, selesai, tersisa
- **Persistent Storage**: Data tersimpan di local storage
- **Icon & Warna** berbeda untuk setiap kategori

### 👤 **Profile Page**
- Informasi user lengkap (username, email, role)
- Waktu login terakhir
- Fitur logout dengan konfirmasi
- Clear local storage saat logout

### ℹ️ **About Page**
- Informasi aplikasi
- Copyright footer
- Design konsisten dengan tema hijau

---

## 📂 Struktur Folder

```
lib/
├── main.dart           # Entry point aplikasi
├── login_page.dart     # Halaman login
├── home_page.dart      # Halaman utama/dashboard
├── todo_page.dart      # Halaman daftar tugas (CRUD)
├── profile_page.dart   # Halaman profil user
├── about_page.dart     # Halaman tentang aplikasi
└── sidemenu.dart       # Widget side menu/drawer
```

---

## 🔍 Penjelasan Kode Per File

### 1️⃣ **main.dart**

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Menu',
      home: LoginPage(),
    );
  }
}
```

**Penjelasan:**
- `main()` adalah entry point aplikasi Flutter
- `runApp()` menjalankan aplikasi dengan widget root `MyApp`
- `MaterialApp` adalah widget yang menyediakan material design
- `home: LoginPage()` menentukan halaman pertama yang ditampilkan

---

### 2️⃣ **login_page.dart**

#### **Import & State Management**
```dart
import 'package:flutter/material.dart';
import 'package:h1d023014_tugas7/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
```

**Penjelasan:**
- `StatefulWidget` digunakan karena halaman memiliki state yang berubah
- `TextEditingController` untuk mengontrol input text field
- Import `shared_preferences` untuk local storage

#### **Fungsi Simpan Username**
```dart
void _saveUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', _usernameController.text);
  prefs.setString('loginTime', DateTime.now().toString().substring(0, 19));
}
```

**Penjelasan:**
- `async` karena operasi I/O ke storage
- `SharedPreferences.getInstance()` mendapatkan instance storage
- `setString()` menyimpan data dengan key-value pair
- Menyimpan username dan waktu login

#### **Fungsi Input Form**
```dart
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
      ),
    ),
  );
}
```

**Penjelasan:**
- Widget reusable untuk text field
- `obscureText` untuk menyembunyikan password
- `decoration` untuk styling input field
- `prefixIcon` menampilkan icon sesuai tipe input
- `focusedBorder` styling saat input aktif

#### **Dialog Alert**
```dart
void _showDialog(String pesan, Widget alamat) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF00E676)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                pesan.contains('Berhasil') ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
            ),
            // ... title text
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (pesan.contains('Berhasil')) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => alamat),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
```

**Penjelasan:**
- `showDialog()` menampilkan popup dialog
- `AlertDialog` widget untuk dialog material design
- Icon berubah berdasarkan status (berhasil/gagal)
- `Navigator.pushReplacement()` pindah halaman tanpa back button
- Kondisional navigasi hanya jika login berhasil

#### **Validasi Login**
```dart
onPressed: () {
  if (_usernameController.text == 'admin' &&
      _passwordController.text == 'admin') {
    _saveUsername();
    _showDialog('Anda Berhasil Login', const HomePage());
  } else {
    _showDialog('Username dan Password Salah', const LoginPage());
  }
}
```

**Penjelasan:**
- Validasi username dan password
- Jika benar: simpan data dan pindah ke HomePage
- Jika salah: tampilkan error dialog

---

### 3️⃣ **home_page.dart**

#### **Load Username dari Storage**
```dart
void _loadUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  namauser = prefs.getString('username');
  setState(() {});
}

@override
void initState() {
  super.initState();
  _loadUsername();
}
```

**Penjelasan:**
- `initState()` dipanggil saat widget pertama kali dibuat
- `getString()` membaca data dari storage
- `setState()` memicu rebuild UI dengan data baru

#### **Quick Action Widget**
```dart
Widget _buildQuickAction(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
  Widget destination,
) {
  return Card(
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: // ... UI components
    ),
  );
}
```

**Penjelasan:**
- Widget reusable untuk tombol aksi cepat
- `InkWell` memberikan efek ripple saat di-tap
- `Navigator.push()` untuk navigasi ke halaman lain
- Dynamic routing dengan parameter `destination`

#### **Gradient Background**
```dart
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
  child: // ...
)
```

**Penjelasan:**
- `BoxDecoration` untuk styling container
- `LinearGradient` membuat efek gradasi warna
- `begin` dan `end` menentukan arah gradasi
- Array `colors` menentukan warna-warna gradasi

---

### 4️⃣ **todo_page.dart**

#### **State Management untuk To-Do**
```dart
class _TodoPageState extends State<TodoPage> {
  final TextEditingController _todoController = TextEditingController();
  List<Map<String, dynamic>> _todos = [];
  String _selectedCategory = 'Pekerjaan';
  final List<String> _categories = ['Pekerjaan', 'Pribadi', 'Belanja', 'Belajar'];
```

**Penjelasan:**
- `_todos` menyimpan list to-do dalam bentuk Map
- `_selectedCategory` menyimpan kategori yang dipilih
- `_categories` list kategori yang tersedia

#### **Load & Save Todos (JSON)**
```dart
void _loadTodos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? todosString = prefs.getString('todos');
  if (todosString != null) {
    setState(() {
      _todos = List<Map<String, dynamic>>.from(json.decode(todosString));
    });
  }
}

void _saveTodos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('todos', json.encode(_todos));
}
```

**Penjelasan:**
- `json.encode()` mengubah List/Map menjadi String JSON
- `json.decode()` mengubah String JSON kembali ke List/Map
- Local storage hanya bisa menyimpan String, maka perlu konversi
- `List<Map<String, dynamic>>.from()` untuk casting tipe data

#### **CRUD Operations**

**Create (Tambah):**
```dart
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
```

**Penjelasan:**
- Validasi input tidak kosong
- `add()` menambah item ke list
- Map berisi title, category, status, dan timestamp
- `clear()` mengosongkan text field
- Simpan ke storage dan tutup dialog

**Update (Toggle Complete):**
```dart
void _toggleTodo(int index) {
  setState(() {
    _todos[index]['completed'] = !_todos[index]['completed'];
    _saveTodos();
  });
}
```

**Penjelasan:**
- Toggle boolean dengan operator `!` (NOT)
- Update berdasarkan index
- Simpan perubahan ke storage

**Delete (Hapus):**
```dart
void _deleteTodo(int index) {
  setState(() {
    _todos.removeAt(index);
    _saveTodos();
  });
}
```

**Penjelasan:**
- `removeAt()` menghapus item pada index tertentu
- Simpan perubahan ke storage

#### **Dismissible Widget (Swipe to Delete)**
```dart
return Dismissible(
  key: Key(todo['timestamp']),
  background: Container(
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
    ),
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    child: const Icon(Icons.delete, color: Colors.white, size: 32),
  ),
  direction: DismissDirection.endToStart,
  onDismissed: (direction) {
    _deleteTodo(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Tugas dihapus')),
    );
  },
  child: // ... list item
);
```

**Penjelasan:**
- `Dismissible` widget untuk swipe gesture
- `key` harus unique untuk setiap item (gunakan timestamp)
- `background` ditampilkan saat di-swipe
- `direction` mengatur arah swipe (kanan ke kiri)
- `onDismissed` callback saat item berhasil di-swipe
- `SnackBar` untuk notifikasi

#### **Statistik Real-time**
```dart
int completedCount = _todos.where((todo) => todo['completed'] == true).length;
int totalCount = _todos.length;
```

**Penjelasan:**
- `where()` filter list berdasarkan kondisi
- Menghitung jumlah tugas yang selesai
- Display statistik di UI

#### **Dynamic Icon & Color**
```dart
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

Color _getCategoryColor(String category) {
  switch (category) {
    case 'Pekerjaan':
      return const Color(0xFF00C853);
    // ... cases lainnya
  }
}
```

**Penjelasan:**
- Fungsi helper untuk mendapatkan icon berdasarkan kategori
- Fungsi helper untuk mendapatkan warna berdasarkan kategori
- `switch-case` untuk multiple kondisi
- Membuat UI lebih dinamis dan menarik

---

### 5️⃣ **profile_page.dart**

#### **Load Data User**
```dart
void _loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    username = prefs.getString('username') ?? 'User';
    loginTime = prefs.getString('loginTime') ?? 'Tidak diketahui';
  });
}
```

**Penjelasan:**
- Membaca data username dan loginTime dari storage
- Operator `??` untuk default value jika data null
- `setState()` untuk update UI

#### **Logout Function**
```dart
void _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  if (mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
```

**Penjelasan:**
- `clear()` menghapus SEMUA data di SharedPreferences
- `mounted` check apakah widget masih aktif
- `pushAndRemoveUntil()` navigasi dan hapus semua route sebelumnya
- `(route) => false` menghapus semua route di stack
- User harus login ulang setelah logout

#### **Confirmation Dialog**
```dart
void _showLogoutDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
```

**Penjelasan:**
- Dialog konfirmasi sebelum logout
- Dua tombol: Batal dan Logout
- Pattern yang baik untuk action destruktif

---

### 6️⃣ **sidemenu.dart**

#### **Drawer dengan Gradient**
```dart
return Drawer(
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF00C853),
          Color(0xFF00E676),
          Color(0xFF69F0AE),
        ],
      ),
    ),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // DrawerHeader dan menu items
      ],
    ),
  ),
);
```

**Penjelasan:**
- `Drawer` widget untuk side menu
- Background dengan gradient hijau
- `ListView` untuk scroll jika menu banyak
- `padding: EdgeInsets.zero` menghilangkan default padding

#### **Custom Menu Item**
```dart
Widget _buildMenuItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFF00E676)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      title: Text(title, style: // ...),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    ),
  );
}
```

**Penjelasan:**
- Widget reusable untuk consistency
- `required` memastikan parameter wajib diisi
- `VoidCallback` tipe untuk function tanpa return
- Card style dengan shadow untuk depth effect
- Icon dengan gradient background
- Arrow indicator untuk visual feedback

#### **Navigation dengan pushReplacement**
```dart
onTap: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}
```

**Penjelasan:**
- `pushReplacement()` mengganti halaman saat ini
- Mencegah penumpukan route di navigation stack
- Lebih efisien untuk side menu navigation
- User tetap bisa buka drawer dari halaman baru

---

## 🛠️ Teknologi & Konsep

### **1. State Management**
- `StatefulWidget` untuk widget dengan state dinamis
- `StatelessWidget` untuk widget static
- `setState()` untuk trigger rebuild UI
- `initState()` untuk inisialisasi saat widget dibuat
- `dispose()` untuk cleanup resources

### **2. Navigation & Routing**
- `Navigator.push()` - Navigasi ke halaman baru
- `Navigator.pushReplacement()` - Ganti halaman tanpa back
- `Navigator.pushAndRemoveUntil()` - Clear navigation stack
- `Navigator.pop()` - Kembali ke halaman sebelumnya
- `MaterialPageRoute` untuk transition antar halaman

### **3. Local Storage (SharedPreferences)**
- Menyimpan data key-value secara persistent
- `setString()`, `getString()` untuk String
- `setBool()`, `getBool()` untuk Boolean
- `clear()` untuk hapus semua data
- Data tetap ada meskipun app ditutup

### **4. JSON Handling**
- `json.encode()` - Object → JSON String
- `json.decode()` - JSON String → Object
- Diperlukan untuk menyimpan complex data (List/Map)
- Import `dart:convert` untuk fungsi JSON

### **5. Async Programming**
- `async` keyword untuk asynchronous function
- `await` menunggu Future selesai
- Digunakan untuk I/O operations (storage, network)
- `Future<T>` tipe return untuk async operation

### **6. Widget Composition**
- `Container` untuk layout dan styling
- `Card` untuk card material design
- `ListTile` untuk list item
- `TextField` untuk input
- `ElevatedButton`, `TextButton` untuk actions
- `Icon` untuk icons
- `Text` untuk teks

### **7. Styling & Theming**
- `BoxDecoration` untuk container decoration
- `LinearGradient` untuk gradient effect
- `BorderRadius` untuk rounded corners
- `BoxShadow` untuk shadow effect
- `Color(0xFFRRGGBB)` untuk custom colors
- `withOpacity()` untuk transparency

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2  # Local Storage
```

**Cara Install:**
```bash
flutter pub get
```

---

## 🚀 Cara Menjalankan

1. **Clone/Download Project**

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Run Application**
```bash
flutter run
```

4. **Login dengan:**
   - Username: `admin`
   - Password: `admin`

---

## 📱 Flow Aplikasi

```
LoginPage (Autentikasi)
    ↓
HomePage (Dashboard)
    ├─→ TodoPage (Kelola Tugas)
    ├─→ ProfilePage (Info User & Logout)
    └─→ AboutPage (Info Aplikasi)
```

**Navigasi:**
- Side Menu (Drawer) → Akses semua halaman
- Quick Action Buttons → Akses cepat dari Home
- Back Button → Kembali ke halaman sebelumnya

---

## 💾 Data yang Disimpan di Local Storage

| Key | Tipe | Deskripsi |
|-----|------|-----------|
| `username` | String | Username yang login |
| `loginTime` | String | Waktu login terakhir |
| `todos` | String (JSON) | List semua to-do dalam format JSON |

**Contoh Data JSON Todos:**
```json
[
  {
    "title": "Belajar Flutter",
    "category": "Belajar",
    "completed": false,
    "timestamp": "2025-11-18 10:30:00"
  },
  {
    "title": "Meeting Client",
    "category": "Pekerjaan",
    "completed": true,
    "timestamp": "2025-11-18 09:15:00"
  }
]
```

---

## 🎨 Color Palette

```dart
Primary Green:   Color(0xFF00C853)  // #00C853
Secondary Green: Color(0xFF00E676)  // #00E676
Light Green:     Color(0xFF69F0AE)  // #69F0AE
Extra Light:     Color(0xFFB9F6CA)  // #B9F6CA
```

---

## 📝 Kesimpulan

Aplikasi ini berhasil mengimplementasikan:
- ✅ **Routing** - Navigasi antar 5 halaman dengan Navigator
- ✅ **Side Menu** - Drawer dengan 4 menu items dan styling modern
- ✅ **Login System** - Autentikasi dengan persistent session
- ✅ **Local Storage** - SharedPreferences untuk menyimpan data
- ✅ **CRUD Operations** - Create, Read, Update, Delete untuk to-do
- ✅ **JSON Handling** - Encode/decode complex data structures
- ✅ **State Management** - Dynamic UI dengan setState
- ✅ **Modern UI/UX** - Gradient, cards, animations, responsive

Aplikasi ini cocok sebagai pembelajaran Flutter untuk pemula hingga menengah, karena mencakup berbagai konsep penting dalam pengembangan mobile app.

---

Made with 💚 using Flutter

## ✨ Fitur Utama

### 🔐 **Login System**
- Form login dengan validasi (username: `admin`, password: `admin`)
- Penyimpanan kredensial ke local storage
- Tracking waktu login terakhir
- Dialog alert yang cantik untuk feedback

### 🏠 **Home Page**
- Tampilan sambutan personal dengan username
- Quick action buttons untuk akses cepat ke fitur
- Statistik dan informasi user
- Design modern dengan gradasi hijau

### ✅ **To-Do List (Fitur Utama)**
- **Tambah Tugas** dengan kategori (Pekerjaan, Pribadi, Belanja, Belajar)
- **Tandai Selesai** dengan checkbox interaktif
- **Hapus Tugas** dengan swipe gesture
- **Statistik Real-time**: Total tugas, selesai, tersisa
- **Persistent Storage**: Data tersimpan di local storage
- **Icon & Warna** berbeda untuk setiap kategori

### 👤 **Profile Page**
- Informasi user lengkap (username, email, role)
- Waktu login terakhir
- Fitur logout dengan konfirmasi
- Clear local storage saat logout

### ℹ️ **About Page**
- Informasi aplikasi
- Copyright footer
- Design konsisten dengan tema hijau

### 🎨 **Design Modern**
- **Gradasi Hijau** yang menarik dan konsisten
- **Card Design** dengan shadow dan rounded corners
- **Smooth Animations** dan transitions
- **Responsive Layout** untuk berbagai ukuran layar
- **Icon & Typography** yang modern

## 🛠️ Teknologi & Implementasi

### **1. Routing & Navigation**
```dart
Navigator.push() // Berpindah halaman
Navigator.pushReplacement() // Ganti halaman tanpa back
Navigator.pushAndRemoveUntil() // Clear navigation stack
```

### **2. Side Menu (Drawer)**
- Custom gradient background
- Menu items dengan card design
- Icon dalam gradient container
- Navigasi ke 4 halaman: Home, To-Do, Profile, About

### **3. Local Storage (SharedPreferences)**
```dart
// Simpan data
prefs.setString('username', value);
prefs.setString('todos', jsonEncode(list));

// Baca data
String? username = prefs.getString('username');
List todos = jsonDecode(prefs.getString('todos'));

// Hapus data
prefs.clear();
```

### **4. State Management**
- StatefulWidget untuk dynamic content
- setState() untuk update UI
- initState() untuk load data awal
- dispose() untuk cleanup

### **5. JSON Handling**
```dart
import 'dart:convert';

// Encode
json.encode(data) // Object → String

// Decode
json.decode(string) // String → Object
```

## 📦 Packages yang Digunakan

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2  # Local Storage
```

## 🚀 Cara Menjalankan

1. **Install Dependencies**
```bash
flutter pub get
```

2. **Run Application**
```bash
flutter run
```

3. **Login dengan:**
   - Username: `admin`
   - Password: `admin`

## 📱 Struktur Halaman

```
LoginPage
    ↓
HomePage ─┬─ TodoPage
          ├─ ProfilePage
          └─ AboutPage
```

## 🎯 Fitur Local Storage

### Data yang Disimpan:
- ✅ Username
- ✅ Waktu login
- ✅ Daftar to-do list (JSON)
- ✅ Status completed untuk setiap tugas
- ✅ Kategori tugas
- ✅ Timestamp pembuatan tugas

### Persistent Data:
Semua data tetap tersimpan meskipun aplikasi ditutup dan akan dimuat kembali saat dibuka.

## 🎨 Color Scheme

```dart
Primary Green: Color(0xFF00C853)    // Hijau tua
Secondary Green: Color(0xFF00E676)  // Hijau cerah
Light Green: Color(0xFF69F0AE)      // Hijau muda
Extra Light: Color(0xFFB9F6CA)      // Hijau sangat muda
```

## 📝 Cara Menggunakan

1. **Login** dengan kredensial admin
2. **Home** - Lihat dashboard dan quick actions
3. **To-Do** - Kelola daftar tugas:
   - Tap ➕ untuk tambah tugas baru
   - Pilih kategori tugas
   - Checkbox untuk tandai selesai
   - Swipe left untuk hapus
4. **Profile** - Lihat info user & logout
5. **About** - Info aplikasi

## 🌟 Highlight Implementasi

### ✅ **Routing**: 5 halaman dengan navigasi smooth
### ✅ **Sidemenu**: Custom drawer dengan 4 menu items
### ✅ **Login**: Autentikasi dengan persistent session
### ✅ **Local Storage**: Data tersimpan permanen
### ✅ **CRUD Operations**: Create, Read, Update, Delete untuk to-do
### ✅ **JSON Handling**: Encode/decode complex data
### ✅ **State Management**: Dynamic UI updates
### ✅ **Modern UI**: Gradient, cards, animations

## 👨‍💻 Developer

**H1D023014 - Tugas 7**  
Aplikasi Flutter dengan implementasi lengkap routing, sidemenu, login, dan local storage.

---

Made with 💚 using Flutter
