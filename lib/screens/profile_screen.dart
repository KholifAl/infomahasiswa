import 'package:flutter/material.dart';

// Kelas ProfileScreen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Judul di bagian atas layar
        title: const Text(
          'Profil Mahasiswa',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF89B3D9),
        centerTitle: true,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          // Memberikan jarak antarkonten
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Mengatur elemen dalam kolom secara vertikal
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile image with animation
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFB0CDEB), Color(0xFF89B3D9)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB0CDEB).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profil.jpg', // Lokasi gambar profil
                        width: 150, // Lebar gambar
                        height: 150, // Tinggi gambar
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF89B3D9),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // Information Section
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
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Mahasiswa',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89B3D9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Menampilkan nama mahasiswa
                    _buildInfoRow(
                      Icons.person_rounded,
                      'Nama',
                      'Kholif Al Hamdhany',
                    ),
                    const SizedBox(height: 16), // memberi jarak
                    // Menampilkan NIM mahasiswa
                    _buildInfoRow(
                      Icons.credit_card_rounded,
                      'NIM',
                      '21301244016',
                    ),
                    const SizedBox(height: 16), // memberi jarak
                    // Menampilkan program studi mahasiswa
                    _buildInfoRow(
                      Icons.school_rounded,
                      'Program Studi',
                      'Pendidikan Matematika',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Additional cards
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
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Akademik',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89B3D9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Academic info
                    _buildInfoRow(
                      Icons.calendar_today_rounded,
                      'Angkatan',
                      '2021',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.auto_graph_rounded, 'IPK', '4.00'),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.hourglass_bottom_rounded,
                      'Status',
                      'Aktif',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Social media links - just for UI enhancement
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                children: [
                  _buildSocialButton(Icons.email_rounded, Colors.redAccent),
                  _buildSocialButton(Icons.phone_rounded, Colors.green),
                  _buildSocialButton(Icons.location_on_rounded, Colors.blue),
                  _buildSocialButton(Icons.message_rounded, Colors.deepPurple),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7FC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF89B3D9), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
