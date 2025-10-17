import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/verse_card.dart';
import '../../../core/theme/colors.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white, // 다크모드에서도 화이트 배경 강제 설정
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.slate50,
              AppColors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16, 
              right: 16, 
              top: 80,  // 상단에서 80px 떨어지게
              bottom: 24,
            ),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: const VerseCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
