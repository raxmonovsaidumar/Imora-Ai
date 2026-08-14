import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/animation_sequence.dart';
import '../services/gemini_service.dart';
import '../services/local_storage_service.dart';
import '../data/demo_animation_data.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  // Provided API key from user
  const apiKey = 'AQ.Ab8RN6Jm0uGWescpUY3tb7h8Lc9M5i0iFxEOo-ax70JLOX2j_Q';
  return GeminiService(apiKey);
});

final translationControllerProvider = StateNotifierProvider<TranslationController, AsyncValue<AnimationSequence?>>((ref) {
  return TranslationController(ref.watch(geminiServiceProvider), ref);
});

final historyProvider = StateProvider<List<String>>((ref) {
  return LocalStorageService.getStringList('search_history');
});

final translationStatusProvider = StateProvider<String>((ref) => '');

class TranslationController extends StateNotifier<AsyncValue<AnimationSequence?>> {
  final GeminiService _geminiService;
  final Ref _ref;

  TranslationController(this._geminiService, this._ref) : super(const AsyncValue.data(null));

  Future<void> translate(String text) async {
    if (text.isEmpty) return;

    // Update history
    final currentHistory = _ref.read(historyProvider);
    if (!currentHistory.contains(text)) {
      final newHistory = [text, ...currentHistory].take(10).toList();
      _ref.read(historyProvider.notifier).state = newHistory;
      await LocalStorageService.setStringList('search_history', newHistory);
    }

    state = const AsyncValue.loading();
    _ref.read(translationStatusProvider.notifier).state = 'Matn tahlil qilinmoqda...';

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _ref.read(translationStatusProvider.notifier).state = 'Gemini AI ga so\'rov yuborilmoqda...';

      // For debugging, we'll call Gemini even for demo words
      // if (DemoAnimationData.hasDemoFor(text)) { ... }

      print('DEBUG: Calling Gemini API for: $text');
      final result = await _geminiService.translateText(text);
      
      _ref.read(translationStatusProvider.notifier).state = 'Animatsiya ma\'lumotlari olinmoqda...';
      await Future.delayed(const Duration(milliseconds: 800));
      
      state = AsyncValue.data(result);
    } catch (e, stack) {
      _ref.read(translationStatusProvider.notifier).state = 'Xatolik yuz berdi, zaxira tizimi ishlamoqda...';
      await Future.delayed(const Duration(milliseconds: 1000));
      state = AsyncValue.data(DemoAnimationData.getFallback(text));
    } finally {
      _ref.read(translationStatusProvider.notifier).state = '';
    }
  }
}
