import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/about_screen.dart';

void main() {
  // Fungsi utama untuk menjalankan aplikasi
  runApp(const InfoMahasiswaApp());
}

class InfoMahasiswaApp extends StatelessWidget {
  const InfoMahasiswaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfoMahasiswa App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // menuju Layar utama aplikasi
      home: const HomeScreen(),
      // Daftar rute navigasi aplikasi
      routes: {
        '/profile':
            (context) =>
                const ProfileScreen(), // Rute ke layar Profil Mahasiswa
        '/courses':
            (context) =>
                const CoursesScreen(), // Rute ke layar Daftar Mata Kuliah
        '/about':
            (context) => const AboutScreen(), // Rute ke layar Tentang Aplikasi
      },
    );
  }
}
