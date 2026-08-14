import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/words_controller.dart';
import '../../widgets/safe_model_viewer.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  final String categoryTitle;
  final bool isFromWords;

  const LessonDetailScreen({
    super.key,
    required this.categoryTitle,
    this.isFromWords = false,
  });

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  int currentIndex = 0;
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    // If coming from words, use wordsProvider, otherwise use lessonsProvider
    // For now, we only have word-based detail logic
    final categories = ref.watch(wordsProvider);
    final category = categories.firstWhere((c) => c.title == widget.categoryTitle);
    final currentWord = category.words[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${currentIndex + 1}/${category.words.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${((currentIndex + 1) / category.words.length * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / category.words.length,
              backgroundColor: Colors.white10,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              minHeight: 4,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // 3D GLB Model (Safe View)
                  SizedBox(
                    height: 350,
                    child: SafeModelViewer(
                      src: 'assets/models/model.glb',
                      alt: "3D Avatar",
                      cameraTarget: "0m 1.3m 0m",
                      cameraOrbit: "0deg 75deg 1.2m",
                      fieldOfView: "30deg",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentWord,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                // Oldingi tugmasi (Ikonkali)
                IconButton.outlined(
                  onPressed: currentIndex > 0
                      ? () => setState(() => currentIndex--)
                      : null,
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                // Yodlandi tugmasi (Asosiy, ixchamroq)
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final newLearnedCount = currentIndex + 1;
                      if (newLearnedCount > category.learnedWords) {
                        ref.read(wordsProvider.notifier).updateProgress(category.title, newLearnedCount);
                      }
                      
                      if (currentIndex < category.words.length - 1) {
                        setState(() => currentIndex++);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tabriklaymiz! Barcha so\'zlarni yakunladingiz.'),
                            backgroundColor: Colors.white12,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: (currentIndex + 1 <= category.learnedWords)
                          ? Colors.green
                          : Colors.white,
                      foregroundColor: (currentIndex + 1 <= category.learnedWords)
                          ? Colors.white
                          : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      (currentIndex + 1 <= category.learnedWords) ? 'YODLANGAN' : 'YODLANDI',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Keyingi tugmasi (Ikonkali)
                IconButton.outlined(
                  onPressed: currentIndex < category.words.length - 1
                      ? () => setState(() => currentIndex++)
                      : null,
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
