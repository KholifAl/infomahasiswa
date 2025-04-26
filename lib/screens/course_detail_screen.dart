import 'package:flutter/material.dart';

// Kelas CourseDetailScreen
class CourseDetailScreen extends StatelessWidget {
  // Map digunakan untuk menyimpan data mata kuliah yang diterima sebelumnya
  final Map<String, String> course;

  // dari map ke Konstruktor untuk menerima data mata kuliah
  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  // Mendapatkan based on course name for consistency
  Color _getCourseColor() {
    switch (course['name']) {
      case 'Pemrograman Mobile':
        return const Color(0xFF89B3D9);
      case 'Basis Data untuk Statistika':
        return const Color(0xFF66BB6A);
      case 'Jaringan Komputer':
        return const Color(0xFFEF5350);
      case 'Kecerdasan Buatan':
        return const Color(0xFFAB47BC);
      case 'Desain Grafis':
        return const Color(0xFFFFB74D);
      default:
        return const Color(0xFF89B3D9);
    }
  }

  // GPengaturan icon based on course name for consistency
  IconData _getCourseIcon() {
    switch (course['name']) {
      case 'Perangkat Pemrograman Mobile':
        return Icons.smartphone_rounded;
      case 'Basis Data':
        return Icons.storage_rounded;
      case 'Jaringan Komputer':
        return Icons.wifi_rounded;
      case 'Kecerdasan Buatan':
        return Icons.psychology_rounded;
      case 'Desain Grafis':
        return Icons.palette_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color courseColor = _getCourseColor();
    final IconData courseIcon = _getCourseIcon();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Hero(
        tag: 'course-${course['name']}',
        flightShuttleBuilder: (
          flightContext,
          animation,
          direction,
          fromContext,
          toContext,
        ) {
          return Material(color: Colors.transparent, child: toContext.widget);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom app bar with course color
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: false,
              backgroundColor: courseColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 50),
                title: Text(
                  course['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [courseColor.withOpacity(0.8), courseColor],
                        ),
                      ),
                    ),
                    // Course icon watermark
                    Positioned(
                      right: -30,
                      top: 20,
                      child: Icon(
                        courseIcon,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    // Bottom decoration
                    const Positioned(
                      bottom: -1,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        child: SizedBox(
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Course details in the header
                    Positioned(
                      bottom: 90,
                      left: 16,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              courseIcon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${course['sks']} SKS',
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro Display',
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                course['lecturer']!,
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            SliverToBoxAdapter(
              child: Padding(
                // Memberikan jarak disekitar
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // Mengatur elemen secara vertikal
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course overview card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: courseColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Informasi Mata Kuliah',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Menampilkan nama mata kuliah
                          _buildInfoItem(
                            'Nama Mata Kuliah:',
                            course['name']!,
                            courseColor,
                          ),
                          const SizedBox(height: 12), // memberikan jarak
                          // Menampilkan nama dosen pengampu
                          _buildInfoItem(
                            'Dosen Pengampu:',
                            course['lecturer']!,
                            courseColor,
                          ),
                          const SizedBox(height: 12), // memberikan jarak
                          // Menampilkan jumlah SKS mata kuliah
                          _buildInfoItem(
                            'Jumlah SKS:',
                            course['sks']!,
                            courseColor,
                          ),
                          const SizedBox(height: 12), // memberikan jarak
                          // Menampilkan keterangan mata kuliah
                          _buildInfoItem(
                            'Keterangan:',
                            course['description']!,
                            courseColor,
                            isDescription: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Schedule section
                    _buildMaterialsSection(courseColor),

                    const SizedBox(height: 24),

                    // Key dates section
                    _buildScheduleSection(courseColor),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'Daftar',
                            Icons.add_rounded,
                            courseColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            'Unduh Materi',
                            Icons.download_rounded,
                            Colors.grey.shade700,
                            outlined: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    Color color, {
    bool isDescription = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: isDescription ? FontWeight.normal : FontWeight.w500,
            color: isDescription ? Colors.grey.shade800 : Colors.black,
            height: isDescription ? 1.5 : 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialsSection(Color courseColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book_rounded, color: courseColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Materi Pembelajaran',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMaterialItem(
            'Modul 1 - Pengenalan',
            'PDF - 2.4 MB',
            courseColor,
          ),
          _buildMaterialItem(
            'Modul 2 - Dasar Teori',
            'PDF - 3.1 MB',
            courseColor,
          ),
          _buildMaterialItem(
            'Modul 3 - Praktikum',
            'PDF - 1.8 MB',
            courseColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(String title, String info, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.insert_drive_file_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  info,
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.download_rounded, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(Color courseColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: courseColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Jadwal Perkuliahan',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildScheduleItem(
            'Senin',
            '08:00 - 10:30',
            'Ruang Lab 3.2',
            courseColor,
          ),
          _buildScheduleItem(
            'Rabu',
            '13:00 - 14:40',
            'Ruang Kelas 2.1',
            courseColor,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String day, String time, String room, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                day.substring(0, 2),
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                room,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color, {
    bool outlined = false,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: outlined ? Colors.white : color,
        foregroundColor: outlined ? color : Colors.white,
        elevation: outlined ? 0 : 2,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: outlined ? BorderSide(color: color) : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
