import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile_page.dart';
import 'quiz_page.dart';
import 'materi_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat_page.dart';
import 'dart:async';
import 'package:belajarbersama/utils.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const HomeLayout();
        }
        return const LoginPage();
      },
    );
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> nearbyUsers = [];
  Timer? _timer;
  Timer? _locationTimer;
  Map? userData;

  void _onNavTap(int index) {
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MateriPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const QuizPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      _updateLocationOnce();
      fetchNearbyUsers();
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        fetchNearbyUsers();
      });
      // Timer untuk update lokasi setiap 30 detik
      _locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _updateLocationOnce();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationTimer?.cancel();
    _removeUserLocation();
    super.dispose();
  }

  Future<void> _removeUserLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseDatabase.instance.ref('users/${user.uid}').update({
        'lat': null,
        'lng': null,
        'last_update': null,
      });
    }
  }

  Future<void> _updateLocationOnce() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await saveUserLocation(user.uid, userData?['name'] ?? 'User');
      } catch (e) {
        debugPrint('Gagal update lokasi: $e');
      }
    }
  }

  Future<void> fetchNearbyUsers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    Position pos = await Geolocator.getCurrentPosition();
    final snapshot = await FirebaseDatabase.instance.ref('users').get();
    final unreadSnapshot = await FirebaseDatabase.instance
        .ref('users/${user.uid}/unread_chats')
        .get();

    List<Map<String, dynamic>> result = [];
    for (final child in snapshot.children) {
      if (child.key == user.uid) continue;
      final data = child.value as Map;

      // --- Deklarasi di sini! ---
      bool hasChatted = false;

      // Filter hanya user online (last_update < 1 menit)
      final lastUpdate =
          DateTime.tryParse(data['last_update'] ?? '') ?? DateTime(2000);
      if (DateTime.now().difference(lastUpdate).inMinutes > 1 && !hasChatted)
        continue;

      double lat = data['lat'];
      double lng = data['lng'];
      double distance = calculateDistance(
        pos.latitude,
        pos.longitude,
        lat,
        lng,
      );
      bool hasNewChat = false;
      final chatId = _generateChatId(user.uid, child.key!);

      if (unreadSnapshot.exists && child.key != null) {
        final unreadData = Map<String, dynamic>.from(
          unreadSnapshot.value as Map,
        );
        hasNewChat = unreadData[chatId] == true;
      }

      // Cek apakah sudah pernah chat
      final chatSnapshot = await FirebaseDatabase.instance
          .ref('chats/$chatId')
          .get();
      if (chatSnapshot.exists) {
        // Cek apakah chat masih aktif (kurang dari 3 jam)
        final lastActivity =
            DateTime.tryParse(
              chatSnapshot.child('last_activity').value as String? ?? '',
            ) ??
            DateTime(2000);
        if (DateTime.now().difference(lastActivity).inHours < 3) {
          hasChatted = true;
        }
      }

      result.add({
        'name': data['name'],
        'distance': distance,
        'uid': child.key,
        'hasNewChat': hasNewChat,
        'hasChatted': hasChatted,
        'photoUrl': data['photoUrl'] ?? '', // tambahkan ini
      });
    }
    setState(() {
      nearbyUsers = result;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // km
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double distanceFactor = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * distanceFactor;
  }

  double _deg2rad(double deg) => deg * pi / 180;

  Future<void> saveUserLocation(String uid, String name) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    Position pos = await Geolocator.getCurrentPosition();
    await FirebaseDatabase.instance.ref('users/$uid').update({
      'name': name,
      'lat': pos.latitude,
      'lng': pos.longitude,
      'last_update': DateTime.now().toIso8601String(),
    });
  }

  String _generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseDatabase.instance
          .ref('users/${user.uid}')
          .get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.value as Map;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = userData?['name'] ?? 'User';
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFUIDisplay',
                          ),
                          children: [
                            const TextSpan(
                              text: 'Hello, ',
                              style: TextStyle(color: Color(0xFFFF5E79)),
                            ),
                            TextSpan(
                              text: '$displayName!',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight:
                                    FontWeight.bold, // Tambahkan bold di sini
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'What do you want to study today?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily:
                              'SFUIDisplay', // Tambahkan font family di sini
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            (userData?['photoUrl'] != null &&
                                userData?['photoUrl'] != '')
                            ? NetworkImage(
                                transformCloudinaryUrl(userData!['photoUrl']),
                              )
                            : null,
                        child:
                            (userData?['photoUrl'] == null ||
                                userData?['photoUrl'] == '')
                            ? const Icon(
                                Icons.person,
                                size: 25,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Learning Stats Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 230, 234),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learning Stats',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'SFUIDisplay',
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 60),
                                FlSpot(1, 70),
                                FlSpot(2, 80),
                                FlSpot(3, 90),
                                FlSpot(4, 85),
                              ],
                              isCurved: true,
                              barWidth: 4,
                              color: const Color(0xFFFF6B35),
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontFamily: 'SFUIDisplay',
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const labels = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'Mei',
                                  ];
                                  return Text(
                                    labels[value.toInt() % labels.length],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontFamily: 'SFUIDisplay',
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Course and Quiz Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MateriPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5E79),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Course',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SFUIDisplay',
                                  ),
                                ),
                                Text(
                                  'Free learning materials\nfor users',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'SFUIDisplay',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const QuizPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5E79),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.quiz, color: Colors.white, size: 24),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quiz',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SFUIDisplay',
                                  ),
                                ),
                                Text(
                                  'Test your acknowledge\nby taking quiz',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'SFUIDisplay',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // People Nearby Section
              const Text(
                'People Nearby',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SFUIDisplay',
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: nearbyUsers.isEmpty
                    ? const Center(
                        child: Text(
                          'There is no user nearby! :(',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF5E79),
                            fontFamily: 'SFUIDisplay',
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: nearbyUsers.length,
                        itemBuilder: (context, index) {
                          final user = nearbyUsers[index];
                          return GestureDetector(
                            onTap: () {
                              final currentUser =
                                  FirebaseAuth.instance.currentUser!;
                              final otherUserUid = user['uid'];
                              final chatId = _generateChatId(
                                currentUser.uid,
                                otherUserUid,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                    chatId: chatId,
                                    otherUserUid: otherUserUid,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            (user['photoUrl'] != null &&
                                                user['photoUrl'] != '')
                                            ? NetworkImage(
                                                transformCloudinaryUrl(
                                                  user['photoUrl'],
                                                ),
                                              )
                                            : null,
                                        child:
                                            (user['photoUrl'] == null ||
                                                user['photoUrl'] == '')
                                            ? const Icon(Icons.person, size: 30)
                                            : null,
                                      ),
                                      // Status indicator: oranye jika ada chat baru, hijau jika online
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: user['hasNewChat'] == true
                                                ? Colors.orange
                                                : Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'SFUIDisplay',
                                        ),
                                      ),
                                      Text(
                                        '${user['distance'].toStringAsFixed(2)} km',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: 'SFUIDisplay',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              Icons.home,
              'Home',
              selectedIndex == 0,
              () => _onNavTap(0),
            ),
            _buildNavItem(
              Icons.bookmark_border,
              'Course',
              selectedIndex == 1,
              () => _onNavTap(1),
            ),
            _buildNavItem(
              Icons.help_outline,
              'Quiz',
              selectedIndex == 2,
              () => _onNavTap(2),
            ),
            _buildNavItem(
              Icons.person_outline,
              'Profile',
              selectedIndex == 3,
              () => _onNavTap(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFFF5E79) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFFF5E79) : Colors.grey,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'SFUIDisplay',
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Container();

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('users/${user.uid}').onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return const CircleAvatar(child: Icon(Icons.person));
        }
        final data = snapshot.data!.snapshot.value as Map;
        final photoUrl = data['photoUrl'] ?? '';
        return CircleAvatar(
          radius: 22,
          backgroundImage: (photoUrl != null && photoUrl != '')
              ? NetworkImage(transformCloudinaryUrl(photoUrl))
              : null,
          child: (photoUrl == null || photoUrl == '')
              ? const Icon(Icons.person, size: 22)
              : null,
        );
      },
    );
  }
}
