import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/words_controller.dart';
import '../../controllers/lessons_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordCategories = ref.watch(wordsProvider);
    final lessons = ref.watch(lessonsProvider);

    final totalLearned = wordCategories.fold(0, (sum, cat) => sum + cat.learnedWords);
    final totalWordsCount = wordCategories.fold(0, (sum, cat) => sum + cat.totalWords);
    final completedWordGroups = wordCategories.where((cat) => cat.learnedWords == cat.totalWords).length;
    final progress = totalWordsCount > 0 ? totalLearned / totalWordsCount : 0.0;
    
    final completedLessons = lessons.where((l) => l.completedSteps == l.totalSteps).length;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Beginner',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(label: 'Darslar', value: '$completedLessons'),
                      _StatItem(label: 'So\'zlar', value: '$totalLearned'),
                      const _StatItem(label: 'Guruhlar', value: '0'), // Or completedWordGroups
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Learning Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${(progress * 100).round()}%', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white10,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) {
                        // For MVP, heights can be related to learned words distribution or 0
                        final heights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, progress];
                        return _BarChart(height: heights[index]);
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSettingsItem(Icons.history_rounded, 'Practice History'),
            _buildSettingsItem(Icons.settings_rounded, 'Settings'),
            _buildSettingsItem(Icons.help_outline_rounded, 'Help & Support'),
            _buildSettingsItem(Icons.logout_rounded, 'Log out', isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : Colors.white70),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
      onTap: () {},
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}

class _BarChart extends StatelessWidget {
  final double height;

  const _BarChart({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 100 * height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1 + (height * 0.4)),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
