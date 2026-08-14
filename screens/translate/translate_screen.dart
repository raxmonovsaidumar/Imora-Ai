import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/translation_controller.dart';
import '../animation/animation_player_screen.dart';

class TranslateScreen extends ConsumerStatefulWidget {
  const TranslateScreen({super.key});

  @override
  ConsumerState<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends ConsumerState<TranslateScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onAnimate() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, so\'z yoki gap kiriting.')),
      );
      return;
    }

    await ref.read(translationControllerProvider.notifier).translate(text);
    
    final translationState = ref.read(translationControllerProvider);
    if (translationState.hasValue && translationState.value != null) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AnimationPlayerScreen(sequence: translationState.value!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationState = ref.watch(translationControllerProvider);
    final history = ref.watch(historyProvider);
    final statusMessage = ref.watch(translationStatusProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SignAI',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                    ),
                    Text(
                      'Text to Sign Language',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundColor: Colors.white10,
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 60),
            TextField(
              controller: _textController,
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'So\'z yoki gap kiriting...',
              ),
            ),
            const SizedBox(height: 24),
            translationState.maybeWhen(
              loading: () => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 24),
                      Text(
                        statusMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AI ishlov bermoqda...',
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              orElse: () => FilledButton(
                onPressed: _onAnimate,
                child: const Text(
                  'ANIMATSIYA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: 40),
              Text(
                'Tarix',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...history.map((text) => _buildHistoryCard(text)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: Text(
            text,
            style: const TextStyle(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.history_rounded, size: 14, color: Colors.white30),
          onTap: () {
            _textController.text = text;
          },
        ),
      ),
    );
  }
}
