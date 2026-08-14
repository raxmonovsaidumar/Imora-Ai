import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(
    const ProviderScope(
      child: SignAiApp(),
    ),
  );
}

class SignAiApp extends StatelessWidget {
  const SignAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignAI',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
