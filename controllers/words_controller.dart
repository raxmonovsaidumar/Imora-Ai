import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

class WordCategory {
  final String title;
  final int totalWords;
  final int learnedWords;
  final List<String> words;

  WordCategory({
    required this.title,
    required this.totalWords,
    required this.learnedWords,
    this.words = const [],
  });

  double get progress => learnedWords / totalWords;
  int get percentage => (progress * 100).round();
}

final wordsProvider = StateNotifierProvider<WordsController, List<WordCategory>>((ref) {
  return WordsController();
});

class WordsController extends StateNotifier<List<WordCategory>> {
  WordsController() : super([]) {
    _loadProgress();
  }

  void _loadProgress() {
    state = [
      _createCategory('Harflar', ['A', 'B', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z', 'Sh', 'Ch', 'O\'', 'G\'', 'Ng']),
      _createCategory('Raqamlar — 1-bosqich', ['Bir', 'Ikki', 'Uch', 'To\'rt', 'Besh', 'Olti', 'Yetti', 'Sakkiz', 'To\'qqiz', 'O\'n']),
      _createCategory('Asosiy salomlashuv', ['Salom', 'Assalomu alaykum', 'Va alaykum assalom', 'Xayr', 'Rahmat', 'Arzimaydi', 'Iltimos', 'Kechirasiz', 'Uzr', 'Yaxshimisiz?', 'Yaxshiman', 'Qalaysiz?', 'Xush kelibsiz', 'Ko\'rishguncha', 'Hayrli tong', 'Hayrli kun', 'Hayrli kech', 'Xayrli tun']),
      _createCategory('Eng asosiy odamlar', ['Men', 'Sen', 'Siz', 'U', 'Biz', 'Ular', 'Odam', 'Inson', 'Bola', 'Qiz', 'O\'g\'il', 'Ayol', 'Erkak', 'Do\'st', 'Mehmon', 'Qo\'shni', 'O\'qituvchi', 'O\'quvchi', 'Shifokor', 'Tarjimon']),
      _createCategory('Oila', ['Oila', 'Ona', 'Ota', 'Opa', 'Aka', 'Uka', 'Singil', 'Bobo', 'Buvi', 'Er', 'Xotin', 'Amaki', 'Tog\'a', 'Xola', 'Amma', 'Jiyan', 'Farzand', 'O\'g\'il', 'Qiz', 'Egizak', 'Qarindosh']),
      _createCategory('Kundalik eng kerakli so\'zlar', ['Uy', 'Xona', 'Eshik', 'Deraza', 'Stul', 'Stol', 'Karavot', 'Yotoq', 'Oshxona', 'Hojatxona', 'Hovli', 'Ko\'cha', 'Mashina', 'Avtobus', 'Telefon', 'Kitob', 'Daftar', 'Qalam', 'Sumka', 'Kiyim']),
      _createCategory('Oziq-ovqat', ['Suv', 'Non', 'Choy', 'Qahva', 'Sut', 'Sharbat', 'Ovqat', 'Go\'sht', 'Tuxum', 'Guruch', 'Sho\'rva', 'Salat', 'Meva', 'Sabzavot', 'Olma', 'Banan', 'Uzum', 'Apelsin', 'Kartoshka', 'Sabzi', 'Piyoz', 'Pomidor', 'Bodring', 'Shakar', 'Tuz']),
      _createCategory('Kundalik amallar', ['Kelmoq', 'Bormoq', 'Kirmoq', 'Chiqmoq', 'O\'tirmoq', 'Turmoq', 'Yurmoq', 'Yugurmoq', 'Yotmoq', 'Uxlamoq', 'Uyg\'onmoq', 'Yemoq', 'Ichmoq', 'Olmoq', 'Bermoq', 'Ko\'rmoq', 'Eshitmoq', 'Gapirmoq', 'O\'qimoq', 'Yozmoq']),
      _createCategory('Asosiy savol so\'zlari', ['Kim?', 'Nima?', 'Qayer?', 'Qayerda?', 'Qayerga?', 'Qayerdan?', 'Qachon?', 'Nega?', 'Nima uchun?', 'Qanday?', 'Qaysi?', 'Qancha?', 'Nechta?', 'Kimning?', 'Nimaning?']),
      _createCategory('Ha / yo\'q / fikr', ['Ha', 'Yo\'q', 'Balki', 'Albatta', 'Mayli', 'Yaxshi', 'Yomon', 'To\'g\'ri', 'Noto\'g\'ri', 'Bilaman', 'Bilmayman', 'Tushundim', 'Tushunmadim', 'Bo\'ladi', 'Bo\'lmaydi', 'Kerak', 'Kerak emas', 'Mumkin', 'Mumkin emas']),
      _createCategory('His-tuyg\'ular', ['Xursand', 'Baxtli', 'Xafa', 'Qo\'rqinchli', 'Qo\'rqmoq', 'Jahl', 'Jahldor', 'Tinch', 'Hayajon', 'Ajablanmoq', 'Sevgi', 'Yoqmoq', 'Yoqmaslik', 'Kulmoq', 'Yig\'lamoq', 'Charchamoq', 'Och', 'Chanqagan', 'Ranjigan', 'Umid']),
      _createCategory('Tana a’zolari', ['Bosh', 'Soch', 'Yuz', 'Ko\'z', 'Qosh', 'Quloq', 'Burun', 'Og\'iz', 'Lab', 'Tish', 'Til', 'Bo\'yin', 'Yelka', 'Qo\'l', 'Kaft', 'Barmoq', 'Tirsak', 'Ko\'krak', 'Qorin', 'Oyoq', 'Tizza', 'Oyoq panjasi']),
      _createCategory('Maktab', ['Maktab', 'Sinf', 'Dars', 'O\'qituvchi', 'O\'quvchi', 'Direktor', 'Kitob', 'Daftar', 'Qalam', 'Ruchka', 'Doska', 'Parta', 'Imtihon', 'Savol', 'Javob', 'Vazifa', 'Uy vazifasi', 'Bahо', 'Fan', 'Matematika', 'Tarix', 'Biologiya', 'Til', 'Adabiyot']),
      _createCategory('Ta’lim va o\'rganish', ['O\'rganmoq', 'O\'rgatmoq', 'Bilmoq', 'Tushunmoq', 'Takrorlamoq', 'Mashq qilmoq', 'Yodlamoq', 'O\'qimoq', 'Yozmoq', 'Tekshirmoq', 'Javob bermoq', 'Savol bermoq', 'Misol', 'Topshiriq', 'Natija', 'Xato', 'To\'g\'ri javob', 'Daraja', 'Boshlang\'ich', 'O\'rta', 'Yuqori']),
      _createCategory('Vaqt', ['Bugun', 'Ertaga', 'Kecha', 'Hozir', 'Keyin', 'Oldin', 'Ertalab', 'Tush', 'Kechqurun', 'Tun', 'Kun', 'Hafta', 'Oy', 'Yil', 'Dushanba', 'Seshanba', 'Chorshanba', 'Payshanba', 'Juma', 'Shanba', 'Yakshanba']),
      _createCategory('Raqamlar — 2-bosqich', ['O\'n bir', 'O\'n ikki', 'O\'n uch', 'O\'n to\'rt', 'O\'n besh', 'O\'n olti', 'O\'n yetti', 'O\'n sakkiz', 'O\'n to\'qqiz', 'Yigirma', 'O\'ttiz', 'Qirq', 'Ellik', 'Oltmish', 'Yetmish', 'Sakson', 'To\'qson', 'Yuz', 'Ming', 'Million']),
      _createCategory('Ranglar', ['Oq', 'Qora', 'Qizil', 'Ko\'k', 'Yashil', 'Sariq', 'Jigarrang', 'Kulrang', 'Pushti', 'Binafsha', 'To\'q sariq', 'Och rang', 'To\'q rang', 'Och ko\'k', 'To\'q ko\'k']),
      _createCategory('Ob-havo va tabiat', ['Quyosh', 'Oy', 'Yulduz', 'Bulut', 'Yomg\'ir', 'Qor', 'Shamol', 'Sovuq', 'Issiq', 'Issiq havo', 'Sovuq havo', 'Ob-havo', 'Bahor', 'Yoz', 'Kuz', 'Qish', 'Daraxt', 'Gul', 'O\'simlik', 'Yer', 'Osmon', 'Daryo', 'Tog\'', 'Dengiz']),
      _createCategory('Joylar', ['Uy', 'Maktab', 'Universitet', 'Do\'kon', 'Bozor', 'Shifoxona', 'Dorixona', 'Bank', 'Kafe', 'Restoran', 'Masjid', 'Bog\'', 'Kutubxona', 'Muzey', 'Stadion', 'Bekat', 'Aeroport', 'Vokzal', 'Ko\'cha', 'Markaz', 'Ofis']),
      _createCategory('Transport', ['Mashina', 'Avtobus', 'Taksi', 'Poyezd', 'Metro', 'Samolyot', 'Kema', 'Velosiped', 'Mototsikl', 'Yo\'l', 'Bekat', 'Aeroport', 'Vokzal', 'Haydovchi', 'Yo\'lovchi', 'Chipta', 'Borish', 'Kelish', 'To\'xtash', 'Burilish']),
      _createCategory('Xarid qilish', ['Pul', 'Narx', 'Arzon', 'Qimmat', 'Sotib olmoq', 'Sotmoq', 'Do\'kon', 'Bozor', 'Sotuvchi', 'Xaridor', 'Mahsulot', 'Kiyim', 'Oyoq kiyim', 'Non', 'Meva', 'Sabzavot', 'Sumka', 'Telefon', 'Chegirma', 'To\'lov', 'Naqd', 'Karta']),
      _createCategory('Sog\'liq', ['Shifokor', 'Hamshira', 'Shifoxona', 'Dorixona', 'Dori', 'Og\'riq', 'Bosh og\'rig\'i', 'Tish og\'rig\'i', 'Isitma', 'Yo\'tal', 'Tumov', 'Yara', 'Kasallik', 'Sog\'lom', 'Tekshiruv', 'Davolash', 'Davo', 'Tez yordam', 'Qon', 'Bosim']),
      _createCategory('Kasblar', ['O\'qituvchi', 'Shifokor', 'Hamshira', 'Muhandis', 'Dasturchi', 'Dizayner', 'Haydovchi', 'Oshpaz', 'Sotuvchi', 'Dehqon', 'Quruvchi', 'Elektrik', 'Politsiyachi', 'Advokat', 'Jurnalist', 'Tarjimon', 'Fotograf', 'Rassom', 'Menejer', 'Tadbirkor']),
      _createCategory('Texnologiya', ['Telefon', 'Kompyuter', 'Noutbuk', 'Planshet', 'Internet', 'Ilova', 'Sayt', 'Dastur', 'Fayl', 'Rasm', 'Video', 'Ovoz', 'Kamera', 'Mikrofon', 'Parol', 'Profil', 'Xabar', 'Chat', 'Video qo\'ng\'iroq', 'Sun’iy intellekt', 'Robot']),
      _createCategory('Ish va biznes', ['Ish', 'Ofis', 'Rahbar', 'Xodim', 'Jamoa', 'Uchrashuv', 'Loyiha', 'Vazifa', 'Reja', 'Natija', 'Mijoz', 'Hamkor', 'Tashkilot', 'Kompaniya', 'Biznes', 'Mahsulot', 'Xizmat', 'Narx', 'Shartnoma', 'Daromad', 'Xarajat', 'Investitsiya', 'Investor', 'Startup', 'Jamoa']),
      _createCategory('Sayohat', ['Sayohat', 'Safar', 'Mehmonxona', 'Xona', 'Pasport', 'Chipta', 'Aeroport', 'Vokzal', 'Samolyot', 'Poyezd', 'Avtobus', 'Yo\'l', 'Manzil', 'Xarita', 'Shahar', 'Qishloq', 'Mehmon', 'Bagaj', 'Kirish', 'Chiqish', 'Rezervatsiya']),
    ];
  }

  WordCategory _createCategory(String title, List<String> words) {
    return WordCategory(
      title: title,
      totalWords: words.length,
      learnedWords: LocalStorageService.getInt('word_progress_$title', defaultValue: 0),
      words: words,
    );
  }

  Future<void> updateProgress(String categoryTitle, int learnedCount) async {
    state = [
      for (final cat in state)
        if (cat.title == categoryTitle)
          WordCategory(
            title: cat.title,
            totalWords: cat.totalWords,
            learnedWords: learnedCount.clamp(0, cat.totalWords),
            words: cat.words,
          )
        else
          cat,
    ];
    await LocalStorageService.setInt('word_progress_$categoryTitle', learnedCount);
  }
}
