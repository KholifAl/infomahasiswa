import 'package:flutter/material.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF5E79),
      body: Stack(
        children: [
          // Lingkaran besar di tengah atas (diperkecil)
          Positioned(
            bottom: -4,
            top: -4,
            left: -30,
            right: -30,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.1,
              height: MediaQuery.of(context).size.width * 1.1,
              decoration: BoxDecoration(
                color: Colors.pink[100]?.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Judul dan deskripsi di atas ilustrasi
          Positioned(
            top: 190, // atur sesuai kebutuhan
            left: 30,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'BelajarBareng.',
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Find your study buddy to start your\njourney here!',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          // Ilustrasi di bawah tulisan
          Positioned(
            top: 180, // atur sesuai kebutuhan agar di bawah tulisan
            bottom: -30,
            left: 150,
            right: 0,
            child: Center(
              child: Image.asset('lib/assets/landing2.png', height: 300),
            ),
          ),
          // Tombol Get Started di bawah
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
