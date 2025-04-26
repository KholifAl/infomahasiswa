import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // AppBar dengan judul dan gaya khusus
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'SF Pro Display',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF89B3D9),
        elevation: 0,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Logo aplikasi
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB0CDEB).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFB0CDEB), Color(0xFF89B3D9)],
                      ),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Judul aplikasi
              RichText(
                text: const TextSpan(
                  text: 'INFO',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'MAHASISWA',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89B3D9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Versi aplikasi
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F7FC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 12,
                    color: Color(0xFF89B3D9),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Kartu deskripsi aplikasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Ikon informasi
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F7FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.info_rounded,
                        color: Color(0xFF89B3D9),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Deskripsi aplikasi
                    const Text(
                      'InfoMahasiswa App adalah aplikasi sederhana untuk menampilkan informasi mahasiswa, daftar mata kuliah, dan detailnya.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontFamily: 'SF Pro Display',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Kartu fitur aplikasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Judul fitur
                    const Text(
                      'Fitur Aplikasi',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Fitur: Profil Mahasiswa
                    _buildFeatureItem(
                      Icons.person_rounded,
                      'Profil Mahasiswa',
                      'Lihat informasi lengkap mahasiswa',
                    ),
                    const SizedBox(height: 16),
                    // Fitur: Daftar Mata Kuliah
                    _buildFeatureItem(
                      Icons.menu_book_rounded,
                      'Daftar Mata Kuliah',
                      'Akses semua mata kuliah yang tersedia',
                    ),
                    const SizedBox(height: 16),
                    // Fitur: Detail Mata Kuliah
                    _buildFeatureItem(
                      Icons.description_rounded,
                      'Detail Mata Kuliah',
                      'Lihat informasi lengkap setiap mata kuliah',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Kartu pengembang
              _buildDevelopersCard(),
              const SizedBox(height: 24),
              // Hak cipta
              const Text(
                '© 2025 InfoMahasiswa App. All rights reserved.',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // fitur fitur aplikasi
  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        // Ikon fitur
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7FC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF89B3D9), size: 20),
        ),
        const SizedBox(width: 16),
        // Deskripsi fitur
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build social button
  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  // Build developers card
  Widget _buildDevelopersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Judul pengembang
          const Text(
            'Pengembang',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Pengembang 1
          _buildDeveloperItem(
            name: 'Kholif Al Hamdhany',
            role: 'Back End Developer',
          ),
          const SizedBox(height: 24),
          // Pengembang 2
          _buildDeveloperItem(
            name: 'Fatikha Aura Nirwana',
            role: 'Front End Developer',
          ),
        ],
      ),
    );
  }

  // Build single developer item
  Widget _buildDeveloperItem({required String name, required String role}) {
    return Column(
      children: [
        // Avatar pengembang
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7FC),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFB0CDEB), width: 2),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Color(0xFF89B3D9),
            size: 40,
          ),
        ),
        const SizedBox(height: 12),
        // Nama pengembang
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        // Peran pengembang
        Text(
          role,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        // Tombol sosial media
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(Icons.language_rounded, Colors.blue),
            const SizedBox(width: 16),
            _buildSocialButton(Icons.email_rounded, Colors.red),
            const SizedBox(width: 16),
            _buildSocialButton(Icons.smartphone_rounded, Colors.green),
          ],
        ),
      ],
    );
  }
}
