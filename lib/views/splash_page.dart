import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:river_pod/views/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // show splash

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    print('Splash: savedEmail = $savedEmail');

    final user = FirebaseAuth.instance.currentUser;
    print('Splash: firebase user = ${user?.email}');

    if (!mounted) return;

    if (savedEmail != null && savedEmail.isNotEmpty) {
      // email found in prefs -> go to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    if (user != null && (user.email?.isNotEmpty ?? false)) {
      // firebase user exists -> persist email and go to Home
      await prefs.setString('email', user.email!);
      print('Splash: saved email from firebase -> ${user.email}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    // else -> go to signup/login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Image.asset("assets/images/news.gif", fit: BoxFit.cover),
        ),
      ),
    );
  }
}
