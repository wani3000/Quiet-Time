import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:go_router/go_router.dart';

/// 로컬 알림 관리 서비스
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _isInitialized = false;
  static GlobalKey<NavigatorState>? _navigatorKey;
  
  /// 네비게이터 키 설정 (앱 시작 시 호출)
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }
  
  /// 알림 서비스 초기화
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // 타임존 데이터 초기화
      tz.initializeTimeZones();
      
      // Android 초기화 설정
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS 초기화 설정
      const DarwinInitializationSettings iosSettings = 
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      _isInitialized = true;
      debugPrint('NotificationService 초기화 완료');
    } catch (e) {
      debugPrint('NotificationService 초기화 실패: $e');
    }
  }
  
  /// 알림 탭 시 처리
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('알림 탭됨: ${response.payload}');
    
    // 앱이 실행 중일 때 네비게이션 처리
    try {
      // 현재 컨텍스트가 있는지 확인
      final context = _getCurrentContext();
      if (context != null && context.mounted) {
        // 홈 화면으로 이동
        context.go('/');
        debugPrint('알림 클릭으로 홈 화면으로 이동');
      } else {
        debugPrint('컨텍스트를 찾을 수 없음 - 앱이 종료된 상태에서 알림 클릭');
        // 앱이 종료된 상태에서 알림을 클릭하면 자동으로 앱이 시작되고 홈 화면이 표시됨
        // 이 경우 별도의 네비게이션 처리가 필요하지 않음
      }
    } catch (e) {
      debugPrint('알림 클릭 처리 중 오류: $e');
    }
  }
  
  /// 현재 앱 컨텍스트 가져오기
  static BuildContext? _getCurrentContext() {
    try {
      // 먼저 네비게이터 키를 통해 컨텍스트 가져오기 시도
      if (_navigatorKey?.currentContext != null) {
        return _navigatorKey!.currentContext;
      }
      
      // 네비게이터 키가 없으면 루트 엘리먼트에서 가져오기
      final context = WidgetsBinding.instance.rootElement;
      return context;
    } catch (e) {
      debugPrint('컨텍스트 가져오기 실패: $e');
      return null;
    }
  }
  
  /// 알림 권한 요청
  static Future<bool> requestPermissions() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final bool? result = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        return result ?? false;
      }
      
      if (defaultTargetPlatform == TargetPlatform.android) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        
        final bool? result = await androidImplementation?.requestNotificationsPermission();
        return result ?? false;
      }
      
      return true;
    } catch (e) {
      debugPrint('알림 권한 요청 실패: $e');
      return false;
    }
  }
  
  /// 매일 오전 6시 알림 스케줄링
  static Future<void> scheduleDailyMorningNotification() async {
    try {
      // 기존 알림 취소
      await _notifications.cancel(0);
      
      // 한국 시간대 설정
      final tz.Location seoul = tz.getLocation('Asia/Seoul');
      
      // 오늘 오전 6시
      final now = tz.TZDateTime.now(seoul);
      var scheduledDate = tz.TZDateTime(seoul, now.year, now.month, now.day, 6, 0);
      
      // 만약 현재 시간이 오전 6시를 지났다면 내일 오전 6시로 설정
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'daily_verse_channel',
        '매일 말씀 알림',
        channelDescription: '매일 오전 6시에 새로운 말씀을 알려드립니다.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      );
      
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _notifications.zonedSchedule(
        0, // notification id
        '오늘의 말씀이 도착했어요!',
        '새로운 말씀으로 하루를 시작해보세요.',
        scheduledDate,
        notificationDetails,
        payload: 'daily_verse_notification', // 페이로드 추가
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
      );
      
      debugPrint('매일 오전 6시 알림 스케줄링 완료: $scheduledDate');
    } catch (e) {
      debugPrint('알림 스케줄링 실패: $e');
    }
  }
  
  /// 즉시 테스트 알림 보내기 (개발용)
  static Future<void> showTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'test_channel',
        '테스트 알림',
        channelDescription: '알림 테스트용',
        importance: Importance.high,
        priority: Priority.high,
      );
      
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _notifications.show(
        999, // test notification id
        '오늘의 말씀이 도착했어요!',
        '새로운 말씀으로 하루를 시작해보세요.',
        notificationDetails,
        payload: 'test_notification', // 테스트 알림 페이로드
      );
      
      debugPrint('테스트 알림 전송 완료');
    } catch (e) {
      debugPrint('테스트 알림 전송 실패: $e');
    }
  }
  
  /// 모든 알림 취소
  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      debugPrint('모든 알림 취소 완료');
    } catch (e) {
      debugPrint('알림 취소 실패: $e');
    }
  }
  
  /// 스케줄된 알림 목록 확인 (개발용)
  static Future<void> checkScheduledNotifications() async {
    try {
      final List<PendingNotificationRequest> pendingNotifications = 
          await _notifications.pendingNotificationRequests();
      
      debugPrint('스케줄된 알림 개수: ${pendingNotifications.length}');
      for (final notification in pendingNotifications) {
        debugPrint('알림 ID: ${notification.id}, 제목: ${notification.title}');
      }
    } catch (e) {
      debugPrint('스케줄된 알림 확인 실패: $e');
    }
  }
}
