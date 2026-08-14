import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      ('Salomlashish', '6 so‘z', Icons.waving_hand_outlined, .78),
      ('Oila', '10 so‘z', Icons.family_restroom_outlined, .42),
      ('Raqamlar', '12 so‘z', Icons.pin_outlined, .25),
      ('Kundalik muloqot', '15 so‘z', Icons.chat_bubble_outline, .12),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Bugungi darslar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Har kuni oz-ozdan o‘rganing va amalda qo‘llang.', style: TextStyle(color: Colors.white60)),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [Color(0xFF13335D), Color(0xFF0D2140)]),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Haftalik progress', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 10),
            Text('65%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            SizedBox(height: 8),
            LinearProgressIndicator(value: .65, minHeight: 8),
          ]),
        ),
        const SizedBox(height: 18),
        ...lessons.map((l) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .04), borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                CircleAvatar(radius: 25, child: Icon(l.$3)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(l.$2, style: const TextStyle(color: Colors.white54)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: l.$4, minHeight: 5),
                ])),
                const SizedBox(width: 10),
                Text('${(l.$4 * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w700)),
              ]),
            )),
      ],
    );
  }
}
