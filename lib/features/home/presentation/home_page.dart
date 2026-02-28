import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/verse_card.dart';
import '../../../core/theme/colors.dart';

// 앱 시작 시 첫 실행 여부 (앱 종료 전까지 유지)
bool _hasPlayedInitialAnimation = false;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<VerseCardState> _verseCardKey = GlobalKey<VerseCardState>();
  bool _isDownloading = false;

  // 슬라이드 업 애니메이션
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // 아래에서 위로 슬라이드 (0.3 = 30% 아래에서 시작)
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // 페이드 인 효과
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // 앱 첫 실행 시에만 애니메이션 재생
    if (!_hasPlayedInitialAnimation) {
      _hasPlayedInitialAnimation = true;
      // 약간의 딜레이 후 애니메이션 시작 (화면 렌더링 완료 대기)
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else {
      // 이미 재생했으면 바로 완료 상태로
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[now.weekday - 1];
    return '${now.month}월 ${now.day}일 $weekday요일';
  }

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
                colors: [AppColors.slate50, AppColors.white],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 헤더 타이틀 + 날짜
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 12,
                      top: 16,
                      bottom: 24,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '오늘 주신 말씀',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard',
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getFormattedDate(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                  color: Color(0xFF868E96),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.push('/menu'),
                          icon: const Icon(
                            Icons.menu,
                            size: 24,
                            color: Colors.black,
                          ),
                          tooltip: '메뉴',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 140, // 하단 여백 (플로팅 버튼 + 네비게이션 바)
                      ),
                      child: Column(
                        children: [
                          // 슬라이드 업 + 페이드 인 애니메이션
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    final now = DateTime.now();
                                    final today =
                                        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                                    context.push(
                                      '/meditation/detail/$today?from=home',
                                    );
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: VerseCard(key: _verseCardKey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 플로팅 다운로드 버튼
          Positioned(
            right: 24,
            bottom: 130, // 네비게이션 바 위 20px 여유
            child: GestureDetector(
              onTap: _isDownloading ? null : _downloadCard,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF1F3F5), width: 1),
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
