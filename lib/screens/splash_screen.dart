import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEA004B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cut,
              size: 80,
              color: Colors.white,
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack)
                .then(delay: 200.ms)
                .shake(duration: 400.ms),
            const SizedBox(height: 20),
            const Text(
              'KuaförümBurada',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(
                begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
