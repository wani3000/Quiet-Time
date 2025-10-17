import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../services/config_service.dart';

/// 프리미엄 구독 페이지
class PaywallPage extends ConsumerWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 페이월 기능이 비활성화된 경우 홈으로 리디렉션
    if (!ConfigService.isPaywallEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary50,
              AppColors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.slate600,
                      ),
                    ),
                    const Text(
                      '프리미엄',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate800,
                      ),
                    ),
                    const SizedBox(width: 48), // 균형을 위한 공간
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // 메인 아이콘
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 50,
                    color: AppColors.primary600,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 타이틀
                const Text(
                  '더 깊은 묵상을 위한\n프리미엄 기능',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  '말씀과 함께하는 더 풍성한 묵상 경험을 만나보세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.slate600,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // 기능 목록
                ..._buildFeatureList(),
                
                const SizedBox(height: 48),
                
                // 가격 카드
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary200, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary100.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '월간 프리미엄',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slate900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₩4,900',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary600,
                            ),
                          ),
                          Text(
                            '/월',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.slate600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '언제든지 취소 가능',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 구독 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary600,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '7일 무료 체험 시작하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 약관 텍스트
                const Text(
                  '무료 체험 기간 종료 후 자동으로 구독이 시작됩니다.\n구독은 언제든지 취소할 수 있습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      {
        'icon': Icons.bookmark_added,
        'title': '무제한 메모 저장',
        'description': '모든 묵상 메모를 클라우드에 안전하게 보관',
      },
      {
        'icon': Icons.palette,
        'title': '다양한 카드 템플릿',
        'description': '20가지 이상의 아름다운 말씀카드 디자인',
      },
      {
        'icon': Icons.calendar_today,
        'title': '개인 맞춤 묵상 계획',
        'description': '나만의 읽기 계획과 알림 설정',
      },
      {
        'icon': Icons.cloud_sync,
        'title': '기기 간 동기화',
        'description': '모든 기기에서 동일한 묵상 기록 유지',
      },
      {
        'icon': Icons.insights,
        'title': '묵상 통계 및 인사이트',
        'description': '나의 묵상 패턴과 성장 과정 분석',
      },
    ];

    return features.map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: AppColors.primary600,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature['description'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.slate600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )).toList();
  }

  void _handleSubscribe() {
    // TODO: 실제 구독 로직 구현
    // - 결제 시스템 연동 (예: in_app_purchase 패키지)
    // - 사용자 구독 상태 관리
    // - 서버 API 호출
    
    debugPrint('구독 처리 로직 구현 필요');
    
    // 임시로 성공 메시지만 표시
    // 실제 구현 시에는 결제 프로세스로 연결
  }
}

