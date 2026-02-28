import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum NotificationFrequency { daily, weekly, monthly }

class NotificationScheduleSettings {
  const NotificationScheduleSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
    required this.use24HourFormat,
    required this.frequency,
    required this.weekday,
    required this.dayOfMonth,
  });

  final bool enabled;
  final int hour;
  final int minute;
  final bool use24HourFormat;
  final NotificationFrequency frequency;

  /// 1(월) ~ 7(일)
  final int weekday;

  /// 1 ~ 31
  final int dayOfMonth;

  NotificationScheduleSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    bool? use24HourFormat,
    NotificationFrequency? frequency,
    int? weekday,
    int? dayOfMonth,
  }) {
    return NotificationScheduleSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      frequency: frequency ?? this.frequency,
      weekday: weekday ?? this.weekday,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    );
  }
}

/// 로컬 알림 관리 서비스
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _enabledKey = 'notification_enabled';
  static const String _hourKey = 'notification_hour';
  static const String _minuteKey = 'notification_minute';
  static const String _use24HourFormatKey = 'notification_use_24h_format';
  static const String _frequencyKey = 'notification_frequency';
  static const String _weekdayKey = 'notification_weekday';
  static const String _dayOfMonthKey = 'notification_day_of_month';

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
      tz.initializeTimeZones();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

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

    try {
      final context = _getCurrentContext();
      if (context != null && context.mounted) {
        context.go('/');
        debugPrint('알림 클릭으로 홈 화면으로 이동');
      }
    } catch (e) {
      debugPrint('알림 클릭 처리 중 오류: $e');
    }
  }

  static BuildContext? _getCurrentContext() {
    try {
      if (_navigatorKey?.currentContext != null) {
        return _navigatorKey!.currentContext;
      }
      return WidgetsBinding.instance.rootElement;
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
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return result ?? false;
      }

      if (defaultTargetPlatform == TargetPlatform.android) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notifications
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();

        final bool? result = await androidImplementation
            ?.requestNotificationsPermission();
        return result ?? false;
      }

      return true;
    } catch (e) {
      debugPrint('알림 권한 요청 실패: $e');
      return false;
    }
  }

  static NotificationFrequency _parseFrequency(String? value) {
    switch (value) {
      case 'weekly':
        return NotificationFrequency.weekly;
      case 'monthly':
        return NotificationFrequency.monthly;
      default:
        return NotificationFrequency.daily;
    }
  }

  static String _frequencyToValue(NotificationFrequency frequency) {
    switch (frequency) {
      case NotificationFrequency.daily:
        return 'daily';
      case NotificationFrequency.weekly:
        return 'weekly';
      case NotificationFrequency.monthly:
        return 'monthly';
    }
  }

  /// 저장된 알림 설정 조회
  static Future<NotificationScheduleSettings> getScheduleSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final weekday = prefs.getInt(_weekdayKey) ?? 1;
      final dayOfMonth = prefs.getInt(_dayOfMonthKey) ?? 1;

      return NotificationScheduleSettings(
        enabled: prefs.getBool(_enabledKey) ?? true,
        hour: prefs.getInt(_hourKey) ?? 6,
        minute: prefs.getInt(_minuteKey) ?? 0,
        use24HourFormat: prefs.getBool(_use24HourFormatKey) ?? true,
        frequency: _parseFrequency(prefs.getString(_frequencyKey)),
        weekday: weekday.clamp(1, 7),
        dayOfMonth: dayOfMonth.clamp(1, 31),
      );
    } catch (e) {
      debugPrint('알림 설정 조회 실패: $e');
      return const NotificationScheduleSettings(
        enabled: true,
        hour: 6,
        minute: 0,
        use24HourFormat: true,
        frequency: NotificationFrequency.daily,
        weekday: 1,
        dayOfMonth: 1,
      );
    }
  }

  /// 알림 설정 저장 + 즉시 반영
  static Future<void> updateScheduleSettings(
    NotificationScheduleSettings settings,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_enabledKey, settings.enabled);
      await prefs.setInt(_hourKey, settings.hour);
      await prefs.setInt(_minuteKey, settings.minute);
      await prefs.setBool(_use24HourFormatKey, settings.use24HourFormat);
      await prefs.setString(
        _frequencyKey,
        _frequencyToValue(settings.frequency),
      );
      await prefs.setInt(_weekdayKey, settings.weekday.clamp(1, 7));
      await prefs.setInt(_dayOfMonthKey, settings.dayOfMonth.clamp(1, 31));

      await _applySchedule(settings);
    } catch (e) {
      debugPrint('알림 설정 저장 실패: $e');
    }
  }

  static int _daysInMonth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    }
    return DateTime(year, month + 1, 0).day;
  }

  static Future<void> _applySchedule(
    NotificationScheduleSettings settings,
  ) async {
    await _notifications.cancel(0);

    if (!settings.enabled) return;

    final hasPermission = await requestPermissions();
    if (!hasPermission) return;

    final tz.Location seoul = tz.getLocation('Asia/Seoul');
    final now = tz.TZDateTime.now(seoul);

    late tz.TZDateTime scheduledDate;
    late DateTimeComponents dateTimeComponents;

    if (settings.frequency == NotificationFrequency.daily) {
      scheduledDate = tz.TZDateTime(
        seoul,
        now.year,
        now.month,
        now.day,
        settings.hour,
        settings.minute,
      );

      if (!scheduledDate.isAfter(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      dateTimeComponents = DateTimeComponents.time;
    } else if (settings.frequency == NotificationFrequency.weekly) {
      final int daysToAdd = (settings.weekday - now.weekday + 7) % 7;
      scheduledDate = tz.TZDateTime(
        seoul,
        now.year,
        now.month,
        now.day,
        settings.hour,
        settings.minute,
      ).add(Duration(days: daysToAdd));

      if (!scheduledDate.isAfter(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }
      dateTimeComponents = DateTimeComponents.dayOfWeekAndTime;
    } else {
      final int currentMonthDayCap = _daysInMonth(now.year, now.month);
      final int clampedCurrentDay = settings.dayOfMonth > currentMonthDayCap
          ? currentMonthDayCap
          : settings.dayOfMonth;

      scheduledDate = tz.TZDateTime(
        seoul,
        now.year,
        now.month,
        clampedCurrentDay,
        settings.hour,
        settings.minute,
      );

      if (!scheduledDate.isAfter(now)) {
        final int nextYear = now.month == 12 ? now.year + 1 : now.year;
        final int nextMonth = now.month == 12 ? 1 : now.month + 1;
        final int nextMonthDayCap = _daysInMonth(nextYear, nextMonth);
        final int clampedNextDay = settings.dayOfMonth > nextMonthDayCap
            ? nextMonthDayCap
            : settings.dayOfMonth;

        scheduledDate = tz.TZDateTime(
          seoul,
          nextYear,
          nextMonth,
          clampedNextDay,
          settings.hour,
          settings.minute,
        );
      }

      dateTimeComponents = DateTimeComponents.dayOfMonthAndTime;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_verse_channel',
          '매일 말씀 알림',
          channelDescription: '사용자 설정 주기와 시간에 따라 말씀 알림을 제공합니다.',
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
      0,
      '오늘의 말씀이 도착했어요!',
      '새로운 말씀으로 하루를 시작해보세요.',
      scheduledDate,
      notificationDetails,
      payload: 'daily_verse_notification',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: dateTimeComponents,
    );

    debugPrint(
      '알림 스케줄링 완료: ${settings.frequency} / ${settings.hour}:${settings.minute.toString().padLeft(2, '0')} / next=$scheduledDate',
    );
  }

  /// 앱 시작 시 저장된 설정을 반영
  static Future<void> applySavedScheduleSetting() async {
    final settings = await getScheduleSettings();
    await _applySchedule(settings);
  }

  /// 레거시 메서드 호환
  static Future<bool> isDailyMorningEnabled() async {
    final settings = await getScheduleSettings();
    return settings.enabled;
  }

  /// 레거시 메서드 호환
  static Future<void> setDailyMorningEnabled(bool enabled) async {
    final settings = await getScheduleSettings();
    await updateScheduleSettings(settings.copyWith(enabled: enabled));
  }

  /// 레거시 메서드 호환
  static Future<void> applySavedDailyMorningSetting() async {
    await applySavedScheduleSetting();
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
