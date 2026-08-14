import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/lessons_controller.dart';
import 'lesson_detail_screen.dart';
import 'content/lesson_content_view.dart';

class LessonsScreen extends ConsumerStatefulWidget {
  const LessonsScreen({super.key});

  @override
  ConsumerState<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends ConsumerState<LessonsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToCategories() {
    // No longer needed as we don't have categories here
  }

  @override
  Widget build(BuildContext context) {
    final allLessons = ref.watch(lessonsProvider);
    final filteredLessons = allLessons.where((lesson) {
      return lesson.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Summary of overall progress
    final totalCompleted = allLessons.fold(0, (sum, l) => sum + l.completedSteps);
    final totalSteps = allLessons.fold(0, (sum, l) => sum + l.totalSteps);
    final overallPercentage = totalSteps > 0 ? (totalCompleted / totalSteps * 100).round() : 0;

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
                  hintText: 'Darslarni qidirish...',
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
                'Darslar',
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
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          children: [
            if (!_isSearching) ...[
              _buildOverallProgressCard(
                context,
                overallPercentage,
                totalCompleted,
                totalSteps,
                onContinue: () {
                  _scrollController.animateTo(
                    200,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
            Text(
              _isSearching ? 'Qidiruv natijalari' : 'O\'quv dasturi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            filteredLessons.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('Hech qanday dars topilmadi', style: TextStyle(color: Colors.white38)),
                    ),
                  )
                : Column(
                    children: filteredLessons.map((lesson) => _buildLessonTile(context, lesson)).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonTile(BuildContext context, LessonItem lesson) {
    final isCompleted = lesson.completedSteps == lesson.totalSteps;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            lesson.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                lesson.description,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: lesson.progress,
                        backgroundColor: Colors.white10,
                        color: isCompleted ? Colors.green : Colors.white,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${lesson.percentage}%',
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.white38,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonContentView(
                  lessonId: lesson.id,
                  title: lesson.title,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverallProgressCard(
    BuildContext context, 
    int percentage, 
    int learned, 
    int total,
    {required VoidCallback onContinue}
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Darslar progressi',
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    percentage == 100 ? 'Barchasi o\'tildi! 🎉' : 'O\'quv dasturi: $percentage% tugatildi',
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.black12,
              color: Colors.black,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(percentage == 100 ? 'Qayta takrorlash' : 'Davom ettirish'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, String progress, {bool isCompleted = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.08)
            : Colors.white.withOpacity(0.05),
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
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  if (isCompleted)
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                progress,
                style: TextStyle(
                  color: isCompleted ? Colors.green.withOpacity(0.7) : Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
