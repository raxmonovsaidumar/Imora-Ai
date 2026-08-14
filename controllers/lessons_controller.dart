import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

class LessonItem {
  final String id;
  final String title;
  final String description;
  final int totalSteps;
  final int completedSteps;

  LessonItem({
    required this.id,
    required this.title,
    required this.description,
    required this.totalSteps,
    required this.completedSteps,
  });

  double get progress => completedSteps / totalSteps;
  int get percentage => (progress * 100).round();
}

final lessonsProvider = StateNotifierProvider<LessonsController, List<LessonItem>>((ref) {
  return LessonsController();
});

class LessonsController extends StateNotifier<List<LessonItem>> {
  LessonsController() : super([]) {
    _loadLessons();
  }

  void _loadLessons() {
    final lessonTitles = [
      'Imo-ishora tiliga kirish',
      'Imo-ishoraning 5 asosiy parametri',
      'Qo‘l shakllari',
      'Qo‘l yo‘nalishi va orientatsiyasi',
      'Ishoraning joylashuv nuqtasi',
      'Harakat turlari',
      'Ikki qo‘l qoidalari',
      'Barmoqlar va finger configuration',
      'Mimika va non-manual belgilar',
      'Ko‘z, bosh va tana harakati',
      'Daktil alifbo',
      'So‘z yasash va ishora qurilishi',
      'Oddiy otlar',
      'Ko‘plik',
      'Son va miqdor',
      'Olmoshlar',
      'Egalik',
      'Ko‘rsatish va makondagi referenslar',
      'Fe’llar',
      'Fe’l yo‘nalishi',
      'Vaqt',
      'Harakatning davomiyligi/aspekti',
      'Inkorga oid qoidalar',
      'Tasdiq',
      'Savol gaplar',
      'Ha/yo‘q savollari',
      'Kim/nima/qayer kabi savollar',
      'Buyruq va iltimos',
      'Modal ma’no',
      'Sifatlar',
      'Ravishlar',
      'So‘z tartibi',
      'Topic–Comment',
      'Sodda gaplar',
      'Qo‘shma gaplar',
      'Bog‘langan gaplar',
      'Shart gaplar',
      'Sabab va oqibat',
      'Vaqt munosabatlari',
      'Taqqoslash',
      'Daraja va kuchaytirish',
      'Klassifikatorlar',
      'Makondan foydalanish',
      'Role Shift',
      'Simultaneity',
      'Ellipsis va kontekst',
      'Dialog qoidalari',
      'Nutq madaniyati va etiketi',
      'Rasmiy va norasmiy muloqot',
      'Tarjima qoidalari',
      'O‘zbekcha matndan UzSLga o‘tkazish',
      'UzSLdan o‘zbekchaga o‘tkazish',
      'Kontekst',
      'Ko‘p ma’noli ishoralar',
      'Sinonimlar',
      'Muloqotdagi xatolar',
      'Mashqlar',
      'Yakuniy grammatika testi',
    ];

    state = List.generate(lessonTitles.length, (index) {
      final title = lessonTitles[index];
      final id = 'lesson_${index + 1}';
      return LessonItem(
        id: id,
        title: '${(index + 1).toString().padLeft(2, '0')}. $title',
        description: 'Uzbek Sign Language (UzSL) qoidalari va grammatikasi.',
        totalSteps: 10, // Default steps for each lesson
        completedSteps: LocalStorageService.getInt('lesson_progress_$id', defaultValue: 0),
      );
    });
  }

  Future<void> updateLessonProgress(String id, int completed) async {
    state = [
      for (final lesson in state)
        if (lesson.id == id)
          LessonItem(
            id: lesson.id,
            title: lesson.title,
            description: lesson.description,
            totalSteps: lesson.totalSteps,
            completedSteps: completed.clamp(0, lesson.totalSteps),
          )
        else
          lesson,
    ];
    await LocalStorageService.setInt('lesson_progress_$id', completed);
  }
}
