import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/meditation/presentation/meditation_list_page.dart';
import '../../features/meditation/presentation/meditation_detail_page.dart';
import '../../features/meditation/presentation/fullscreen_verse_card_page.dart';
import '../../features/meditation/presentation/shared_meditation_page.dart';
import '../../features/paywall/presentation/paywall_page.dart';

class AppRouter {
  static const String home = '/';
  static const String meditation = '/meditation';
  static const String meditationDetail = '/meditation/detail';
  
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      // 공유용 묵상 페이지 (독립적인 라우트)
      GoRoute(
        path: '/shared/:date',
        name: 'shared-meditation',
        builder: (context, state) {
          final date = state.pathParameters['date'] ?? '';
          return SharedMeditationPage(date: date);
        },
      ),
      
      // 메인 탭 네비게이션 (애니메이션 완전 제거)
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MainNavigationWrapper(initialIndex: 0),
        ),
      ),
      
      GoRoute(
        path: meditation,
        name: 'meditation',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MainNavigationWrapper(initialIndex: 1),
        ),
      ),
      
      // 페이월 페이지
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder: (context, state) => const PaywallPage(),
      ),
      
      // 묵상 상세 페이지 (탭 네비게이션 없이)
      GoRoute(
        path: '/meditation/detail/:date',
        name: 'meditation-detail',
        builder: (context, state) {
          final date = state.pathParameters['date'] ?? '';
          return MeditationDetailPage(date: date);
        },
        routes: [
          GoRoute(
            path: 'fullscreen',
            name: 'meditation-fullscreen',
            builder: (context, state) {
              final date = state.pathParameters['date'] ?? '';
              return FullscreenVerseCardPage(date: date);
            },
          ),
        ],
      ),
    ],
  );
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(MainNavigationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 위젯이 업데이트될 때마다 initialIndex를 반영
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _currentIndex = widget.initialIndex;
      });
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // 탭 변경 시 해당 URL로 네비게이션
    if (index == 0) {
      context.go('/');
    } else if (index == 1) {
      context.go('/meditation');
    }
  }

  Widget _buildCustomBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // 좌우 24px, 하단 24px 마진 추가
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFF1F3F5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(200), // radius를 200으로 변경
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(
          horizontal: 56,  // Figma 디자인의 56px 패딩
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          _buildNavItem(
            index: 0,
            iconPath: _currentIndex == 0 ? 'assets/images/ic_home_black.svg' : 'assets/images/ic_home_gray.svg',
            label: '홈',
            isSelected: _currentIndex == 0,
          ),
          _buildNavItem(
            index: 1,
            iconPath: _currentIndex == 1 ? 'assets/images/ic_pray_black.svg' : 'assets/images/ic_pray_gray.svg',
            label: '묵상',
            isSelected: _currentIndex == 1,
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onTap(index),
      // 터치 영역을 넓히기 위해 behavior 추가
      behavior: HitTestBehavior.opaque,
      child: Container(
        // 터치 영역을 더 넓게 확장 (디자인은 변경하지 않고 터치만 확장)
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: null, // SVG 자체 색상 사용
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pretendard',
                color: isSelected ? const Color(0xFF212529) : const Color(0xFFADB5BD),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // URL 기반으로 현재 탭 인덱스 결정
    final location = GoRouterState.of(context).uri.path;
    
    // 현재 URL에 따라 올바른 탭 인덱스 설정
    int correctIndex;
    if (location == '/meditation') {
      correctIndex = 1;
    } else {
      correctIndex = 0; // 홈 또는 기타 경로
    }
    
    // 현재 인덱스가 URL과 다르면 setState로 동기화
    if (_currentIndex != correctIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex = correctIndex;
          });
        }
      });
    }
    
    return Scaffold(
      backgroundColor: Colors.white, // 강제로 화이트 배경 설정
      extendBody: true, // body가 bottomNavigationBar 뒤로 확장되도록
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePage(),
          MeditationListPage(),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }
}

