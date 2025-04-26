import 'package:flutter/material.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> filteredCourses = [];

  @override
  void initState() {
    super.initState();
    // Daftar mata kuliah
    courses = [
      {
        'name': 'Pemrograman Perangkat Mobile',
        'lecturer': 'Thesa Adi Saputra Yusri, M.Cs.',
        'sks': 3,
        'description': 'Belajar membuat aplikasi mobile.',
        'color': const Color(0xFF89B3D9),
        'icon': Icons.smartphone_rounded,
      },
      {
        'name': 'Basis Data untuk Statistika',
        'lecturer': 'Dr. Sri Andayani, S.Si., M.Kom.',
        'sks': 3,
        'description': 'Belajar tentang database.',
        'color': const Color(0xFF66BB6A),
        'icon': Icons.storage_rounded,
      },
      {
        'name': 'Jaringan Komputer',
        'lecturer': 'Rina Wijayanti, M.Sc.',
        'sks': 3,
        'description': 'Belajar tentang jaringan komputer.',
        'color': const Color(0xFFEF5350),
        'icon': Icons.wifi_rounded,
      },
      {
        'name': 'Kecerdasan Buatan',
        'lecturer': 'Thesa Adi Saputra Yusri, M.Cs.',
        'sks': 3,
        'description': 'Belajar tentang AI dan Machine Learning.',
        'color': const Color(0xFFAB47BC),
        'icon': Icons.psychology_rounded,
      },
      {
        'name': 'Desain Grafis',
        'lecturer': 'Fransisca Sherly Taju, S.Sn., M.Sn.',
        'sks': 3,
        'description': 'Belajar tentang desain menciptakan komunikasi visual.',
        'color': const Color(0xFFFFB74D),
        'icon': Icons.palette_rounded,
      },
    ];
    filteredCourses = List.from(courses);
  }

  // Fungsi untuk memfilter daftar mata kuliah berdasarkan pencarian
  void _filterCourses(String query) {
    final filtered = courses.where((course) {
      final name = (course['name'] as String).toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCourses = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        // AppBar dengan judul dan gaya khusus
        title: const Text(
          'Daftar Mata Kuliah',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF89B3D9),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          // Input pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterCourses,
                      decoration: InputDecoration(
                        hintText: 'Cari mata kuliah...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontFamily: 'SF Pro Display',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Informasi jumlah mata kuliah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredCourses.length} Mata Kuliah',
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                // Tombol filter
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sort_rounded,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Semua',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Daftar mata kuliah
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                return _buildCourseCard(context, filteredCourses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan kartu mata kuliah
  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    return Hero(
      tag: 'course-${course['name']}',
      child: GestureDetector(
        onTap: () {
          // Navigasi ke halaman detail mata kuliah
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                course: course.map(
                  (key, value) => MapEntry(key, value.toString()),
                ),
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header kartu dengan warna dan ikon mata kuliah
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: course['color'] as Color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    // Ikon mata kuliah
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        course['icon'] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Nama mata kuliah
                    Expanded(
                      child: Text(
                        course['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Jumlah SKS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${course['sks']} SKS',
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Detail mata kuliah
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama pengajar
                          Text(
                            'Pengajar: ${course['lecturer']}',
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Deskripsi singkat
                          Text(
                            course['description'] as String,
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Tombol navigasi ke detail
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF89B3D9),
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
