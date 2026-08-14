import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Chat',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Foydalanuvchi qidirish...',
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  fillColor: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.forum_outlined, size: 64, color: Colors.white10),
                    SizedBox(height: 16),
                    Text(
                      'COMING SOON',
                      style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 4),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Imo-ishora orqali muloqot tizimi.',
                      style: TextStyle(color: Colors.white24, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
