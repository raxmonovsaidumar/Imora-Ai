import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/gesture.dart';
import '../services/ai_service.dart';
import '../widgets/animated_hand.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});
  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final controller = TextEditingController(text: 'Salom, yaxshimisiz?');
  final ai = AiService();
  SignAnimation? result;
  int step = 0;
  bool loading = false;

  Future<void> run() async {
    setState(() => loading = true);
    final r = await ai.textToSign(controller.text);
    if (!mounted) return;
    setState(() {
      result = r;
      step = 0;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = result == null || result!.animation.isEmpty
        ? 'IDLE'
        : result!.animation[step].gesture;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(colors: [Color(0xFF00D4FF), Color(0xFF6677FF)]),
              ),
              child: const Icon(Icons.sign_language, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('SignAI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text('AI-powered sign language', style: TextStyle(color: Colors.white60)),
              ]),
            ),
            const Icon(Icons.notifications_none),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: [Color(0xFF101B3D), Color(0xFF0F2748)]),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Text → Sign', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Matnni AI orqali imo-ishora animatsiyasiga aylantiring.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masalan: Salom, yaxshimisiz?',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: loading ? null : run,
                icon: loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.auto_awesome),
                label: Text(loading ? 'AI tahlil qilmoqda...' : 'AI bilan tarjima qilish'),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        Container(
          height: 360,
          decoration: BoxDecoration(
            color: const Color(0xFF07111F),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white10),
          ),
          child: Stack(children: [
            Positioned(top: 16, left: 18, child: _badge('3D AVATAR', Icons.view_in_ar)),
            Center(child: AnimatedHand(gesture: current, playing: result != null)),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Row(children: [
                Expanded(child: Text(current == 'IDLE' ? 'Imo-ishora kutilyapti' : current, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                if (result != null)
                  IconButton(
                    onPressed: () {
                      if (result == null || result!.animation.isEmpty) return;
                      setState(() => step = (step + 1) % result!.animation.length);
                    },
                    icon: const Icon(Icons.skip_next_rounded),
                  ),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        if (result != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .04), borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('AI JSON output', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              SelectableText(
                const JsonEncoder.withIndent('  ').convert({
                  'text': result!.text,
                  'language': result!.language,
                  'animation': result!.animation.map((e) => {'gesture': e.gesture, 'duration': e.durationMs}).toList(),
                }),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70),
              ),
            ]),
          ),
      ],
    );
  }

  Widget _badge(String text, IconData icon) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(30)),
        child: Row(children: [Icon(icon, size: 15), const SizedBox(width: 6), Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))]),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
