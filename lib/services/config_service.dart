import 'package:shared_preferences/shared_preferences.dart';

/// 앱 환경 설정 관리 서비스
class ConfigService {
  static const String _installDateKey = 'app_install_date';
  
  /// 환경 설정 초기화
  static Future<void> initialize() async {
    // 앱 설치 날짜 저장 (최초 실행시에만)
    await _saveInstallDateIfNeeded();
  }
  
  /// 앱 설치 날짜를 저장합니다 (최초 실행시에만)
  static Future<void> _saveInstallDateIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 이미 설치 날짜가 저장되어 있으면 건너뛰기
      if (prefs.containsKey(_installDateKey)) {
        return;
      }
      
      // 오늘 날짜를 설치 날짜로 저장
      final today = DateTime.now();
      final dateString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      await prefs.setString(_installDateKey, dateString);
    } catch (e) {
      // 에러가 발생해도 앱 실행에는 문제없도록 처리
      print('설치 날짜 저장 실패: $e');
    }
  }
  
  /// 앱 설치 날짜를 가져옵니다
  static Future<DateTime> getInstallDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString(_installDateKey);
      
      if (dateString != null) {
        return DateTime.parse(dateString);
      }
    } catch (e) {
      print('설치 날짜 불러오기 실패: $e');
    }
    
    // 설치 날짜가 없으면 오늘 날짜 반환
    return DateTime.now();
  }
  
  /// 현재 환경 (dev, staging, prod)
  static String get environment => 'prod';
  
  /// 기본 URL 가져오기
  static String get baseUrl {
    switch (environment) {
      case 'prod':
        return 'https://versecard.app'; // TODO: 실제 도메인으로 변경 필요
      case 'staging':
        return 'https://staging.versecard.app';
      default:
        return 'http://localhost:8081';
    }
  }
  
  /// 공유 URL 생성
  static String getShareUrl(String date) {
    return '$baseUrl/shared/$date';
  }
  
  /// 앱 이름
  static String get appName => '말씀묵상';
  
  /// 앱 버전
  static String get appVersion => '1.0.0';
  
  /// 페이월 기능 활성화 여부
  static bool get isPaywallEnabled => false;
  
  /// 분석 기능 활성화 여부
  static bool get isAnalyticsEnabled => false;
  
  /// 개발 모드 여부
  static bool get isDevelopment => environment == 'dev';
  
  /// 프로덕션 모드 여부
  static bool get isProduction => environment == 'prod';
}

