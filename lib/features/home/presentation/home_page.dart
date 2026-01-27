import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/verse_card.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../services/notification_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<VerseCardState> _verseCardKey = GlobalKey<VerseCardState>();
  bool _isDownloading = false;

  Future<void> _downloadCard() async {
    if (_isDownloading) return;
    
    setState(() {
      _isDownloading = true;
    });
    
    try {
      await _verseCardKey.currentState?.saveCard();
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 다크모드에서도 화이트 배경 강제 설정
      body: Stack(
        children: [
          Container(
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
                  bottom: 140, // 하단 여백 (플로팅 버튼 + 네비게이션 바)
                ),
                child: Column(
                  children: [
                    // 개발 모드에서만 테스트 알림 버튼 표시
                    if (kDebugMode) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            await NotificationService.showTestNotification();
                            if (context.mounted) {
                              ToastUtils.show(context, '테스트 알림을 보냈어요');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '테스트 알림 보내기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: VerseCard(key: _verseCardKey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 플로팅 다운로드 버튼
          Positioned(
            right: 24,
            bottom: 110, // 네비게이션 바 위
            child: GestureDetector(
              onTap: _isDownloading ? null : _downloadCard,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF1F3F5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _isDownloading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.slate600,
                          ),
                        )
                      : const Icon(
                          Icons.download,
                          size: 24,
                          color: AppColors.slate800,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
