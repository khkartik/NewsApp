// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/services/google_sign_function.dart';
import 'package:river_pod/views/home_page.dart';
import 'package:river_pod/providers/providers.dart';
import 'package:river_pod/views/widgets/snackbar_widget.dart';
import 'package:river_pod/views/widgets/textwiget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.red),
              const SizedBox(height: 40),

              TextWidget(
                hintText: "Enter name",
                icon: Icons.people,
                provider: nameProvider,
              ),
              const SizedBox(height: 20),

              TextWidget(
                hintText: "Enter email",
                icon: Icons.email,
                provider: emailProvider,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final name = ref.read(nameProvider);
                    final email = ref.read(emailProvider);
                    final uid = ref.read(uidProvider);

                    final result = await ref.read(
                      addAccountProvider({
                        "name": name,
                        "email": email,
                        "uid": uid,
                      }).future,
                    );

                    if (result != null) {
                      ref.read(nameProvider.notifier).state = result.name;
                      ref.read(emailProvider.notifier).state = result.email;
                      ref.read(currentAccountProvider.notifier).state = result;

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('email', result.email);

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );

                      successMessage(context, "Sign in Successfully");
                    } else {
                      errorMessage(context, "Error in Sign in");
                    }
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "or",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () async {
                  final success =
                      await ref.read(googleSignInHandler).signInWithGoogle();
                  if (success) {
                    // ✅ Save Google email as well
                    final prefs = await SharedPreferences.getInstance();
                    final googleEmail = ref.read(emailProvider);
                    if (googleEmail.isNotEmpty) {
                      await prefs.setString('email', googleEmail);
                    }

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                    successMessage(context, "Sign in Successfully");
                  } else {
                    errorMessage(context, "Error in Sign in");
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 12),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
