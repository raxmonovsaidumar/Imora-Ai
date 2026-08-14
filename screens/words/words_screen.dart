import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/words_controller.dart';
import '../lessons/lesson_detail_screen.dart';

class WordsScreen extends ConsumerStatefulWidget {
  const WordsScreen({super.key});

  @override
  ConsumerState<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends ConsumerState<WordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = ref.watch(wordsProvider);
    final filteredCategories = allCategories.where((cat) {
      return cat.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'So\'zlar bo\'limini qidirish...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colors.transparent,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              )
            : const Text(
                'So\'zlar',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          children: [
            Text(
              _isSearching ? 'Qidiruv natijalari' : 'Mavzular',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            filteredCategories.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('Hech narsa topilmadi', style: TextStyle(color: Colors.white38)),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredCategories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final cat = filteredCategories[index];
                      final isCompleted = cat.learnedWords == cat.totalWords;
                      return _buildCategoryItem(cat, isCompleted);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(WordCategory cat, bool isCompleted) {
    IconData icon = Icons.wb_sunny_rounded;
    final t = cat.title.toLowerCase();
    if (t.contains('harflar')) icon = Icons.sort_by_alpha_rounded;
    else if (t.contains('raqamlar')) icon = Icons.numbers_rounded;
    else if (t.contains('salom')) icon = Icons.waving_hand_rounded;
    else if (t.contains('oila')) icon = Icons.family_restroom_rounded;
    else if (t.contains('oziq')) icon = Icons.restaurant_rounded;
    else if (t.contains('amallar')) icon = Icons.directions_run_rounded;
    else if (t.contains('savol')) icon = Icons.help_outline_rounded;
    else if (t.contains('tana')) icon = Icons.accessibility_new_rounded;
    else if (t.contains('vaqt')) icon = Icons.access_time_rounded;
    else if (t.contains('ranglar')) icon = Icons.palette_rounded;
    else if (t.contains('joylar')) icon = Icons.place_rounded;
    else if (t.contains('transport')) icon = Icons.directions_bus_rounded;
    else if (t.contains('xarid')) icon = Icons.shopping_cart_rounded;
    else if (t.contains('sog‘liq')) icon = Icons.medical_services_rounded;
    else if (t.contains('kasblar')) icon = Icons.work_rounded;
    else if (t.contains('texno')) icon = Icons.devices_rounded;
    else if (t.contains('ish')) icon = Icons.business_center_rounded;
    else if (t.contains('sayohat')) icon = Icons.flight_takeoff_rounded;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailScreen(categoryTitle: cat.title, isFromWords: true),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green.withOpacity(0.08) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? Colors.green.withOpacity(0.2) : Colors.white10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: isCompleted ? Colors.green.withOpacity(0.8) : Colors.white60),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cat.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCompleted) const Icon(Icons.check_circle_rounded, color: Colors.green, size: 14),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${cat.learnedWords}/${cat.totalWords}',
                  style: TextStyle(
                    color: isCompleted ? Colors.green.withOpacity(0.7) : Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
