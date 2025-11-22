import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart' if (dart.library.html) 'package:flutter_web_plugins/url_strategy.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/utils/image_cache_manager.dart';
import 'services/config_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 시스템 UI 오버레이 스타일을 라이트 모드로 강제 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // 다크 아이콘 (라이트 배경용)
    statusBarBrightness: Brightness.light, // iOS용 라이트 상태바
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  // 환경 설정 초기화
  await ConfigService.initialize();
  
  // 알림 서비스 초기화
  await NotificationService.initialize();
  
  // 알림 권한 요청 및 매일 알림 스케줄링
  final hasPermission = await NotificationService.requestPermissions();
  if (hasPermission) {
    await NotificationService.scheduleDailyMorningNotification();
  }
  
  // 이미지 캐시 초기화
  ImageCacheManager.initialize();
  
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MemoryMonitor(child: VerseCardApp())));
}

class VerseCardApp extends StatelessWidget {
  const VerseCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 네비게이터 키를 알림 서비스에 설정
    NotificationService.setNavigatorKey(AppRouter.router.routerDelegate.navigatorKey);
    
    return MaterialApp.router(
      title: ConfigService.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme, // 다크테마도 라이트테마로 강제 설정
      themeMode: ThemeMode.light, // 항상 라이트모드 사용
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
