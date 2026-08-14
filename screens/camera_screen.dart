import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('AI kamera', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Imo-ishorani kamera orqali aniqlash — keyingi MVP bosqichi.', style: TextStyle(color: Colors.white60)),
        const SizedBox(height: 18),
        Container(
          height: 460,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(colors: [Color(0xFF101C31), Color(0xFF06101D)]),
            border: Border.all(color: Colors.white10),
          ),
          child: Stack(children: [
            const Center(child: Icon(Icons.camera_alt_rounded, size: 72, color: Colors.white38)),
            Positioned(
              top: 18,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(30)),
                child: const Row(children: [Icon(Icons.circle, size: 10), SizedBox(width: 7), Text('AI READY')]),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(18)),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Aniqlangan ishora', style: TextStyle(color: Colors.white60)),
                  SizedBox(height: 5),
                  Text('Salom', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.camera_front_outlined), label: const Text('Old kamera'))),
          const SizedBox(width: 12),
          Expanded(child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: const Text('Mashqni boshlash'))),
        ]),
      ],
    );
  }
}
