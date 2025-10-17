import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../home/widgets/verse_card.dart';

class FullscreenVerseCardPage extends ConsumerWidget {
  final String date;

  const FullscreenVerseCardPage({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 화이트로 변경
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경도 화이트로
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 아이콘 색상을 기본(검정)으로
          onPressed: () {
            context.pop();
          },
        ),
        title: null, // 타이틀 텍스트 제거
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 700,
          ),
          child: VerseCard(
            isThumbnail: false,
            showActions: false,
            date: date,
          ),
        ),
      ),
    );
  }

}
