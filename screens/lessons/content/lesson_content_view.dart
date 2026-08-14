import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/lessons_controller.dart';

class LessonContentView extends ConsumerWidget {
  final String lessonId;
  final String title;

  const LessonContentView({
    super.key,
    required this.lessonId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only lesson_1 has detailed content for now
    if (lessonId == 'lesson_1') {
      return _buildIntroductionLesson(context, ref);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title, style: const TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Ushbu dars kontenti tayyorlanmoqda...',
          style: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildIntroductionLesson(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              background: Container(color: Colors.white.withOpacity(0.05)),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildContentSection(
                  "1. Imo-ishora tili nima?",
                  "Imo-ishora tili — bu asosan qo'l harakatlari, yuz ifodalari (mimika) va tana holati orqali muloqot qilish uchun ishlatiladigan to'laqonli va tabiiy tildir. Bu til faqat \"qo'llar bilan gapirish\" emas, balki o'ziga xos murakkab tuzilishga ega bo'lgan vizual-fazoviy tildir.",
                ),
                _buildContentSection(
                  "2. Imo-ishora tili va jestlar farqi",
                  "Jestlar (imo-ishoralar) — bu og'zaki nutqni to'ldiruvchi yordamchi harakatlardir (masalan, \"xayr\" deb qo'l silkitish). Imo-ishora tili esa mustaqil til bo'lib, u orqali eng murakkab mavzularda, falsafiy g'oyalardan tortib ilmiy tushunchalargacha bemalol muloqot qilish mumkin.",
                ),
                _buildContentSection(
                  "3. Tabiiy imo-ishora tili nima?",
                  "Tabiiy imo-ishora tili — bu kar va zaif eshituvchi insonlar jamoasida o'z-o'zidan, tabiiy ravishda shakllangan tildir. U sun'iy ravishda yaratilmagan va avloddan-avlodga ona tili sifatida o'tib keladi.",
                ),
                _buildContentSection(
                  "4. UzSL nima?",
                  "UzSL (Uzbek Sign Language) — O'zbekistondagi kar va zaif eshituvchi insonlar tomonidan qo'llaniladigan milliy o'zbek imo-ishora tilidir. U O'zbekiston hududida o'ziga xos madaniyat va muloqot an'analarini aks ettiradi.",
                ),
                _buildContentSection(
                  "5. UzSL va og'zaki o'zbek tili farqi",
                  "UzSL og'zaki o'zbek tilining qo'l bilan ko'rsatiladigan varianti emas. Ularning grammatikasi tubdan farq qiladi. UzSL vizual mantiqqa asoslanadi, og'zaki til esa tovushli mantiqqa. Masalan, UzSLda gap bo'laklarining tartibi og'zaki tildagidan butunlay boshqacha bo'lishi mumkin.",
                ),
                _buildContentSection(
                  "6. UzSL va daktil alifbo farqi",
                  "Daktil alifbo — bu har bir harfni qo'l bilan ko'rsatishdir. U asosan ismlar yoki maxsus atamalarni aytish uchun ishlatiladi. Imo-ishora tili (UzSL) esa bitta harakat bilan butun bir tushuncha yoki so'zni anglatadi.",
                ),
                _buildContentSection(
                  "7. Imo-ishora tilining mustaqil til ekanligi",
                  "Imo-ishora tillari tilshunoslikda rasman mustaqil tillar sifatida tan olingan. Ularning o'z lug'at boyligi, morfologiyasi va sintaksisi mavjud. Ular hech qanday og'zaki tilga \"yordamchi\" emas.",
                ),
                _buildContentSection(
                  "8. Imo-ishora tilida grammatika mavjudligi",
                  "Ha, imo-ishora tilida juda murakkab grammatika bor. Gaplardagi vaqt (o'tgan, hozirgi, kelasi), son (birlik, ko'plik) va inkor shakllari qo'lning harakati, yo'nalishi va yuz ifodalari orqali aniq ifodalanadi.",
                ),
                _buildContentSection(
                  "9. Imo-ishora tilida mimikaning o'rni",
                  "Mimika (non-manual belgilar) imo-ishora tilining \"ohangi\" hisoblanadi. Bir xil qo'l harakati yuz ifodasiga qarab savol, buyruq yoki oddiy gap bo'lishi mumkin. Mimika gapning hissiy bo'yog'ini va grammatik turini belgilaydi.",
                ),
                _buildContentSection(
                  "10. Imo-ishora tilida makondan foydalanish",
                  "Imo-ishora tilida muloqot qiluvchi inson atrofidagi bo'shliqdan (fazodan) grammatik maqsadlarda foydalanadi. Ob'ektlarni fazoda joylashtirish orqali ular orasidagi munosabatlarni, masofani va o'zaro bog'liqlikni ko'rsatish mumkin.",
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () async {
                    await ref.read(lessonsProvider.notifier).updateLessonProgress(lessonId, 10);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dars yakunlandi! Progress yangilandi.')),
                    );
                  },
                  child: const Text('DARSNI YAKUNLASH'),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
