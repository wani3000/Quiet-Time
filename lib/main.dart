import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart' if (dart.library.html) 'package:flutter_web_plugins/url_strategy.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/utils/image_cache_manager.dart';
import 'services/config_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    return MaterialApp.router(
      title: ConfigService.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
