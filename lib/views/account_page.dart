import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/providers/providers.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentAccountProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Account Detail", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child:
            currentUser == null
                ? const Text("❌ No user logged in")
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "👤 ${currentUser.name}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "📧 ${currentUser.email}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
      ),
    );
  }
}
